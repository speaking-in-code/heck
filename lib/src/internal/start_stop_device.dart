import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:built_value/serializer.dart';
import 'package:heck/heck.dart';
import 'package:heck/src/internal/get_simulators.dart';
import 'package:heck/src/models/simulators.dart';

import 'command.dart';
import 'models/flutter_devices.dart';
import 'models/serializers.dart';
import 'data/adb_change_language_apk.g.dart' as lang_change;

class StartStopDevice {
  final HeckSDKConfig _sdkConfig;

  StartStopDevice(this._sdkConfig);

  Future<HeckRunningDevice> startDevice({
    required HeckDeviceType deviceType,
    required String name,
    required String locale,
    required Duration timeout,
  }) {
    final stopTime = DateTime.now().add(timeout);
    switch (deviceType) {
      case HeckDeviceType.ios:
        return startIOS(
          deviceType: deviceType,
          name: name,
          locale: locale,
          stopTime: stopTime,
        );
      case HeckDeviceType.android:
        return startAndroid(
          deviceType: deviceType,
          name: name,
          locale: locale,
          stopTime: stopTime,
        );
      default:
        throw HeckException('Unimplemented device type $deviceType');
    }
  }

  Future<IOSDevice> _findIOSDevice(String name) async {
    final sims = await GetSimulators(_sdkConfig).getSimulators();
    for (final sim in sims.iosDevices) {
      if (sim.id == name) {
        return sim;
      }
    }
    for (final sim in sims.iosDevices) {
      if (sim.name == name) {
        return sim;
      }
    }
    throw HeckException('Unable to locate simulator $name. Found: $sims');
  }

  Future<void> _setLocale(IOSDevice device, String locale) async {
    // Note: creating the preferences file is only necessary if the sim has
    // not previously been booted. First boot will create a number of new values
    // in the prefs file.
    final prefs = path.join(
        device.dataPath, 'Library/Preferences/.GlobalPreferences.plist');
    if (!File(prefs).existsSync()) {
      final create = await Command(_sdkConfig.plutil!, [
        '-create',
        'binary1',
        prefs,
      ]).run();
      if (create.exitCode != 0) {
        throw HeckException(
            'Could not create empty simulator properties: $create');
      }
    }
    final locales = [
      locale.replaceAll('_', '-'),
    ];
    // Should we also set AppleKeyboards and ApplePasscodeKeyboards too...?
    final result = await Command(_sdkConfig.plutil!, [
      '-replace',
      'AppleLanguages',
      '-json',
      jsonEncode(locales),
      prefs,
    ]).run();
    if (result.exitCode != 0) {
      throw HeckException('Could not update simulator locale: $result');
    }
  }

  Future<HeckRunningDevice> startIOS({
    required HeckDeviceType deviceType,
    required String name,
    required String locale,
    required DateTime stopTime,
  }) async {
    IOSDevice found = await _findIOSDevice(name);
    if (locale.isNotEmpty) {
      await _setLocale(found, locale);
    }
    // Open the GUI for Simulator, so that the user can see that it is actually
    // running. Note that this has the unfortunate side-effect of booting a
    // simulator by default.
    //
    // That can be changed from the preferences for Simulator, but it's less
    // than helpful.
    await Command(_sdkConfig.open!, [
      _sdkConfig.simulator!,
    ]).runBackground(streamOutput: true);
    // Try to stop the device if it's already running.
    await Command(_sdkConfig.xcrun!, ['simctl', 'shutdown', found.id]).run();
    // Now start it up.
    final running =
        await Command(_sdkConfig.xcrun!, ['simctl', 'boot', found.id])
            .runBackground(streamOutput: true);
    final device = HeckRunningDevice(
        platform: HeckDeviceType.ios, id: found.id, command: running);
    await _waitForPredicateOnDevice(device, stopTime, _flutterConnects);
    return device;
  }

  Future<HeckRunningDevice> startAndroid({
    required HeckDeviceType deviceType,
    required String name,
    required String locale,
    required DateTime stopTime,
  }) async {
    final port = await _findOpenPort();
    final args = ['-avd', name, '-port', '$port', '-no-snapshot-save'];
    final command = Command(_sdkConfig.emulator!, args);
    final running = await command.runBackground(streamOutput: true);
    final device = HeckRunningDevice(
        platform: HeckDeviceType.android,
        id: 'emulator-$port',
        command: running);
    await _waitForAndroidReady(device, stopTime);
    if (locale.isNotEmpty) {
      await _changeAndroidLocale(device, locale);
    }
    return device;
  }

  // Changing locales on Android is tricky. There are several options. In this
  // code, we install an application that has permission to change locales. This
  // works even on Google Play enabled devices, and seems backwards compatible
  // with older versions of Android.
  //
  // We use this app:
  // https://play.google.com/store/apps/details?id=net.sanapeli.adbchangelanguage&hl=en_US&gl=US
  //
  // It looks like rewriting that app from scratch would be pretty easy. To use
  // a different app, run tools/embed-apk.dart.
  //
  // Other approaches that were tried and failed:
  //
  // adb: setprop persist.sys.locale
  // Docs: https://developer.android.com/guide/topics/resources/localization#changing-the-emulator-locale-from-the-adb-shell
  // This fails on google play enabled device, because it's not rooted.
  //
  // emulator: -change-locale flag
  // Docs: https://androidstudio.googleblog.com/2019/06/emulator-2910-canary.html
  // Also fails on google play enabled devices. Also in my testing it seems like
  // the emulator sometimes completely ignores this flag, even if the device
  // should be compatible.
  Future<void> _changeAndroidLocale(
      HeckRunningDevice device, String inputLocale) async {
    Directory? workDir;
    // <sigh>. There is a lot going on in Android locale world. Sometimes the
    // format is something like fr-FR, other times fr-rFR. This might need some
    // work before it is reliable.
    //
    // We use an input locale of ll_CC. This maps it to ll-rCC
    final androidLocale = inputLocale.replaceAll('_', '-r');
    try {
      workDir = await Directory.systemTemp.createTemp('heck');
      final apkPath = path.join(workDir.path, 'adb_change_language.apk');
      await File(apkPath).writeAsBytes(lang_change.apk, flush: true);
      final install =
          await Command(_sdkConfig.adb!, ['-s', device.id, 'install', apkPath])
              .run();
      if (install.exitCode != 0) {
        throw HeckException('Failed to install locale changer app: $install');
      }
      final perms = await Command(_sdkConfig.adb!, [
        '-s',
        device.id,
        'shell',
        'pm',
        'grant',
        'net.sanapeli.adbchangelanguage',
        'android.permission.CHANGE_CONFIGURATION'
      ]).run();
      if (perms.exitCode != 0) {
        throw HeckException('Failed to grant locale change permission: $perms');
      }
      final change = await Command(_sdkConfig.adb!, [
        '-s',
        device.id,
        'shell',
        'am',
        'start',
        '-n',
        'net.sanapeli.adbchangelanguage/.AdbChangeLanguage',
        '-e',
        'language',
        androidLocale,
      ]).run();
      // I think the actual change is asynchronous, hard to know if this
      // actually worked.
      if (change.exitCode != 0) {
        throw HeckException('Failed to change locale: $change');
      }
    } finally {
      await workDir?.delete(recursive: true);
    }
  }

  // Android qemu emulation uses even numbered ports in this range for
  // communication. We pick an open one, then tell qemu to use that one so that
  // the emulator name in adb devices/flutter devices is predictable.
  static final int _minPort = 5554;
  static final int _maxPort = 5584;

  static Future<int> _findOpenPort() async {
    for (int port = _minPort; port <= _maxPort; port += 2) {
      ServerSocket? socket;
      try {
        socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
        return port;
      } on SocketException {
        continue;
      } finally {
        socket?.close();
      }
    }
    // This will probably go badly, but let's try anyway.
    return _minPort;
  }

  static const _cleanupTime = Duration(seconds: 10);

  Future<void> _waitForPredicateOnDevice(
      HeckRunningDevice starting,
      DateTime stopTime,
      Future<bool> Function(HeckRunningDevice) predicate) async {
    while (DateTime.now().isBefore(stopTime) &&
        starting.command.exitCode == null) {
      if (await predicate(starting)) {
        return;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    if (starting.command.exitCode != null) {
      throw HeckException('Emulator exited early: ${starting.command}');
    }
    // Never became ready, never exited. Stop the emulator.
    await _shutdown(starting);
    throw HeckException(
        'Timed out before ${starting.id} was ready: ${starting.command}');
  }

  // Android devices are ready once flutter can connect and the Activity Manager
  // has started up and can respond to commands. Note that the home screen
  // might not have rendered yet!
  Future<void> _waitForAndroidReady(
      HeckRunningDevice starting, DateTime stopTime) async {
    await _waitForPredicateOnDevice(starting, stopTime, _flutterConnects);
    await _waitForPredicateOnDevice(
        starting, stopTime, _activityManagerRunning);
  }

  Future<bool> _flutterConnects(HeckRunningDevice starting) async {
    final devices = await _listConnected();
    for (final device in devices.devices) {
      if (device.id == starting.id) {
        return true;
      }
    }
    return false;
  }

  Future<bool> _activityManagerRunning(HeckRunningDevice device) async {
    final maintenance = await Command(_sdkConfig.adb!, [
      '-s',
      device.id,
      'shell',
      'am',
      'stack',
      'list',
    ]).run();
    // Fails with an error message about not being able to connect to the
    // activity manager, succeeds with stack id output. Error code seems to
    // not contain any helpful information.
    return maintenance.stdout.contains('Stack id=');
  }

  Future<void> _shutdown(HeckRunningDevice running) async {
    final cleanupTime = DateTime.now().add(_cleanupTime);
    running.command.process.kill(ProcessSignal.sigterm);
    while (running.command.exitCode == null &&
        DateTime.now().isBefore(cleanupTime)) {
      await Future.delayed(const Duration(seconds: 1));
    }
    if (running.command.exitCode == null) {
      running.command.process.kill(ProcessSignal.sigkill);
    }
  }

  Future<FlutterDevices> _listConnected() async {
    final result =
        await Command(_sdkConfig.flutter!, ['devices', '--machine']).run();
    if (result.exitCode != 0) {
      throw HeckException('flutter device list failed: $result');
    }
    try {
      final array = jsonDecode(result.stdout);
      if (array is! List<dynamic>) {
        throw HeckException('flutter device unexpected output: $result');
      }
      final devices = FlutterDevicesBuilder();
      for (final element in array) {
        final device =
            serializers.deserializeWith(FlutterDevice.serializer, element);
        if (device == null) {
          throw HeckException('Failed to deserialize: $result');
        }
        devices.devices.add(device);
      }
      return devices.build();
    } on DeserializationError catch (e) {
      throw HeckException.fromError(
          'flutter devices unexpected output: $result', e);
    } on FormatException catch (e) {
      throw HeckException('flutter devices unexpected output: $result', e);
    }
  }

  static const _oneSecond = Duration(seconds: 1);

  /// Stops a device, throws an exception if the device cannot be stopped.
  Future<void> stopDevice({
    required HeckRunningDevice device,
    required Duration timeout,
  }) async {
    switch (device.platform) {
      case HeckDeviceType.android:
        return _stopAndroidDevice(device: device, timeout: timeout);
      case HeckDeviceType.ios:
        return _stopIOSDevice(device: device, timeout: timeout);
    }
  }

  Future<void> _stopAndroidDevice({
    required HeckRunningDevice device,
    required Duration timeout,
  }) async {
    print('Trying to kill ${device.id}: ${device.command}');
    final cleanupTime = DateTime.now().add(timeout).subtract(_oneSecond);
    // Gentle termination signal, give the process time to exit.
    device.command.process.kill(ProcessSignal.sigterm);
    while (device.command.exitCode == null &&
        DateTime.now().isBefore(cleanupTime)) {
      await Future.delayed(_oneSecond);
    }
    // Try harder if needed.
    if (device.command.exitCode == null) {
      device.command.process.kill(ProcessSignal.sigkill);
      await Future.delayed(_oneSecond);
    }
    if (device.command.exitCode == null) {
      throw HeckException('Failed to stop device: ${device.command}');
    }
  }

  Future<bool> _deviceIsRunning(String id) async {
    final devices = await _listConnected();
    for (final device in devices.devices) {
      if (device.id == id) {
        return true;
      }
    }
    return false;
  }

  Future<void> _stopIOSDevice({
    required HeckRunningDevice device,
    required Duration timeout,
  }) async {
    final stopping =
        await Command(_sdkConfig.xcrun!, ['simctl', 'shutdown', device.id])
            .run();
    if (stopping.exitCode != 0) {
      throw HeckException('Failed to stop ${device.id}: $stopping');
    }
    final stopTime = DateTime.now().add(timeout);
    bool running = await _deviceIsRunning(device.id);
    while (DateTime.now().isBefore(stopTime) && running) {
      await Future.delayed(_oneSecond);
      running = await _deviceIsRunning(device.id);
    }
    if (running) {
      throw HeckException('Failed to stop device: ${device.command}');
    }
  }
}

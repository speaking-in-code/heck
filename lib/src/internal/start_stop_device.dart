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
    final running =
        await Command(_sdkConfig.xcrun!, ['simctl', 'boot', found.id])
            .runBackground(streamOutput: true);
    final device = HeckRunningDevice(id: found.id, command: running);
    await _waitForReady(device, stopTime);
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
    if (locale.isNotEmpty) {
      args.addAll(['-change-locale', locale]);
    }
    final command = Command(_sdkConfig.emulator!, args);
    final running = await command.runBackground(streamOutput: true);
    final device = HeckRunningDevice(id: 'emulator-$port', command: running);
    await _waitForReady(device, stopTime);
    return device;
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

  Future<void> _waitForReady(
      HeckRunningDevice starting, DateTime stopTime) async {
    while (DateTime.now().isBefore(stopTime) &&
        starting.command.exitCode == null) {
      final devices = await _listConnected();
      print('Looking for ${starting.id}, found devices: $devices');
      for (final device in devices.devices) {
        if (device.id == starting.id) {
          return;
        }
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
}

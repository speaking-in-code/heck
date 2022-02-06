import 'package:emulators/emulators.dart';
import 'package:emulators/src/adb.dart';
import 'package:emulators/src/avdmanager.dart';
import 'package:emulators/src/command.dart';
import 'package:emulators/src/device.dart';
import 'package:emulators/src/emulator.dart';
import 'package:emulators/src/running_emulator.dart';
import 'package:emulators/src/sdk_config.dart';

import 'flutter.dart';
import 'models/flutter_devices.dart';

class Emulators {
  final SDKConfig _sdkConfig;

  Emulators(this._sdkConfig);

  Future<List<RunningDevice>> listRunning() async {
    final command = Command(_sdkConfig.adb!, ['devices']);
    return ADB.listRunning(command);
  }

  Future<List<String>> listSystemImages() async {
    final command = Command(_sdkConfig.avdmanager!,
        ['create', 'avd', '-k', 'no-such-image', '-n', 'unused-name']);
    return AVDManager.listSystemImages(command);
  }

  Future<List<String>> listSkins() async {
    final command = Command(_sdkConfig.avdmanager!, ['list', 'devices']);
    return AVDManager.listSkins(command);
  }

  Future<void> createDevice(
      {required String name,
      required String skin,
      required String image}) async {
    final command = Command(_sdkConfig.avdmanager!, [
      'create',
      'avd',
      '--package',
      image,
      '--device',
      skin,
      '--name',
      name
    ]);
    return AVDManager.createDevice(command);
  }

  Future<void> deleteDevice(String name) async {
    final command =
        Command(_sdkConfig.avdmanager!, ['delete', 'avd', '--name', name]);
    return AVDManager.deleteDevice(command);
  }

  Future<RunningEmulator> startDevice(String name) {
    return Emulator.startDevice(_sdkConfig, name);
  }

  Future<FlutterDevices> listConnected() async {
    final command = Command(_sdkConfig.flutter!, ['devices', '--machine']);
    return Flutter.devices(command);
  }

  Future<void> waitForDevice(String name,
      {timeout = const Duration(minutes: 1)}) async {
    final stop = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(stop)) {
      final devices = await listConnected();
      for (final device in devices.devices) {
        if (device.name == name) {
          return;
        }
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    throw EmulatorException('Timed out before $name was ready');
  }

  Future<void> waitForEmulator(RunningEmulator emulator,
      {timeout = const Duration(minutes: 1)}) async {
    final stop = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(stop)) {
      if (emulator.command.exitCode != null) {
        throw EmulatorException('Emulator stopped: $emulator');
      }
      final devices = await listConnected();
      for (final device in devices.devices) {
        if (device.name == emulator.name) {
          return;
        }
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    throw EmulatorException('Timed out before $emulator was ready');
  }
}

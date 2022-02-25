import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'internal/adb.dart';
import 'internal/avdmanager.dart';
import 'internal/command.dart';
import 'internal/device.dart';
import 'internal/emulator.dart';
import 'heck_exception.dart';
import 'internal/running_emulator.dart';
import 'sdk_config.dart';
import 'internal/flutter.dart';
import 'internal/models/flutter_devices.dart';
import 'internal/models/system_image.dart';

// TODO: change these apis to use built_value/built_collection objects
// where that makes sense.
class Heck {
  final SDKConfig _sdkConfig;

  Heck(this._sdkConfig);

  Future<List<RunningDevice>> listRunning() async {
    final command = Command(_sdkConfig.adb!, ['devices']);
    return ADB.listRunning(command);
  }

  Future<BuiltList<SystemImage>> listSystemImages() async {
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

  Future<RunningEmulator> startDevice(String name, {String locale = ''}) {
    return Heck.startDevice(_sdkConfig, name, locale: locale);
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
    throw HeckException('Timed out before $name was ready');
  }

  Future<void> waitForEmulator(RunningEmulator emulator,
      {timeout = const Duration(minutes: 1)}) async {
    final stop = DateTime.now().add(timeout);
    FlutterDevices? devices;
    while (DateTime.now().isBefore(stop)) {
      if (emulator.command.exitCode != null) {
        throw HeckException('Emulator stopped: ${emulator.command}');
      }
      devices = await listConnected();
      for (final device in devices.devices) {
        if (device.id == emulator.id) {
          return;
        }
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    throw HeckException(
        'Timed out before ${emulator.id} was ready. Available devices: $devices');
  }

  Future<void> stopEmulator(RunningEmulator emulator,
      {timeout = const Duration(seconds: 5)}) async {
    final stop = DateTime.now().add(timeout);
    emulator.command.process.kill(ProcessSignal.sigterm);
    while (emulator.command.exitCode == null && DateTime.now().isBefore(stop)) {
      await Future.delayed(const Duration(seconds: 1));
    }
    if (emulator.command.exitCode == null) {
      print('Killing with prejudice');
      final out = emulator.command.process.kill(ProcessSignal.sigkill);
      print('Kill response: $out');
    }
  }

  Future<CommandResult> flutterDrive(
      {required String deviceId,
      required String? workingDirectory,
      required Iterable<String> options}) async {
    return Flutter.flutterDrive(_sdkConfig,
        deviceId: deviceId,
        workingDirectory: workingDirectory,
        options: options);
  }
}

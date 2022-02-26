import 'dart:io';

import 'package:heck/src/internal/create_device.dart';

import 'heck_sdk_config.dart';
import 'models/simulators.dart';
import 'internal/get_simulators.dart';

/*
//import 'package:built_collection/built_collection.dart';
//import 'internal/adb.dart';
//import 'internal/avdmanager.dart';
import 'internal/command.dart';
//import 'internal/device.dart';
//import 'internal/emulator.dart';
import 'heck_exception.dart';
import 'internal/running_emulator.dart';
import 'internal/flutter.dart';
import 'internal/models/flutter_devices.dart';
//import 'internal/models/system_image.dart';

 */

/// Helpful Emulator Control Kit.
/// Example usage:
///    final heck = Heck(await HeckSDKConfig.loadDefaults());
///    final sims = await heck.getSimulators();
class Heck {
  final HeckSDKConfig _sdkConfig;

  Heck(this._sdkConfig);

  /// Retrieve all of the available simulators. This includes
  /// - possible form factors (e.g. Nexus 9, or iPhone 6)
  /// - possible runtimes (e.g. Android 23, iOS 10.3.1)
  /// - virtual devices (e.g. particular simulators that have already been
  ///   created.
  Future<Simulators> getSimulators() async {
    return GetSimulators(_sdkConfig).getSimulators();
  }

  Future<String> createDevice(
      {required HeckDeviceType deviceType,
      required String name,
      required String formFactor,
      required String runtime,
      int storageMegs = 0}) async {
    return CreateDevice(_sdkConfig).createDevice(
        deviceType: deviceType,
        name: name,
        formFactor: formFactor,
        runtime: runtime,
        storageMegs: storageMegs);
  }

  /*
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

   */
  /*

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

   */
}

enum HeckDeviceType {
  ios,
  android,
}

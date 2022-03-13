import 'package:heck/src/internal/command.dart';
import 'package:heck/src/internal/create_device.dart';
import 'package:heck/src/internal/delete_device.dart';
import 'package:heck/src/internal/start_stop_device.dart';
import 'package:heck/src/heck_sdk_config.dart';
import 'package:heck/src/models/simulators.dart';
import 'package:heck/src/internal/get_simulators.dart';

import 'internal/flutter_drive.dart';

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

  /// Create the specified device and return the device ID to use for future
  /// commands involving the device.
  ///
  /// deviceType: type of device
  /// name: a name for the device. For Android, existing devices with this name
  ///   are replaced. For iOS, a new device with the same name is created.
  /// formFactor: the type of the device to create.
  /// runtime: the OS runtime for the device.
  /// storageMegs: (Android only) MB of additional storage for the device.
  /// TODO: can runtime be optional here??
  Future<String> createDevice({
    required HeckDeviceType deviceType,
    required String name,
    required String formFactor,
    required String runtime,
    int storageMegs = 0,
  }) async {
    return CreateDevice(_sdkConfig).createDevice(
      deviceType: deviceType,
      name: name,
      formFactor: formFactor,
      runtime: runtime,
      storageMegs: storageMegs,
    );
  }

  /// Delete the specified device.
  Future<void> deleteDevice({
    required HeckDeviceType deviceType,
    required String name,
  }) async {
    return DeleteDevice(_sdkConfig).deleteDevice(
      deviceType: deviceType,
      name: name,
    );
  }

  // Note: need to add some tests for locale settings here.
  /// Starts the specified device and wait for it to be ready.
  /// Arguments
  ///   deviceType: type of device
  ///   name: name of the emulator to start
  ///   locale: locale to use, in xx_YY, where xx is the language
  ///   code and yy is the country code, e.g. fr_CA for french canadian.
  ///   timeout: how long to wait for device to be ready.
  /// Returns
  ///   The id of the device, which can be used with flutter driver.
  Future<HeckRunningDevice> startDevice(
      {required HeckDeviceType deviceType,
      required String name,
      String locale = '',
      Duration timeout = const Duration(minutes: 1)}) async {
    return StartStopDevice(_sdkConfig).startDevice(
      deviceType: deviceType,
      name: name,
      locale: locale,
      timeout: timeout,
    );
  }

  /// Stops the specified device.
  Future<void> stopDevice({
    required HeckRunningDevice device,
    Duration timeout = const Duration(seconds: 10),
  }) {
    return StartStopDevice(_sdkConfig)
        .stopDevice(device: device, timeout: timeout);
  }

  /// Run the specified flutter drive command against the specified device.
  /// TODO: CommandResult is maybe not the best output structure here.
  Future<CommandResult> flutterDrive({
    required String deviceId,
    String? workingDirectory,
    required Iterable<String> arguments,
  }) async {
    return FlutterDrive(_sdkConfig).drive(
        deviceId: deviceId,
        workingDirectory: workingDirectory,
        arguments: arguments);
  }
}

enum HeckDeviceType {
  ios,
  android,
}

// TODO: think through the public interface here. This is a lot.
class HeckRunningDevice {
  final String id;
  final RunningCommand command;

  HeckRunningDevice({required this.id, required this.command});
}

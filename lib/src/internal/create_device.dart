import 'package:heck/heck.dart';
import 'package:heck/src/heck_sdk_config.dart';
import 'package:heck/src/internal/command.dart';

class CreateDevice {
  final HeckSDKConfig _sdkConfig;
  CreateDevice(this._sdkConfig);

  Future<String> createDevice({
    required HeckDeviceType deviceType,
    required String name,
    required String formFactor,
    required String runtime,
    required int storageMegs,
  }) {
    switch (deviceType) {
      case HeckDeviceType.ios:
        if (storageMegs != 0) {
          throw HeckException('Configuring storage size not supported for iOS');
        }
        return createIOS(
          name: name,
          formFactor: formFactor,
          runtime: runtime,
        );
      case HeckDeviceType.android:
        return createAndroid(
          name: name,
          formFactor: formFactor,
          runtime: runtime,
          storageMegs: storageMegs,
        );
      default:
        throw HeckException('Unimplemented device type $deviceType');
    }
  }

  static final _uuidPattern =
      RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$');
  Future<String> createIOS({
    required String name,
    required String formFactor,
    required String runtime,
  }) async {
    final command = Command(_sdkConfig.xcrun!, [
      'simctl',
      'create',
      name,
      formFactor,
      runtime,
    ]);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Failed to create device: $result');
    }
    // Example output format
    // No runtime specified, using 'iOS 15.2 (15.2 - 19C51) - com.apple.CoreSimulator.SimRuntime.iOS-15-2'
    // 17EABC99-CCCB-4BDF-937D-349F98F935D2
    final outLines = result.stdout.split('\n');
    if (outLines.isEmpty) {
      throw HeckException('Could not find device ID: $result');
    }
    for (final uuid in outLines.reversed) {
      if (_uuidPattern.hasMatch(uuid)) {
        return uuid;
      }
    }
    throw HeckException('No device ID found in output: $result');
  }

  Future<String> createAndroid({
    required String name,
    required String formFactor,
    required String runtime,
    required int storageMegs,
  }) async {
    final args = [
      'create',
      'avd',
      '--package',
      runtime,
      '--device',
      formFactor,
      '--name',
      name,
      '--force',
    ];
    if (storageMegs > 0) {
      args.addAll(['-c', '${storageMegs}M']);
    }
    final command = Command(_sdkConfig.avdmanager!, args);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Failed to create device: $result');
    }
    return name;
  }
}

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
    return name;
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

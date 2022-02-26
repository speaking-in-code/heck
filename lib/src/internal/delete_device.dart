import 'package:heck/heck.dart';
import 'package:heck/src/heck_sdk_config.dart';
import 'package:heck/src/internal/command.dart';

class DeleteDevice {
  final HeckSDKConfig _sdkConfig;
  DeleteDevice(this._sdkConfig);

  Future<void> deleteDevice({
    required HeckDeviceType deviceType,
    required String name,
  }) {
    switch (deviceType) {
      case HeckDeviceType.ios:
        return deleteIOS(
          name: name,
        );
      case HeckDeviceType.android:
        return deleteAndroid(
          name: name,
        );
      default:
        throw HeckException('Unimplemented device type $deviceType');
    }
  }

  Future<void> deleteIOS({
    required String name,
  }) async {
    final command = Command(_sdkConfig.xcrun!, [
      'simctl',
      'delete',
      name,
    ]);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Failed to delete device: $result');
    }
  }

  Future<void> deleteAndroid({
    required String name,
  }) async {
    final args = [
      'delete',
      'avd',
      '--name',
      name,
    ];
    final command = Command(_sdkConfig.avdmanager!, args);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Failed to delete device: $result');
    }
  }
}

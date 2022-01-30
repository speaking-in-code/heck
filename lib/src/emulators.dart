import 'package:emulators/emulators.dart';
import 'package:emulators/src/adb.dart';
import 'package:emulators/src/avdmanager.dart';
import 'package:emulators/src/command.dart';
import 'package:emulators/src/device.dart';
import 'package:emulators/src/sdk_config.dart';

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

  Future<List<String>> listDeviceSkins() async {
    final command = Command(_sdkConfig.avdmanager!,
        ['create', 'avd', '-k', 'no-such-image', '-n', 'unused-name']);
    return AVDManager.listSystemImages(command);
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
}

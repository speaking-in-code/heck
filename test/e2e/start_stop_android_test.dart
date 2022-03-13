import 'package:test/test.dart';

import 'package:heck/heck.dart';

const kTestDevice = 'start_stop_test';

void main() async {
  final testTimeout = Timeout(Duration(minutes: 2));

  group('Starting and stopping android simulators', () {
    late final Heck heck;

    setUpAll(() async {
      heck = Heck(await HeckSDKConfig.loadDefaults());
    });

    tearDownAll(() async {
      // Clean up any created emulators.
      await heck.deleteDevice(
          deviceType: HeckDeviceType.android, name: kTestDevice);
    });

    test('Start android simulator', () async {
      String name = await heck.createDevice(
          deviceType: HeckDeviceType.android,
          name: kTestDevice,
          formFactor: 'pixel_c',
          runtime: 'system-images;android-23;default;x86_64');
      final device = await heck.startDevice(
          deviceType: HeckDeviceType.android, name: name);
      await heck.stopDevice(device: device);
    });
  }, timeout: testTimeout);
}

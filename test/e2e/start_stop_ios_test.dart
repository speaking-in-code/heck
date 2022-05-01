import 'package:test/test.dart';

import 'package:heck/heck.dart';

const kTestDevice = 'start_stop_test';

void main() async {
  final testTimeout = Timeout(Duration(minutes: 2));

  group('Starting and stopping iOS sim', () {
    late final Heck heck;

    setUpAll(() async {
      heck = Heck(await HeckSDKConfig.loadDefaults());
    });

    tearDownAll(() async {
      // Clean up any created emulators.
      await heck.deleteDevice(
          deviceType: HeckDeviceType.ios, name: kTestDevice);
    });

    test('Start iOS simulator', () async {
      String name = await heck.createDevice(
          deviceType: HeckDeviceType.ios,
          name: kTestDevice,
          formFactor: 'iPhone 11 Pro Max',
          runtime: 'com.apple.CoreSimulator.SimRuntime.iOS-15-4');
      final device = await heck.startDevice(
        deviceType: HeckDeviceType.ios,
        name: name,
        locale: 'fr_FR',
      );
      await heck.stopDevice(device: device);
    });

    test('Start missing iOS simulator', () async {
      try {
        await heck.startDevice(
          deviceType: HeckDeviceType.ios,
          name: 'nodevice',
          locale: 'fr_FR',
        );
        fail('Should have thrown');
      } on HeckException catch (e) {
        expect(e.toString(), contains('Unable to locate simulator nodevice'));
      }
    });
  }, timeout: testTimeout);
}

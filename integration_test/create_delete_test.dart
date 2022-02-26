import 'package:heck/src/models/simulators.dart';
import 'package:test/test.dart';

import 'package:heck/heck.dart';

const kTestDevice = 'heck_test';

void main() async {
  final timeout = Timeout(Duration(seconds: 30));

  group('Creating and deleting simulators', () {
    late final Heck heck;

    setUpAll(() async {
      heck = Heck(await HeckSDKConfig.loadDefaults());
    });

    tearDownAll(() async {});

    test('Create android simulator', () async {
      String name = await heck.createDevice(
          deviceType: HeckDeviceType.android,
          name: kTestDevice,
          formFactor: 'pixel_c',
          runtime: 'system-images;android-23;default;x86_64',
          storageMegs: 1000);
      expect(name, equals(kTestDevice));
      final sims = await heck.getSimulators();
      List<String> found = [];
      for (final dev in sims.androidDevices) {
        found.add(dev.name);
      }
      expect(found, contains(name));
    });

    test('Create ios simulator', () async {
      String name = await heck.createDevice(
          deviceType: HeckDeviceType.ios,
          name: kTestDevice,
          formFactor: 'iPhone 11 Pro Max',
          runtime: 'com.apple.CoreSimulator.SimRuntime.iOS-15-2');
      expect(name, equals(kTestDevice));
      final sims = await heck.getSimulators();
      List<String> found = [];
      for (final dev in sims.iosDevices) {
        found.add(dev.name);
      }
      expect(found, contains(name));
    });
  }, timeout: timeout);
}

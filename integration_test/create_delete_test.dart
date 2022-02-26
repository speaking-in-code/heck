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

    Future<List<String>> getAndroidDeviceNames() async {
      final sims = await heck.getSimulators();
      List<String> found = [];
      for (final dev in sims.androidDevices) {
        found.add(dev.name);
      }
      return found;
    }

    test('Create android simulator', () async {
      String name = await heck.createDevice(
          deviceType: HeckDeviceType.android,
          name: kTestDevice,
          formFactor: 'pixel_c',
          runtime: 'system-images;android-23;default;x86_64',
          storageMegs: 1000);
      expect(name, equals(kTestDevice));
      List<String> found = await getAndroidDeviceNames();
      expect(found, contains(name));

      await heck.deleteDevice(
          deviceType: HeckDeviceType.android, name: kTestDevice);
      found = await getAndroidDeviceNames();
      expect(found, isNot(contains(name)));
    });

    test('Bad android form factor', () async {
      try {
        await heck.createDevice(
            deviceType: HeckDeviceType.android,
            name: kTestDevice,
            formFactor: 'not_found',
            runtime: 'system-images;android-23;default;x86_64',
            storageMegs: 1000);
        fail('Should have thrown');
      } on HeckException catch (e) {
        // Check that command is echoed in error message
        expect(e.toString(), contains('not_found'));
        expect(e.toString(), contains('avdmanager'));
      }
    });

    Future<Iterable<IOSDevice>> getIOSDevices() async {
      final sims = await heck.getSimulators();
      return sims.iosDevices;
    }

    bool containsDevice(Iterable<IOSDevice> devices, String name, String id) {
      for (final device in devices) {
        if (device.name == kTestDevice && device.id == id) {
          return true;
        }
      }
      return false;
    }

    test('Create ios simulator', () async {
      String id = await heck.createDevice(
          deviceType: HeckDeviceType.ios,
          name: kTestDevice,
          formFactor: 'iPhone 11 Pro Max',
          runtime: 'com.apple.CoreSimulator.SimRuntime.iOS-15-2');
      expect(id, isNotEmpty);
      expect(id, isNot(equals(kTestDevice)));
      Iterable<IOSDevice> devices = await getIOSDevices();
      bool found = containsDevice(devices, kTestDevice, id);
      expect(found, isTrue, reason: 'No device $kTestDevice/$id in $devices');

      await heck.deleteDevice(deviceType: HeckDeviceType.ios, name: id);
      devices = await getIOSDevices();
      found = containsDevice(devices, kTestDevice, id);
      expect(found, isFalse,
          reason: 'Failed to delete $kTestDevice/$id in $devices');
    });

    test('Bad ios form factor', () async {
      try {
        await heck.createDevice(
            deviceType: HeckDeviceType.ios,
            name: kTestDevice,
            formFactor: 'not_found',
            runtime: 'com.apple.CoreSimulator.SimRuntime.iOS-15-2');
        fail('Should have thrown');
      } on HeckException catch (e) {
        // Check that command is echoed in error message
        expect(e.toString(), contains('not_found'));
        expect(e.toString(), contains('xcrun simctl'));
      }
    });
  }, timeout: timeout);
}

import 'dart:io';

import 'package:heck/src/internal/command.dart';
import 'package:test/test.dart';

import 'package:heck/heck.dart';

const kTestDevice = 'heck_drive_test';

void main() async {
  final testTimeout = Timeout(Duration(minutes: 10));

  group('Running flutter drive against device in various locales', () {
    late final Heck heck;
    late final String iosDevice;
    late final String androidDevice;

    setUpAll(() async {
      if (!Directory('test_app').existsSync()) {
        fail('''App test_app not found.
'Run this test from the root of the heck project:
   dart test test/e2e/flutter_drive_test.dart''');
      }
      heck = Heck(await HeckSDKConfig.loadDefaults());
      iosDevice = await heck.createDevice(
          deviceType: HeckDeviceType.ios,
          name: kTestDevice,
          formFactor: 'iPhone 11 Pro Max',
          runtime: 'com.apple.CoreSimulator.SimRuntime.iOS-15-2');

      androidDevice = await heck.createDevice(
          deviceType: HeckDeviceType.android,
          name: kTestDevice,
          formFactor: 'pixel_c',
          runtime: 'system-images;android-23;default;x86_64');
    });

    tearDownAll(() async {
      // Clean up any created emulators.
      await heck.deleteDevice(
          deviceType: HeckDeviceType.ios, name: kTestDevice);
      await heck.deleteDevice(
          deviceType: HeckDeviceType.android, name: kTestDevice);
    });

    Future<HeckRunningDevice> start(HeckDeviceType deviceType, String locale) {
      String name;
      switch (deviceType) {
        case HeckDeviceType.android:
          name = androidDevice;
          break;
        case HeckDeviceType.ios:
          name = iosDevice;
          break;
      }
      return heck.startDevice(
        deviceType: deviceType,
        name: name,
        locale: locale,
      );
    }

    Future<CommandResult> flutterDrive(
        HeckRunningDevice device, String target) {
      return heck.flutterDrive(
        deviceId: device.id,
        workingDirectory: 'test_app',
        arguments: [
          '--driver',
          'test_driver/integration_test.dart',
          '--target',
          'integration_test/$target',
        ],
      );
    }

    /*
    test('Drive iOS', () async {
      final spanish = await start(HeckDeviceType.ios, 'es_ES');
      final spanishOut = await flutterDrive(spanish, 'spanish_test.dart');
      expect(spanishOut.exitCode, equals(0));
      await heck.stopDevice(device: spanish);

      final french = await start(HeckDeviceType.ios, 'fr_FR');
      final frenchOut = await flutterDrive(french, 'french_test.dart');
      expect(frenchOut.exitCode, equals(0));
      await heck.stopDevice(device: french);
    });

    test('Drive Android', () async {
      final spanish = await start(HeckDeviceType.android, 'es_ES');
      final spanishOut = await flutterDrive(spanish, 'spanish_test.dart');
      expect(spanishOut.exitCode, equals(0));
      await heck.stopDevice(device: spanish);

      final french = await start(HeckDeviceType.android, 'fr_FR');
      final frenchOut = await flutterDrive(french, 'french_test.dart');
      expect(frenchOut.exitCode, equals(0));
      await heck.stopDevice(device: french);
    });
    */
  }, timeout: testTimeout);
}

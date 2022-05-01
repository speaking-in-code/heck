import 'dart:io';

import 'package:heck/src/internal/command.dart';
import 'package:test/test.dart';

import 'package:heck/heck.dart';

const kTestDevice = 'heck_drive_test';

void main() async {
  final testTimeout = Timeout(Duration(minutes: 10));

  group('Running flutter drive against device in various locales', () {
    late final Heck heck;
    late final String androidDevice;

    setUpAll(() async {
      if (!Directory('test_app').existsSync()) {
        fail('''App test_app not found.
'Run this test from the root of the heck project:
   dart test test/e2e/flutter_drive_android_test.dart''');
      }
      heck = Heck(await HeckSDKConfig.loadDefaults());
      // Delete the device if it already exists from a previous run.
      try {
        await heck.deleteDevice(
            deviceType: HeckDeviceType.android, name: kTestDevice);
      } on HeckException {
        // ignore
      }
      androidDevice = await heck.createDevice(
          deviceType: HeckDeviceType.android,
          name: kTestDevice,
          formFactor: 'pixel_c',
          runtime: 'system-images;android-23;default;x86_64');
    });

    tearDownAll(() async {
      // Clean up any created emulators.
      await heck.deleteDevice(
          deviceType: HeckDeviceType.android, name: kTestDevice);
    });

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

    Future<void> _driveDevice(String locale, String test) async {
      HeckRunningDevice? device;
      try {
        device = await heck.startDevice(
          deviceType: HeckDeviceType.android,
          name: androidDevice,
          locale: locale,
        );
        final driveCommand = await flutterDrive(device, test);
        expect(driveCommand.exitCode, equals(0));
      } finally {
        if (device != null) {
          await heck.stopDevice(device: device);
        }
      }
    }

    test('Drive Android in es_ES', () async {
      await _driveDevice('es_ES', 'spanish_test.dart');
    });

    test('Drive Android in fr_FR', () async {
      await _driveDevice('fr_FR', 'french_test.dart');
    });
  }, timeout: testTimeout);
}

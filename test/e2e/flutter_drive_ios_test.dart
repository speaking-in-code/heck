import 'dart:io';

import 'package:heck/src/internal/command.dart';
import 'package:test/test.dart';

import 'package:heck/heck.dart';

const kTestDevice = 'heck_drive_test';

// TODO: debugging. These tests are flaky. Add some things.
// - verify output from the locale change commands (Android).
// - verify that emulator stopped correctly (iOS)
// - add exec open Simulator.app to launch the foreground iOS simulator
void main() async {
  final testTimeout = Timeout(Duration(minutes: 10));

  group('Running flutter drive against device in various locales', () {
    late final Heck heck;
    late final String iosDevice;

    setUpAll(() async {
      if (!Directory('test_app').existsSync()) {
        fail('''App test_app not found.
'Run this test from the root of the heck project:
   dart test test/e2e/flutter_drive_ios_test.dart''');
      }
      heck = Heck(await HeckSDKConfig.loadDefaults());
      iosDevice = await heck.createDevice(
          deviceType: HeckDeviceType.ios,
          name: kTestDevice,
          formFactor: 'iPhone 11 Pro Max',
          runtime: 'com.apple.CoreSimulator.SimRuntime.iOS-15-2');
    });

    tearDownAll(() async {
      // Clean up any created emulators.
      await heck.deleteDevice(
          deviceType: HeckDeviceType.ios, name: kTestDevice);
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

    test('Drive iOS', () async {
      final spanish = await heck.startDevice(
        deviceType: HeckDeviceType.ios,
        name: iosDevice,
        locale: 'es_ES',
      );
      final spanishOut = await flutterDrive(spanish, 'spanish_test.dart');
      expect(spanishOut.exitCode, equals(0));
      await heck.stopDevice(device: spanish);

      final french = await heck.startDevice(
        deviceType: HeckDeviceType.ios,
        name: iosDevice,
        locale: 'fr_FR',
      );
      final frenchOut = await flutterDrive(french, 'french_test.dart');
      expect(frenchOut.exitCode, equals(0));
      await heck.stopDevice(device: french);
    });
  }, timeout: testTimeout);
}

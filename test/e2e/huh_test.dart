import 'dart:io';

import 'package:heck/src/internal/command.dart';
import 'package:test/test.dart';

import 'package:heck/heck.dart';

const kTestDevice = '2.7_QVGA_API_23';

void main() async {
  final testTimeout = Timeout(Duration(minutes: 10));

  group('Running flutter drive against device in various locales', () {
    late final Heck heck;

    setUpAll(() async {
      if (!Directory('test_app').existsSync()) {
        fail('''App test_app not found.
'Run this test from the root of the heck project:
   dart test test/e2e/flutter_drive_test.dart''');
      }
      heck = Heck(await HeckSDKConfig.loadDefaults());
    });

    tearDownAll(() async {});

    Future<HeckRunningDevice> start(HeckDeviceType deviceType, String locale) {
      return heck.startDevice(
        deviceType: deviceType,
        name: kTestDevice,
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
     */

    test('Drive Android', () async {
      final spanish = await start(HeckDeviceType.android, 'es-ES');
      final spanishOut = await flutterDrive(spanish, 'spanish_test.dart');
      expect(spanishOut.exitCode, equals(0));
    });
  }, timeout: testTimeout);
}

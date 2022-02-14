import 'dart:math';

import 'package:emulators/emulators.dart';
import 'package:emulators/src/models/system_image.dart';
import 'package:test/test.dart';

// TODO: this should probably be in the example app, not the library code.
void main() async {
  final timeout = Timeout(Duration(minutes: 2));

  group('Integration test for creating a device and starting it', () {
    final rand = Random();
    final String name = 'int_test_${rand.nextInt(1000)}';
    late final Emulators emulators;

    setUpAll(() async {
      emulators = Emulators(await SDKConfig.loadDefaults());
    });

    tearDownAll(() async {
      // await emulators.deleteDevice(name);
    });

    /*
    test('Creates and starts device', () async {
      final skinsF = emulators.listSkins();
      final imagesF = emulators.listSystemImages();
      String skin = (await skinsF).first;
      SystemImage image =
          (await imagesF).firstWhere((image) => image.osLevel == 'android-23');
      print('Creating device with skin $skin and image $image');
      await emulators.createDevice(name: name, skin: skin, image: image.name);
      final running = await emulators.startDevice(name);
      print('Waiting for emulator ${running.id} to startup');
      await emulators.waitForEmulator(running);
      print('Emulator started');
      print('Device id is "${running.id}"');
      final out = emulators.testOnDevice(running.id,
          ['test', './example/emulators_demo/integration_test/app_test.dart']);
      print('Test results from ${running.id}: $out');
      //await emulators.stopEmulator(running);
      // running.command.process.kill();
      //await running.command.process.exitCode;
      /*
      print('Command was ${running.command}');
      print('Exit code was ${running.command.exitCode}');
      print('Stdout was ${running.command.stdout}');
      print('Stderr was ${running.command.stderr}');

       */

      // Next up:
      // - wait for the device to be available
      // - run an integration test inside it
    });
*/
    test('runs tests on device', () async {
      final id = 'emulator-5554';
      final out = await emulators.flutterDrive(
          deviceId: id,
          workingDirectory: 'example/emulators_demo',
          options: [
            '--driver',
            'test_driver/app.dart',
            '--target',
            'integration_test/app_test.dart'
          ]);
      if (out.exitCode != 0) {
        fail('Tests failed on $id: $out');
      } else {
        print('Test results from $id: $out');
      }
    });
  }, timeout: timeout);
}

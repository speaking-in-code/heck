import 'dart:math';

import 'package:emulators/emulators.dart';
import 'package:emulators/src/models/system_image.dart';
import 'package:test/test.dart';

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
  }, timeout: timeout);
}

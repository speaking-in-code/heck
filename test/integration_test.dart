import 'dart:math';

import 'package:emulators/emulators.dart';
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
      await emulators.deleteDevice(name);
    });

    test('Creates and starts device', () async {
      final skinsF = emulators.listSkins();
      final imagesF = emulators.listSystemImages();
      String skin = (await skinsF).first;
      String image = (await imagesF).first;
      await emulators.createDevice(name: name, skin: skin, image: image);
      final running = await emulators.startDevice(name);
      print('Waiting for emulator to startup');
      await emulators.waitForEmulator(running);
      print('Emulator started');
      print('Device name is "${running.name}"');
      await emulators.stopEmulator(running);
      // running.command.process.kill();
      await running.command.process.exitCode;
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

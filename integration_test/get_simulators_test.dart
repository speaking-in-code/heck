import 'package:heck/src/models/simulators.dart';
import 'package:test/test.dart';

import 'package:heck/heck.dart';

void main() async {
  final timeout = Timeout(Duration(seconds: 30));

  group('Getting available simulators', () {
    late final Heck heck;

    setUpAll(() async {
      heck = Heck(await HeckSDKConfig.loadDefaults());
    });

    tearDownAll(() async {});

    test('Gets available simulators', () async {
      final sims = await heck.getSimulators();

      expect(
          sims.androidFormFactors,
          containsAll([
            (AndroidFormFactorBuilder()..formFactor = 'Nexus 9').build(),
            (AndroidFormFactorBuilder()..formFactor = 'pixel_c').build(),
          ]));

      expect(
          sims.androidRuntimes,
          containsAll([
            (AndroidRuntimeBuilder()
                  ..runtime = 'system-images;android-21;google_apis;x86')
                .build(),
            (AndroidRuntimeBuilder()
                  ..runtime = 'system-images;android-23;default;x86_64')
                .build(),
          ]));

      expect(
          sims.androidDevices,
          containsAll([
            (AndroidDeviceBuilder()..name = 'Nexus_7').build(),
            (AndroidDeviceBuilder()..name = 'Nexus_S_API_21').build(),
          ]));

      expect(
          sims.iosFormFactors,
          containsAll([
            (IOSFormFactorBuilder()..formFactor = 'iPhone 5').build(),
            (IOSFormFactorBuilder()
                  ..formFactor = 'iPad Pro (11-inch) (1st generation)')
                .build(),
          ]));

      expect(
          sims.iosRuntimes,
          containsAll([
            (IOSRuntimeBuilder()
                  ..version = '10.3.1'
                  ..identifier = 'com.apple.CoreSimulator.SimRuntime.iOS-10-3')
                .build(),
          ]));

      final foundNames = <String>[];
      for (final iosDevice in sims.iosDevices) {
        expect(iosDevice.dataPath, isNotEmpty);
        foundNames.add(iosDevice.name);
      }
      expect(foundNames, containsAll(['Apple TV', 'iPhone 6 Plus']));
    });
  }, timeout: timeout);
}

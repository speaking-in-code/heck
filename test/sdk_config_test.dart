import 'package:emulators/emulators.dart';
import 'package:test/test.dart';

void main() {
  group('Locates key binaries', () {
    test('Loads defaults', () async {
      final sdkConfig = await SDKConfig.loadDefaults();
      expect(sdkConfig.avdmanager, equals('avdmanager'));
    });

    test('Panics if no avdmanager found', () async {
      try {
        await SDKConfig.load(avdmanager: '/dev/null');
        fail('Should have thrown EmulatorException');
      } on EmulatorException catch (e) {
        final msg = e.toString();
        expect(msg, contains('Bad exit code from "/dev/null list target"'));
      }
    });

    test('Panics if avdmanager output is wrong', () async {
      try {
        await SDKConfig.load(avdmanager: 'echo');
        fail('Should have thrown EmulatorException');
      } on EmulatorException catch (e) {
        final msg = e.toString();
        expect(
            msg,
            stringContainsInOrder(
                ['Unexpected output from "echo list target"', 'Code: 0']));
      }
    });
  });
}

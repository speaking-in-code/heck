import 'package:emulators/emulators.dart';
import 'package:test/test.dart';

void main() {
  group('Locates key binaries', () {
    test('Finds avdmanager', () async {
      final sdkConfig = await SDKConfig.loadDefaults();
      expect(sdkConfig.avdmanager, equals('avdmanager'));
    });

    test('Panics if no flutter found', () async {
      try {
        await SDKConfig.load(avdmanager: '/dev/null');
        fail('Should have thrown EmulatorException');
      } on EmulatorException catch (e) {
        final msg = e.toString();
        expect(
            msg,
            stringContainsInOrder([
              'Could not run "/dev/null list target"',
              ' Cause: ProcessException:'
            ]));
      }
    });

    test('Panics if flutter output is wrong', () async {
      try {
        await SDKConfig.load(avdmanager: 'echo');
        fail('Should have thrown EmulatorException');
      } on EmulatorException catch (e) {
        final msg = e.toString();
        expect(
            msg,
            stringContainsInOrder(
                ['Unexpected output from "echo list target"', 'Exit code: 0']));
      }
    });
  });
}

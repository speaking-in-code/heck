import 'package:emulators/src/avdmanager.dart';
import 'package:emulators/src/command.dart';
import 'package:emulators/src/emulator_exception.dart';
import 'package:test/test.dart';

import 'temp_dir.dart';

void main() async {
  group('Parses avdmanager output to verify device creation', () {
    final tempDir = TempDir();

    tearDownAll(() async {
      tempDir.cleanup();
    });

    test('Handles success', () async {
      final weirdGarbage = tempDir
          .makeFile('Parsing /Users/ckage.xmlAuto-selecting single ABI x86_64');
      await AVDManager.listSkins(tempDir.dump(weirdGarbage));
    });

    test('Handles error', () async {
      try {
        await AVDManager.listSkins(Command('/dev/null', []));
        fail('Should have thrown error');
      } on EmulatorException catch (_) {}
    });
  });
}

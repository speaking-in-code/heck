import 'package:emulators/src/adb.dart';
import 'package:emulators/src/command.dart';
import 'package:emulators/src/emulator_exception.dart';
import 'package:test/test.dart';

import 'temp_dir.dart';

void main() async {
  group('Parses adb device output', () {
    final tempDir = TempDir();

    tearDownAll(() async {
      tempDir.cleanup();
    });

    test('Handles no output', () async {
      final empty = tempDir.makeFile('');
      try {
        await ADB.listRunning(Command('cat', [empty.path]));
        fail('Should have thrown');
      } on EmulatorException catch (_) {}
    });

    test('Handles no devices', () async {
      final noDevices = tempDir.makeFile('''List of devices attached

''');
      final devices = await ADB.listRunning(tempDir.dump(noDevices));
      expect(devices, isEmpty);
    });

    test('Handles a device', () async {
      final one = tempDir.makeFile('''List of devices attached
emulator-5554	device

''');
      final devices = await ADB.listRunning(tempDir.dump(one));
      final names = devices.map((device) => device.name).toList();
      expect(names, containsAllInOrder(['emulator-5554']));
    });
  });
}

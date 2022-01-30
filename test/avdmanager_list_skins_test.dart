import 'package:emulators/src/avdmanager.dart';
import 'package:test/test.dart';

import 'temp_dir.dart';

void main() async {
  group('Parses avdmanager output to get available skins', () {
    final tempDir = TempDir();

    tearDownAll(() async {
      tempDir.cleanup();
    });

    test('Handles no output', () async {
      final empty = tempDir.makeFile('');
      final devices = await AVDManager.listSkins(tempDir.dump(empty));
      expect(devices, isEmpty);
    });

    test('Handles normal output', () async {
      final normal = tempDir.makeFile('''Parsing /Users/brian/Library/...
id: 0 or "tv_1080p"
    Name: Android TV (1080p)
    OEM : Google
    Tag : android-tv
---------
id: 1 or "tv_720p"
    Name: Android TV (720p)
    OEM : Google
    Tag : android-tv
---------
id: 27 or "3.7in WVGA (Nexus One)"
    Name: 3.7" WVGA (Nexus One)
    OEM : Generic
---------

''');
      final devices = await AVDManager.listSkins(tempDir.dump(normal));
      expect(
          devices,
          containsAllInOrder([
            'tv_1080p',
            'tv_720p',
            '3.7in WVGA (Nexus One)',
          ]));
    });
  });
}

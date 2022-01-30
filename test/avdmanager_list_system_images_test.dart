import 'dart:io';
import 'dart:math';

import 'package:emulators/src/avdmanager.dart';
import 'package:test/test.dart';

import 'temp_dir.dart';

void main() async {
  group('Parses avdmanager error to get system images', () {
    final tempDir = TempDir();

    tearDownAll(() async {
      tempDir.cleanup();
    });

    test('Handles no output', () async {
      final empty = tempDir.makeFile('');
      final devices =
          await AVDManager.listSystemImages(tempDir.dumpAsError(empty));
      expect(devices, isEmpty);
    });

    test('Handles normal output', () async {
      final normal = tempDir.makeFile(
          '''Warning: Mapping new ns http://schemas.android.com/repository/android/common/02 to old ns http://schemas.android.com/repository/android/common/01
Warning: Mapping new ns http://schemas.android.com/repository/android/generic/02 to old ns http://schemas.android.com/repository/android/generic/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/addon2/02 to old ns http://schemas.android.com/sdk/android/repo/addon2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/repository2/02 to old ns http://schemas.android.com/sdk/android/repo/repository2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/sys-img2/02 to old ns http://schemas.android.com/sdk/android/repo/sys-img2/01
Warning: Mapping new ns http://schemas.android.com/repository/android/common/02 to old ns http://schemas.android.com/repository/android/common/01
Warning: Mapping new ns http://schemas.android.com/repository/android/generic/02 to old ns http://schemas.android.com/repository/android/generic/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/addon2/02 to old ns http://schemas.android.com/sdk/android/repo/addon2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/repository2/02 to old ns http://schemas.android.com/sdk/android/repo/repository2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/sys-img2/02 to old ns http://schemas.android.com/sdk/android/repo/sys-img2/01
Error: Package path is not valid. Valid system image paths are:ository...       
system-images;android-16;default;x86
system-images;android-23;google_apis;x86
system-images;android-19;google_apis;x86
system-images;android-23;android-tv;x86
system-images;android-23;default;x86_64
system-images;android-28;google_apis_playstore;x86
system-images;android-23;android-tv;armeabi-v7a
system-images;android-16;google_apis;x86
system-images;android-23;google_apis;armeabi-v7a
system-images;android-23;google_apis;x86_64
system-images;android-21;google_apis;x86
system-images;android-23;default;x86
null

''');
      final devices =
          await AVDManager.listSystemImages(tempDir.dumpAsError(normal));
      expect(
          devices,
          containsAllInOrder([
            'system-images;android-16;default;x86',
            'system-images;android-23;google_apis;x86',
            'system-images;android-19;google_apis;x86',
            'system-images;android-23;android-tv;x86',
            'system-images;android-23;default;x86_64',
            'system-images;android-28;google_apis_playstore;x86',
            'system-images;android-23;android-tv;armeabi-v7a',
            'system-images;android-16;google_apis;x86',
            'system-images;android-23;google_apis;armeabi-v7a',
            'system-images;android-23;google_apis;x86_64',
            'system-images;android-21;google_apis;x86',
            'system-images;android-23;default;x86',
          ]));
    });
  });
}

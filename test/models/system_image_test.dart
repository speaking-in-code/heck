import 'package:emulators/src/models/system_image.dart';
import 'package:test/test.dart';

void main() async {
  group('Parses system images', () {
    test('Handles empty', () async {
      final image = SystemImage((b) => b..name = '');
      expect(image.name, equals(''));
      expect(image.source, isNull);
      expect(image.osLevel, isNull);
      expect(image.apis, isNull);
      expect(image.abi, isNull);
    });

    test('Handles partial', () async {
      final image = SystemImage((b) => b..name = 'system-images;android-16');
      expect(image.name, equals('system-images;android-16'));
      expect(image.source, isNull);
      expect(image.osLevel, isNull);
      expect(image.apis, isNull);
      expect(image.abi, isNull);
    });

    test('Handles too many', () async {
      final image = SystemImage((b) => b..name = 'a;b;c;d;e');
      expect(image.name, equals('a;b;c;d;e'));
      expect(image.source, isNull);
      expect(image.osLevel, isNull);
      expect(image.apis, isNull);
      expect(image.abi, isNull);
    });

    test('Handles normal', () async {
      final image = SystemImage(
          (b) => b..name = 'system-images;android-19;google_apis;x86');
      expect(image.name, equals('system-images;android-19;google_apis;x86'));
      expect(image.source, equals('system-images'));
      expect(image.osLevel, equals('android-19'));
      expect(image.apis, equals('google_apis'));
      expect(image.abi, equals('x86'));
    });
  });
}

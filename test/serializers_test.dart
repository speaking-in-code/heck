import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:emulators/src/models/flutter_devices.dart';
import 'package:emulators/src/models/serializers.dart';
import 'package:test/test.dart';

void main() {
  group('Serialization Experiments', () {
    test('Json standard', () async {
      final out = serializers.fromJson(
        FlutterDevice.serializer,
        '{"name": "emulator-5554", "id": "emulator-5554"}',
      );
      expect(out!.name, equals('emulator-5554'));
    });

    test('Json decode failure', () async {
      jsonDecode('[');
    });

    test('Json array standard', () async {
      final jsonArray = '[{"name": "emulator-5554", "id": "emulator-5554"}]';
      final array = jsonDecode(jsonArray);
      for (final element in array) {
        final out =
            serializers.deserializeWith(FlutterDevice.serializer, element);
        expect(out!.name, equals('emulator-5554'));
      }
    });

    test('Bad format', () async {
      try {
        final jsonArray = '[{}]';
        final array = jsonDecode(jsonArray);
        for (final element in array) {
          serializers.deserializeWith(FlutterDevice.serializer, element);
          fail('Should have thrown');
        }
      } on DeserializationError {
        // pass
      }
    });
  });
}

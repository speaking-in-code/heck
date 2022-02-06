import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

import 'command.dart';
import 'emulator_exception.dart';
import 'models/flutter_devices.dart';
import 'models/serializers.dart';

class Flutter {
  static Future<FlutterDevices> devices(Command command) async {
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw EmulatorException('flutter device list failed: $result');
    }
    try {
      final array = jsonDecode(result.stdout);
      if (array is! List<dynamic>) {
        throw EmulatorException('flutter device unexpected output: $result');
      }
      final devices = FlutterDevicesBuilder();
      for (final element in array) {
        final device =
            serializers.deserializeWith(FlutterDevice.serializer, element);
        if (device == null) {
          throw EmulatorException('Failed to deserialize: $result');
        }
        devices.devices.add(device);
      }
      return devices.build();
    } on DeserializationError catch (e) {
      throw EmulatorException.fromError(
          'flutter devices unexpected output: $result', e);
    } on FormatException catch (e) {
      throw EmulatorException('flutter devices unexpected output: $result', e);
    }
  }
}

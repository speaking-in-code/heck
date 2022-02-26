import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:emulators/src/heck_sdk_config.dart';

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

  // Run the flutter drive command on the specified device
  static Future<CommandResult> flutterDrive(SDKConfig config,
      {required String deviceId,
      required String? workingDirectory,
      required Iterable<String> options}) async {
    final args = <String>['-d', deviceId, 'drive'];
    args.addAll(options);
    final command = Command(
      config.flutter!,
      args,
      workingDirectory: workingDirectory,
    );
    final running = await command.runBackground(streamOutput: true);
    await running.process.exitCode;
    return CommandResult(
        command: command,
        exitCode: running.exitCode!,
        stdout: running.stdout,
        stderr: running.stderr);
  }
}

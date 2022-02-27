import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:emulators/src/heck_sdk_config.dart';

import 'command.dart';
import 'emulator_exception.dart';
import 'models/flutter_devices.dart';
import 'models/serializers.dart';

class Flutter {
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

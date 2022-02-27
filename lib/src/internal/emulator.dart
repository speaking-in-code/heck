import 'dart:io';

import 'package:emulators/src/running_emulator.dart';
import 'package:emulators/src/heck_sdk_config.dart';

import 'command.dart';
import 'emulator_exception.dart';

class Emulator {
  static Future<RunningEmulator> startDevice(SDKConfig sdkConfig, String name,
      {String locale = ''}) async {
    final port = await _findOpenPort();
    final args = ['-avd', name, '-port', '$port', '-no-snapshot-save'];
    if (locale.isNotEmpty) {
      args.addAll(['-change-locale', locale]);
    }
    final command = Command(sdkConfig.emulator!, args);
    final running = await command.runBackground(streamOutput: true);
    return RunningEmulator('emulator-$port', running);
  }
}

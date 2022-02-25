import 'package:emulators/src/command.dart';
import 'package:emulators/src/device.dart';
import 'package:emulators/src/emulator_exception.dart';

class ADB {
  static final _adbFirstLine = RegExp('List of devices attached');
  static final _adbEmulator = RegExp(r'^(emulator-[A-Za-z0-9]+)\s+device');

  static Future<List<RunningDevice>> listRunning(Command command) async {
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw EmulatorException('Failed to list devices: $result');
    }
    final lines = result.stdout.split('\n');
    if (lines.isEmpty || !_adbFirstLine.hasMatch(lines[0])) {
      throw EmulatorException('Unexpected device output: $result');
    }
    final out = <RunningDevice>[];
    for (String line in lines) {
      final match = _adbEmulator.firstMatch(line);
      if (match == null) continue;
      out.add(RunningDevice(name: match.group(1)!));
    }
    return out;
  }
}

/// SDK Configuration
///
/// This class shows where to find key tools for emulator management.

import 'package:path/path.dart' as path;

import 'command.dart';
import 'emulator_exception.dart';

// TODO: figure out how to run emulator. It's doing something weird with argv[0],
// where if it is run as 'emulator' it can't find things, but if it is run
// as the full path to emulator it works properly.
//
// One option: figure it out via the adb output.
//
// $ adb help
// Android Debug Bridge version 1.0.41
// Version 31.0.3-7562133
// Installed as /Users/brian/Library/Android/sdk/platform-tools/adb
class SDKConfig {
  final String? flutter;
  final String? avdmanager;
  final String? emulator;
  final String? adb;

  static Future<SDKConfig> load(
      {String? flutter,
      String? avdmanager,
      String? emulator,
      String? adb,
      bool validate = true}) async {
    if (validate) {
      final List<Future<void>> checks = [];
      if (flutter != null) {
        checks.add(_checkFlutter(flutter));
      }
      if (avdmanager != null) {
        checks.add(_checkAvdmanager(avdmanager));
      }
      if (emulator != null) {
        checks.add(_checkEmulator(emulator));
      }
      if (adb != null) {
        checks.add(_checkAdb(adb));
      }
      await Future.wait(checks);
    }
    return SDKConfig._internal(
        flutter: flutter, avdmanager: avdmanager, emulator: emulator, adb: adb);
  }

  /// Load Android SDK configuration assuming normal defaults.
  static Future<SDKConfig> loadDefaults() async {
    // We use ADB as a reference point, because it's version output includes
    // the full installation path. We then find absolute paths for the other
    // tools that require them.
    //
    // Emulator is picky, it fails if it is not called with an absolute path.
    String adb = await _checkAdb('adb');
    final platformTools = path.dirname(adb);
    final sdk = path.dirname(platformTools);
    final emulator = path.join(sdk, 'tools', 'emulator');

    return load(
      flutter: 'flutter',
      avdmanager: 'avdmanager',
      emulator: emulator,
      adb: adb,
    );
  }

  SDKConfig._internal({this.flutter, this.avdmanager, this.emulator, this.adb});

  static final _expectedFlutter = RegExp(r'Flutter \d+\.\d+\.\d+ ');

  static Future<void> _checkFlutter(String path) async {
    final command = Command(path, ['--version']);
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw _panic('Bad exit code from $command');
    }
    if (!_expectedFlutter.hasMatch(result.stdout)) {
      throw _panic('Unexpected output from $result');
    }
  }

  static final _expectedAvdmanager = RegExp(r'Available Android targets');

  static Future<void> _checkAvdmanager(String path) async {
    final command = Command(path, ['list', 'target']);
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw _panic('Bad exit code from "$command"');
    }
    if (!_expectedAvdmanager.hasMatch(result.stdout)) {
      throw _panic('Unexpected output from $result');
    }
  }

  static final _expectedEmulator = RegExp(r'ERROR: No AVD specified');

  static Future<void> _checkEmulator(String path) async {
    final command = Command(path, []);
    final result = command.runSync();
    if (result.exitCode != 1) {
      throw _panic('Bad exit code from "$command"');
    }
    if (!_expectedEmulator.hasMatch(result.stdout)) {
      throw _panic('Unexpected output from $result');
    }
  }

  static final _expectedAdb = RegExp(r'Android Debug Bridge version ');
  static final _adbPath = RegExp(r'Installed as (.+)');

  // Returns the absolute path to adb.
  static Future<String> _checkAdb(String path) async {
    final command = Command(path, ['--version']);
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw _panic('Bad exit code from "$command"');
    }
    if (!_expectedAdb.hasMatch(result.stdout)) {
      throw _panic('Unexpected output from $result');
    }
    final where = _adbPath.firstMatch(result.stdout);
    if (where == null) {
      throw _panic('Could not find full adb path in $result');
    }
    return where.group(1)!;
  }

  static EmulatorException _panic(String reason) {
    return EmulatorException(reason);
  }
}

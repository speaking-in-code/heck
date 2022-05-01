/// SDK Configuration
///
/// This class shows where to find key tools for emulator management.
/// Usage:
///    final sdkConfig = await HeckSDKConfig.loadDefaults();
///
/// The SDKConfig.load() factory can be used if you need to specify specific
/// paths to certain tools.

import 'dart:io';

import 'package:path/path.dart' as path;

import 'internal/command.dart';
import 'heck_exception.dart';

class HeckSDKConfig {
  /// Path to flutter SDK flutter binary.
  final String? flutter;

  /// Path to Android SDK avdmanager binary.
  final String? avdmanager;

  /// Path to Android SDK emulator binary.
  final String? emulator;

  /// Path to Android SDK adb binary.
  final String? adb;

  /// Path to iOS SDK xcrun binary.
  final String? xcrun;

  /// Path to iOS SDK plutil binary.
  final String? plutil;

  /// Path to open command
  final String? open;

  /// Path to Simulator.app
  final String? simulator;

  /// Load Android and iOS SDK configuration assuming normal defaults and tools
  /// in the path.
  static Future<HeckSDKConfig> loadDefaults() async {
    // We use ADB as a reference point, because it's version output includes
    // the full installation path. We then find absolute paths for the other
    // tools that require them.
    //
    // Emulator is picky, it fails if it is not called with an absolute path.
    String adb = await _checkAdb('adb');
    final platformTools = path.dirname(adb);
    final sdk = path.dirname(platformTools);
    final emulator = path.join(sdk, 'tools', 'emulator');
    String? xcrun;
    String? plutil;
    String? open;
    String? simulator;
    if (Platform.isMacOS) {
      xcrun = 'xcrun';
      plutil = 'plutil';
      open = 'open';
      simulator = await _checkSimulator(xcrun);
    }

    return load(
      flutter: 'flutter',
      avdmanager: 'avdmanager',
      emulator: emulator,
      adb: adb,
      xcrun: xcrun,
      plutil: plutil,
      open: open,
      simulator: simulator,
    );
  }

  /// Loads SDK conjfigurat
  static Future<HeckSDKConfig> load(
      {String? flutter,
      String? avdmanager,
      String? emulator,
      String? adb,
      String? xcrun,
      String? plutil,
      String? open,
      String? simulator,
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
      if (plutil != null) {
        checks.add(_checkPlutil(plutil));
      }
      if (xcrun != null) {
        checks.add(_checkXcrun(xcrun));
      }
      // TODO: add checks for simulator and open if they work at all.
      await Future.wait(checks);
    }
    return HeckSDKConfig._internal(
      flutter: flutter,
      avdmanager: avdmanager,
      emulator: emulator,
      adb: adb,
      plutil: plutil,
      xcrun: xcrun,
      open: open,
      simulator: simulator,
    );
  }

  HeckSDKConfig._internal({
    this.flutter,
    this.avdmanager,
    this.emulator,
    this.adb,
    this.xcrun,
    this.plutil,
    this.open,
    this.simulator,
  });

  static final _expectedFlutter = RegExp(r'Flutter \d+\.\d+\.\d+ ');

  static Future<void> _checkFlutter(String path) async {
    final command = Command(path, ['--version']);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Bad exit code from $command');
    }
    if (!_expectedFlutter.hasMatch(result.stdout)) {
      throw HeckException('Unexpected output from $result');
    }
  }

  static final _expectedAvdmanager = RegExp(r'Available Android targets');

  static Future<void> _checkAvdmanager(String path) async {
    final command = Command(path, ['list', 'target']);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Bad exit code from "$command"');
    }
    if (!_expectedAvdmanager.hasMatch(result.stdout)) {
      throw HeckException('Unexpected output from $result');
    }
  }

  static final _expectedEmulator = RegExp(r'ERROR: No AVD specified');

  static Future<void> _checkEmulator(String path) async {
    final command = Command(path, []);
    final result = await command.run();
    if (result.exitCode != 1) {
      throw HeckException('Bad exit code from "$command"');
    }
    if (!_expectedEmulator.hasMatch(result.stdout)) {
      throw HeckException('Unexpected output from $result');
    }
  }

  static final _expectedAdb = RegExp(r'Android Debug Bridge version ');
  static final _adbPath = RegExp(r'Installed as (.+)');

  // Returns the absolute path to adb.
  static Future<String> _checkAdb(String path) async {
    final command = Command(path, ['--version']);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Bad exit code from "$command"');
    }
    if (!_expectedAdb.hasMatch(result.stdout)) {
      throw HeckException('Unexpected output from $result');
    }
    final where = _adbPath.firstMatch(result.stdout);
    if (where == null) {
      throw HeckException('Could not find full adb path in $result');
    }
    return where.group(1)!;
  }

  static final _expectedPlutil = RegExp(r'No files specified');

  static Future<void> _checkPlutil(String path) async {
    final command = Command(path, []);
    final result = await command.run();
    if (result.exitCode != 1) {
      throw HeckException('Bad exit code from "$result"');
    }
    if (!_expectedPlutil.hasMatch(result.stderr)) {
      throw HeckException('Unexpected output from $result');
    }
  }

  static final _expectedXcrun = RegExp(r'xcrun version \d+');

  static Future<void> _checkXcrun(String path) async {
    final command = Command(path, ['--version']);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Bad exit code from "$result"');
    }
    if (!_expectedXcrun.hasMatch(result.stdout)) {
      throw HeckException('Unexpected output from $result');
    }
  }

  static Future<String> _checkSimulator(String xcrun) async {
    // This returns something like:
    // /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform
    // The simulator binary is in
    // '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator
    final command = Command(xcrun, ['--show-sdk-platform-path']);
    final result = await command.run();
    if (result.exitCode != 0) {
      throw HeckException('Bad exit code from "$result"');
    }
    final simulator = path.join(
        result.stdout.trim(), '../../', 'Applications/Simulator.app/Contents/MacOS/Simulator');
    if (!File(simulator).existsSync()) {
      throw HeckException('Simulator not found at $simulator');
    }
    return simulator;
  }
}

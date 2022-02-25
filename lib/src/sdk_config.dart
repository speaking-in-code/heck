/// SDK Configuration
///
/// This class shows where to find key tools for emulator management.
/// Usage:
///    final sdkConfig = await SDKConfig.loadDefaults();
///
/// The SDKConfig.load() factory can be used if you need to specify specific
/// paths to certain tools.

import 'dart:io';

import 'package:path/path.dart' as path;

import 'internal/command.dart';
import 'heck_exception.dart';

class SDKConfig {
  final String? flutter;
  final String? avdmanager;
  final String? emulator;
  final String? adb;
  final String? xcrun;
  final String? plutil;

  /// Load Android and iOS SDK configuration assuming normal defaults and tools
  /// in the path.
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
    String? xcrun;
    String? plutil;
    if (Platform.isMacOS) {
      xcrun = 'xcrun';
      plutil = 'plutil';
    }

    return load(
      flutter: 'flutter',
      avdmanager: 'avdmanager',
      emulator: emulator,
      adb: adb,
      xcrun: xcrun,
      plutil: plutil,
    );
  }

  /// Loads SDK conjfigurat
  static Future<SDKConfig> load(
      {String? flutter,
      String? avdmanager,
      String? emulator,
      String? adb,
      String? xcrun,
      String? plutil,
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
      await Future.wait(checks);
    }
    return SDKConfig._internal(
        flutter: flutter, avdmanager: avdmanager, emulator: emulator, adb: adb);
  }

  SDKConfig._internal(
      {this.flutter,
      this.avdmanager,
      this.emulator,
      this.adb,
      this.xcrun,
      this.plutil});

  static final _expectedFlutter = RegExp(r'Flutter \d+\.\d+\.\d+ ');

  static Future<void> _checkFlutter(String path) async {
    final command = Command(path, ['--version']);
    final result = command.runSync();
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
    final result = command.runSync();
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
    final result = command.runSync();
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
    final result = command.runSync();
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
    final result = command.runSync();
    if (result.exitCode != 1) {
      throw HeckException('Bad exit code from "$command"');
    }
    if (!_expectedPlutil.hasMatch(result.stdout)) {
      throw HeckException('Unexpected output from $result');
    }
  }

  static final _expectedXcrun = RegExp(r'xcrun version \d+');

  static Future<void> _checkXcrun(String path) async {
    final command = Command(path, []);
    final result = command.runSync();
    if (result.exitCode != 1) {
      throw HeckException('Bad exit code from "$command"');
    }
    if (!_expectedXcrun.hasMatch(result.stdout)) {
      throw HeckException('Unexpected output from $result');
    }
  }
}

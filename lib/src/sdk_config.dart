/// SDK Configuration
///
/// This class shows where to find key tools for emulator management.

import 'dart:io';

import 'command.dart';
import 'emulator_exception.dart';

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

  static Future<SDKConfig> loadDefaults() async {
    return load(
      flutter: 'flutter',
      avdmanager: 'avdmanager',
      emulator: 'emulator',
      adb: 'adb',
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

  static Future<void> _checkAdb(String path) async {
    final command = Command(path, ['--version']);
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw _panic('Bad exit code from "$command"');
    }
    if (!_expectedAdb.hasMatch(result.stdout)) {
      throw _panic('Unexpected output from $result');
    }
  }

  static EmulatorException _panic(String reason) {
    return EmulatorException(reason);
  }
}

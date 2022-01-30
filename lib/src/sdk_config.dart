/// SDK Configuration
///
/// This class shows where to find key tools for emulator management.

import 'dart:io';

import 'emulator_exception.dart';

class SDKConfig {
  // Path to the avdmanager binary.
  final String? avdmanager;

  static Future<SDKConfig> load({String? avdmanager}) async {
    if (avdmanager != null) {
      _checkAvdmanager(avdmanager);
    }
    return SDKConfig._internal(avdmanager: avdmanager);
  }

  static Future<SDKConfig> loadDefaults() async {
    return load(avdmanager: 'avdmanager');
  }

  SDKConfig._internal({this.avdmanager});

  static final _expectedAvdmanager = RegExp(r'Available Android targets');

  static void _checkAvdmanager(String path) {
    final commandLine = '$path list target';
    try {
      final result = Process.runSync(path, ['list', 'target']);
      if (result.exitCode != 0) {
        throw _panic('Error from "$commandLine"', result);
      }
      if (!_expectedAvdmanager.hasMatch(result.stdout)) {
        throw _panic('Unexpected output from "$commandLine"', result);
      }
    } on ProcessException catch (e) {
      throw EmulatorException('Could not run "$commandLine"', e);
    }
  }

  static EmulatorException _panic(String reason, ProcessResult result) {
    return EmulatorException('$reason. Exit code: ${result.exitCode}\n' +
        result.stdout +
        '\n' +
        result.stderr);
  }
}

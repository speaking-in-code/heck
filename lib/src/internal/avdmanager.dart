import 'package:built_collection/built_collection.dart';
import 'package:emulators/src/command.dart';
import 'package:emulators/src/emulator_exception.dart';

import 'models/system_image.dart';

class AVDManager {
  static final _systemImages = RegExp(r'^system-images;');

  static Future<BuiltList<SystemImage>> listSystemImages(
      Command command) async {
    final result = command.runSync();
    if (result.exitCode != 1) {
      throw EmulatorException(
          'Unexpected output for listing system images: $result');
    }
    final lines = result.stderr.split('\n');
    final images = ListBuilder<SystemImage>();
    for (final line in lines) {
      if (_systemImages.hasMatch(line)) {
        images.add(SystemImage((b) => b.name = line));
      }
    }
    return images.build();
  }

  static final _skin = RegExp(r'^id: \d+ or "([^"]+)"');

  static Future<List<String>> listSkins(Command command) async {
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw EmulatorException('Unexpected output for listing skins: $result');
    }
    final lines = result.stdout.split('\n');
    final out = <String>[];
    for (final line in lines) {
      final match = _skin.firstMatch(line);
      if (match == null) {
        continue;
      }
      out.add(match.group(1)!);
    }
    return out;
  }

  static Future<void> createDevice(Command command) async {
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw EmulatorException(
          'Unexpected output for creating new device: $result');
    }
  }

  static Future<void> deleteDevice(Command command) async {
    final result = command.runSync();
    if (result.exitCode != 0) {
      throw EmulatorException('Unexpected output for deleting device: $result');
    }
  }
}

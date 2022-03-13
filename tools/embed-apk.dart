import 'dart:io';

import 'package:args/args.dart';
import 'package:crypto/crypto.dart';

const apk = 'apk';
const lib = 'lib';
const name = 'name';

ArgResults _parseOrExit(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(apk,
        help: 'Path to APK to embed', valueHelp: 'APK', mandatory: true)
    ..addOption(lib,
        help: 'Output dart library path',
        valueHelp: 'lib/example.g.dart',
        mandatory: true)
    ..addOption(name,
        help: 'Constant name to generate',
        valueHelp: 'apkBytes',
        mandatory: true);
  try {
    return parser.parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln('Usage: dart embed-apk [options]');
    stderr.writeln('Options:\n${parser.usage}');
    exit(exitCode);
  }
}

void main(List<String> arguments) async {
  exitCode = 1;
  final args = _parseOrExit(arguments);
  stderr.writeln('Reading ${args[apk]}');
  final apkFile = File(args[apk]);
  final apkFileBytes = await apkFile.readAsBytes();
  final hash = sha256.convert(apkFileBytes);
  stderr.writeln('Writing ${args[lib]}');
  final outFile = File(args[lib]).openWrite();
  outFile.write('''// Embedded data generated from embed-apk
// APK path: ${args['apk']}
// Size: ${apkFileBytes.lengthInBytes} bytes
// SHA-256 sum: $hash
// Generated on: ${DateTime.now()}
// Command line:
//   dart embed-apk.dart -apk "${args[apk]}" -lib "${args[lib]}" -name "${args[name]}"

const List<int> ${args[name]} = [
''');
  // We do our own buffering here because of https://github.com/dart-lang/sdk/issues/32874.
  // Without this the flush call takes over a minute.
  String buffer = '';
  for (int i = 0; i < apkFileBytes.length; ++i) {
    final start = (i % 16 == 0);
    final end = (i % 16 == 15 || i == apkFileBytes.length - 1);
    if (start) {
      buffer = '$buffer  ';
    }
    String hex = apkFileBytes[i].toRadixString(16);
    if (hex.length == 1) {
      hex = '0$hex';
    }
    buffer = '${buffer}0x$hex,';
    if (!end) {
      buffer = '$buffer ';
    } else {
      buffer = '$buffer\n';
    }
    if (buffer.length > 10 * 1024) {
      outFile.write(buffer);
      buffer = '';
    }
  }
  outFile.write(buffer);
  outFile.write('''];
  ''');
  await outFile.flush();
  await outFile.close();
  stderr.writeln('Done');
  exitCode = 0;
  exit(exitCode);
}

import 'dart:io';

import 'dart:math';

import 'package:emulators/src/command.dart';

class TempDir {
  final _dir = Directory.systemTemp.createTempSync();
  final _rand = Random();

  TempDir();

  void cleanup() {
    _dir.deleteSync(recursive: true);
  }

  File makeFile(String contents) {
    File file = File('${_dir.path}/${_rand.nextInt(10000)}');
    file.writeAsStringSync(contents, flush: true);
    return file;
  }

  Command dump(File file) {
    return Command('cat', [file.path]);
  }

  Command dumpAsError(File file) {
    return Command('sh', ['-c', 'cat ${file.path} 1>&2 && exit 1']);
  }
}

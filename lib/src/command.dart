/// A wrapper for dart:io Process that adds some additional functionality.
///

import 'dart:io';

import 'package:emulators/emulators.dart';

class Command {
  final String executable;
  final String? workingDirectory;
  final List<String> arguments;

  Command(this.executable, this.arguments, {this.workingDirectory});

  @override
  String toString() {
    String out = '';
    if (workingDirectory != null) {
      out += 'dir=$workingDirectory, ';
    }
    out += executable;
    if (arguments.isNotEmpty) {
      out += ' ';
      out += arguments.join(' ');
    }
    return out;
  }

  // TODO: add a timeout here.
  CommandResult runSync() {
    try {
      final result = Process.runSync(executable, arguments,
          workingDirectory: workingDirectory);
      return CommandResult(
          command: this,
          stdout: result.stdout,
          stderr: result.stderr,
          exitCode: result.exitCode);
    } on ProcessException catch (e) {
      return CommandResult(
          command: this, exitCode: -1, stdout: '', stderr: '', exception: e);
    }
  }

  Future<RunningCommand> runBackground() async {
    try {
      final process = await Process.start(executable, arguments);
      return RunningCommand(this, process);
    } on ProcessException catch (e) {
      throw EmulatorException('Failed to start $this', e);
    }
  }
}

class CommandResult {
  final Command command;
  final int exitCode;
  final String stdout;
  final String stderr;
  final ProcessException? exception;

  CommandResult(
      {required this.command,
      required this.exitCode,
      required this.stdout,
      required this.stderr,
      this.exception});

  @override
  String toString() {
    String out =
        '"$command", Code: $exitCode\n\nstdout: $stdout\n\nstderr: $stderr';
    if (exception != null) {
      out += ', exception: $exception';
    }
    return out;
  }
}

// A running process. Note that this is not super efficient, it keeps a copy
// of stdout and stderr from the running process in memory. Maybe think through
// a better logging system.
class RunningCommand {
  static const _encoding = SystemEncoding();
  final Command command;
  final Process process;
  String stdout = '';
  String stderr = '';
  int? exitCode;
  bool get running => (exitCode == null);

  RunningCommand(this.command, this.process) {
    process.exitCode.then((code) {
      exitCode = code;
    });
    process.stdout.transform(_encoding.decoder).forEach((String out) {
      stdout += out;
    });
    process.stderr.transform(_encoding.decoder).forEach((String out) {
      stderr += out;
    });
  }

  @override
  String toString() {
    String out = '"$command", PID: ${process.pid}, Exit Code: $exitCode';
    return out;
  }
}

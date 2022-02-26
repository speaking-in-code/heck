/// A wrapper for dart:io Process that adds some additional functionality.
///

import 'dart:io' as io;

import 'package:heck/heck.dart';

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

  Future<CommandResult> run() async {
    try {
      final result = await io.Process.run(executable, arguments,
          workingDirectory: workingDirectory);
      return CommandResult(
          command: this,
          stdout: result.stdout,
          stderr: result.stderr,
          exitCode: result.exitCode);
    } on io.ProcessException catch (e) {
      return CommandResult(
          command: this, exitCode: -1, stdout: '', stderr: '', exception: e);
    }
  }

  Future<RunningCommand> runBackground({bool streamOutput = false}) async {
    try {
      final process = await io.Process.start(executable, arguments,
          workingDirectory: workingDirectory);
      return RunningCommand(this, process, streamOutput: streamOutput);
    } on io.ProcessException catch (e) {
      throw HeckException('Failed to start $this', e);
    }
  }
}

class CommandResult {
  final Command command;
  final int exitCode;
  final String stdout;
  final String stderr;
  final io.ProcessException? exception;

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
  static const _encoding = io.SystemEncoding();
  final Command command;
  final io.Process process;
  final bool streamOutput;
  String stdout = '';
  String stderr = '';
  int? exitCode;
  bool get running => (exitCode == null);

  RunningCommand(this.command, this.process, {this.streamOutput = false}) {
    process.exitCode.then((code) {
      exitCode = code;
    });
    process.stdout.transform(_encoding.decoder).forEach((String out) {
      if (streamOutput) {
        io.stdout.write(out);
      }
      stdout += out;
    });
    process.stderr.transform(_encoding.decoder).forEach((String out) {
      if (streamOutput) {
        io.stderr.write(out);
      }
      stderr += out;
    });
  }

  @override
  String toString() {
    String out = '"$command", PID: ${process.pid}, Exit Code: $exitCode';
    return out;
  }
}

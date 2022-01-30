/// A wrapper for dart:io Process that adds some additional functionality.
///

import 'dart:io';

class Command {
  final String executable;
  final List<String> arguments;

  Command(this.executable, this.arguments);

  @override
  String toString() {
    String out = executable;
    if (arguments.isNotEmpty) {
      out += ' ';
      out += arguments.join(' ');
    }
    return out;
  }

  // TODO: add a timeout here.
  CommandResult runSync() {
    try {
      final result = Process.runSync(executable, arguments);
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
        '"$command", Code: $exitCode, stdout: $stdout, stderr: $stderr';
    if (exception != null) {
      out += ', exception: $exception';
    }
    return out;
  }
}

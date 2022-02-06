import 'package:emulators/src/command.dart';

class RunningEmulator {
  final String name;
  final RunningCommand command;

  RunningEmulator(this.name, this.command);

  Future<void> waitForReady() async {}
}

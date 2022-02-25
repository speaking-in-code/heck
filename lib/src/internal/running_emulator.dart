import 'package:emulators/src/command.dart';

class RunningEmulator {
  final String id;
  final RunningCommand command;

  RunningEmulator(this.id, this.command);

  Future<void> waitForReady() async {}
}

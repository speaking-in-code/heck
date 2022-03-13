import 'package:heck/heck.dart';
import 'package:heck/src/heck_sdk_config.dart';
import 'package:heck/src/internal/command.dart';

class FlutterDrive {
  final HeckSDKConfig _sdkConfig;

  FlutterDrive(this._sdkConfig);

  Future<CommandResult> drive({
    required String deviceId,
    required String? workingDirectory,
    required Iterable<String> arguments,
  }) async {
    final args = <String>['-d', deviceId, 'drive'];
    args.addAll(arguments);
    final command = Command(
      _sdkConfig.flutter!,
      args,
      workingDirectory: workingDirectory,
    );
    final running = await command.runBackground(streamOutput: true);
    await running.process.exitCode;
    return CommandResult(
        command: command,
        exitCode: running.exitCode!,
        stdout: running.stdout,
        stderr: running.stderr);
  }
}

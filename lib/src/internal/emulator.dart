import 'dart:io';

import 'package:emulators/src/running_emulator.dart';
import 'package:emulators/src/sdk_config.dart';

import 'command.dart';
import 'emulator_exception.dart';

class Emulator {
  // Android qemu emulation uses even numbered ports in this range for
  // communication. We pick an open one, then tell qemu to use that one so that
  // the emulator name in adb devices/flutter devices is predictable.
  static final int _minPort = 5554;
  static final int _maxPort = 5584;

  static Future<int> _findOpenPort() async {
    for (int port = _minPort; port <= _maxPort; port += 2) {
      ServerSocket? socket;
      try {
        socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
        return port;
      } on SocketException {
        continue;
      } finally {
        socket?.close();
      }
    }
    // This will probably go badly, but let's try anyway.
    return _minPort;
  }

  static Future<RunningEmulator> startDevice(SDKConfig sdkConfig, String name,
      {String locale = ''}) async {
    final port = await _findOpenPort();
    final args = ['-avd', name, '-port', '$port', '-no-snapshot-save'];
    if (locale.isNotEmpty) {
      args.addAll(['-change-locale', locale]);
    }
    final command = Command(sdkConfig.emulator!, args);
    final running = await command.runBackground(streamOutput: true);
    return RunningEmulator('emulator-$port', running);
  }
}

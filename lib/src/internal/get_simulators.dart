import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:heck/heck.dart';
import 'package:heck/src/internal/command.dart';
import 'package:heck/src/models/simulators.dart';
import 'package:heck/src/internal/models/serializers.dart';
import 'package:heck/src/internal/models/simctl_list.dart';

class GetSimulators {
  final HeckSDKConfig sdkConfig;

  GetSimulators(this.sdkConfig);

  Future<Simulators> getSimulators() async {
    Future<CommandResult>? androidFormFactorsCmd;
    Future<CommandResult>? androidRuntimesCmd;
    Future<CommandResult>? androidDevicesCmd;
    // Note that avdmanager has a --compact flag that in theory makes the output
    // easier to parse, but in practice mixes weird text with structured data.
    // We parse the human-readable output instead, and hope it doesn't change.
    if (sdkConfig.avdmanager != null) {
      androidFormFactorsCmd =
          Command(sdkConfig.avdmanager!, ['list', 'device']).run();
      // This gets a helpful error with the list of valid system image paths.
      // sdkmanager does not appear to have this easily available on the command
      // line.
      androidRuntimesCmd = Command(sdkConfig.avdmanager!, [
        'create',
        'avd',
        '--name',
        'unused',
        '--package',
        'unused',
      ]).run();
      androidDevicesCmd = Command(sdkConfig.avdmanager!, ['list', 'avd']).run();
    }

    Future<CommandResult>? simctlCmd;
    if (sdkConfig.xcrun != null) {
      simctlCmd = Command(sdkConfig.xcrun!, ['simctl', 'list', '--json']).run();
    }
    SimulatorsBuilder sims = SimulatorsBuilder();
    sims.androidFormFactors = [];
    sims.androidDevices = [];
    sims.androidRuntimes = [];
    sims.iosDevices = [];
    sims.iosFormFactors = [];
    sims.iosRuntimes = [];
    if (androidFormFactorsCmd != null) {
      sims.androidFormFactors =
          parseAndroidFormFactors(await androidFormFactorsCmd);
    }
    if (androidRuntimesCmd != null) {
      sims.androidRuntimes = parseAndroidRuntimes(await androidRuntimesCmd);
    }
    if (androidDevicesCmd != null) {
      sims.androidDevices = parseAndroidDevices(await androidDevicesCmd);
    }
    if (simctlCmd != null) {
      parseSimctl(await simctlCmd, sims);
    }
    return sims.build();
  }

  static final _avdManagerOutput = RegExp(r'^id: \d+ or "([^"]+)"');

  BuiltList<AndroidFormFactor> parseAndroidFormFactors(CommandResult result) {
    final formFactors = parseAVDOutput(result);
    final out = ListBuilder<AndroidFormFactor>();
    for (final formFactor in formFactors) {
      out.add((AndroidFormFactorBuilder()..formFactor = formFactor).build());
    }
    return out.build();
  }

  // Example lines that should match:
  //   system-images;android-23;default;x86_64
  //   system-images;android-23;android-tv;armeabi-v7a
  // Things that should not:
  //   Error: Package path is not valid. Valid system image paths are:
  static final _runtimesOutput = RegExp(r'^system-images;[^ ]+');

  BuiltList<AndroidRuntime> parseAndroidRuntimes(CommandResult result) {
    if (result.exitCode != 1) {
      throw HeckException('Unable to parse android runtimes: $result');
    }
    final out = ListBuilder<AndroidRuntime>();
    for (final line in result.stderr.split('\n')) {
      if (_runtimesOutput.hasMatch(line)) {
        out.add((AndroidRuntimeBuilder()..runtime = line.trim()).build());
      }
    }
    return out.build();
  }

  List<String> parseAVDOutput(CommandResult result) {
    if (result.exitCode != 0) {
      throw HeckException('Error from avdmanager: $result');
    }
    final out = <String>[];
    for (final line in result.stdout.split('\n')) {
      final match = _avdManagerOutput.firstMatch(line);
      if (match == null) {
        continue;
      }
      out.add(match.group(1)!);
    }
    return out;
  }

  static final _avdListOutput = RegExp(r'^\s+Name: (.+)$');

  BuiltList<AndroidDevice> parseAndroidDevices(CommandResult result) {
    if (result.exitCode != 0) {
      throw HeckException('Error from avdmanager: $result');
    }
    final out = ListBuilder<AndroidDevice>();
    for (final line in result.stdout.split('\n')) {
      final match = _avdListOutput.firstMatch(line);
      if (match == null) {
        continue;
      }
      out.add((AndroidDeviceBuilder()..name = match.group(1)!).build());
    }
    return out.build();
  }

  void parseSimctl(CommandResult result, SimulatorsBuilder sims) {
    if (result.exitCode != 0) {
      throw HeckException('Error from simctl: $result');
    }
    try {
      final simctlList =
          serializers.fromJson(SimctlList.serializer, result.stdout);
      if (simctlList == null) {
        throw HeckException('Unable to parse simctl output: $result');
      }
      final outFormFactors = ListBuilder<IOSFormFactor>();
      for (final devicetype in simctlList.devicetypes) {
        outFormFactors.add(
            (IOSFormFactorBuilder()..formFactor = devicetype.name).build());
      }
      sims.iosFormFactors = outFormFactors.build();

      final outRuntimes = ListBuilder<IOSRuntime>();
      for (final runtime in simctlList.runtimes) {
        outRuntimes.add(getIOSRuntime(runtime));
      }
      sims.iosRuntimes = outRuntimes.build();

      final outDevices = ListBuilder<IOSDevice>();
      for (final device in simctlList.devices.values) {
        outDevices.add(getIOSDevice(device));
      }
      sims.iosDevices = outDevices.build();
    } on DeserializationError catch (e) {
      throw HeckException.fromError(
          'simctl list unexpected output: $result', e);
    } on FormatException catch (e) {
      throw HeckException('simctrl list unexpected output: $result', e);
    }
  }

  IOSDevice getIOSDevice(SimctlDevice dev) {
    return (IOSDeviceBuilder()
          ..name = dev.name
          ..dataPath = dev.dataPath)
        .build();
  }

  IOSRuntime getIOSRuntime(SimctlRuntime runtime) {
    return (IOSRuntimeBuilder()
          ..version = runtime.version
          ..identifier = runtime.identifier)
        .build();
  }
}

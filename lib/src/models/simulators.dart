import 'package:built_value/built_value.dart';

part 'simulators.g.dart';

/// All available OS/Runtime images, form factors, and already created devices.
abstract class Simulators implements Built<Simulators, SimulatorsBuilder> {
  Iterable<AndroidRuntime> get androidRuntimes;
  Iterable<AndroidFormFactor> get androidFormFactors;
  Iterable<AndroidDevice> get androidDevices;

  Iterable<IOSRuntime> get iosRuntimes;
  Iterable<IOSFormFactor> get iosFormFactors;
  Iterable<IOSDevice> get iosDevices;

  Simulators._();
  factory Simulators([void Function(SimulatorsBuilder) updates]) = _$Simulators;
}

abstract class AndroidRuntime
    implements Built<AndroidRuntime, AndroidRuntimeBuilder> {
  String get runtime;

  AndroidRuntime._();
  factory AndroidRuntime([void Function(AndroidRuntimeBuilder) updates]) =
      _$AndroidRuntime;
}

abstract class AndroidFormFactor
    implements Built<AndroidFormFactor, AndroidFormFactorBuilder> {
  String get formFactor;

  AndroidFormFactor._();
  factory AndroidFormFactor([void Function(AndroidFormFactorBuilder) updates]) =
      _$AndroidFormFactor;
}

abstract class AndroidDevice
    implements Built<AndroidDevice, AndroidDeviceBuilder> {
  String get name;

  AndroidDevice._();
  factory AndroidDevice([void Function(AndroidDeviceBuilder) updates]) =
      _$AndroidDevice;
}

abstract class IOSRuntime implements Built<IOSRuntime, IOSRuntimeBuilder> {
  // Version, e.g. 10.3.1
  String get version;
  // Identifier e.g. com.apple.CoreSimulator.SimRuntime.iOS-10-3
  String get identifier;

  IOSRuntime._();
  factory IOSRuntime([void Function(IOSRuntimeBuilder) updates]) = _$IOSRuntime;
}

abstract class IOSFormFactor
    implements Built<IOSFormFactor, IOSFormFactorBuilder> {
  String get formFactor;

  IOSFormFactor._();
  factory IOSFormFactor([void Function(IOSFormFactorBuilder) updates]) =
      _$IOSFormFactor;
}

abstract class IOSDevice implements Built<IOSDevice, IOSDeviceBuilder> {
  String get name;
  String get dataPath;
  String get id;

  IOSDevice._();
  factory IOSDevice([void Function(IOSDeviceBuilder) updates]) = _$IOSDevice;
}

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'simctl_list.g.dart';

/// Parses output of simctl list --json.
abstract class SimctlList implements Built<SimctlList, SimctlListBuilder> {
  BuiltList<SimctlDeviceType> get devicetypes;
  BuiltListMultimap<String, SimctlDevice> get devices;
  BuiltList<SimctlRuntime> get runtimes;

  SimctlList._();
  factory SimctlList([void Function(SimctlListBuilder) updates]) = _$SimctlList;
  static Serializer<SimctlList> get serializer => _$simctlListSerializer;
}

// Devices:
// actual format:
//     {
//       "minRuntimeVersion" : 589824,
//       "bundlePath" : "\/Applications\/Xcode.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 6s.simdevicetype",
//       "maxRuntimeVersion" : 4294967295,
//       "name" : "iPhone 6s",
//       "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-6s",
//       "productFamily" : "iPhone"
//     }
abstract class SimctlDeviceType
    implements Built<SimctlDeviceType, SimctlDeviceTypeBuilder> {
  String get name;

  SimctlDeviceType._();
  factory SimctlDeviceType([void Function(SimctlDeviceTypeBuilder) updates]) =
      _$SimctlDeviceType;
  static Serializer<SimctlDeviceType> get serializer =>
      _$simctlDeviceTypeSerializer;
}

// actual format
//     {
//       "bundlePath" : "\/Library\/Developer\/CoreSimulator\/Profiles\/Runtimes\/iOS 10.3.simruntime",
//       "availabilityError" : "The iOS 10.3 simulator runtime is not supported on hosts after macOS 10.15.99.",
//       "buildversion" : "14E8301",
//       "runtimeRoot" : "\/Library\/Developer\/CoreSimulator\/Profiles\/Runtimes\/iOS 10.3.simruntime\/Contents\/Resources\/RuntimeRoot",
//       "identifier" : "com.apple.CoreSimulator.SimRuntime.iOS-10-3",
//       "version" : "10.3.1",
//       "isAvailable" : false,
//       "supportedDeviceTypes" : [
//            ..
abstract class SimctlRuntime
    implements Built<SimctlRuntime, SimctlRuntimeBuilder> {
  String get identifier;
  String get version;

  SimctlRuntime._();
  factory SimctlRuntime([void Function(SimctlRuntimeBuilder) updates]) =
      _$SimctlRuntime;
  static Serializer<SimctlRuntime> get serializer => _$simctlRuntimeSerializer;
}

// Actual format:
//   {
//         "availabilityError" : "runtime profile not found",
//         "dataPath" : "\/Users\/brian\/Library\/Developer\/CoreSimulator\/Devices\/E629D1EC-EA1E-4648-AA2E-284AC03DEB38\/data",
//         "dataPathSize" : 0,
//         "logPath" : "\/Users\/brian\/Library\/Logs\/CoreSimulator\/E629D1EC-EA1E-4648-AA2E-284AC03DEB38",
//         "udid" : "E629D1EC-EA1E-4648-AA2E-284AC03DEB38",
//         "isAvailable" : false,
//         "deviceTypeIdentifier" : "com.apple.CoreSimulator.SimDeviceType.Apple-TV-1080p",
//         "state" : "Shutdown",
//         "name" : "Apple TV"
//       },

abstract class SimctlDevice
    implements Built<SimctlDevice, SimctlDeviceBuilder> {
  String get udid;
  String get name;
  String get dataPath;

  SimctlDevice._();
  factory SimctlDevice([void Function(SimctlDeviceBuilder) updates]) =
      _$SimctlDevice;
  static Serializer<SimctlDevice> get serializer => _$simctlDeviceSerializer;
}

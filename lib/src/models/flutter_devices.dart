import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'flutter_devices.g.dart';

/// Output of 'flutter devices --machine'
abstract class FlutterDevices
    implements Built<FlutterDevices, FlutterDevicesBuilder> {
  BuiltList<FlutterDevice> get devices;

  FlutterDevices._();
  factory FlutterDevices() = _$FlutterDevices;
  static Serializer<FlutterDevices> get serializer =>
      _$flutterDevicesSerializer;
}

/// A single device. We only use two fields right now.
//
// Full output looks like this:
//   {
//     "name": "emulator-5554",
//     "id": "emulator-5554",
//     "isSupported": true,
//     "targetPlatform": "android-x86",
//     "emulator": true,
//     "sdk": "Android 4.1.2 (API 16)",
//     "capabilities": {
//       "hotReload": true,
//       "hotRestart": true,
//       "screenshot": true,
//       "fastStart": true,
//       "flutterExit": true,
//       "hardwareRendering": true,
//       "startPaused": true
//     }
//   }
abstract class FlutterDevice
    implements Built<FlutterDevice, FlutterDeviceBuilder> {
  String get name;
  String get id;

  FlutterDevice._();
  factory FlutterDevice() = _$FlutterDevice;
  static Serializer<FlutterDevice> get serializer => _$flutterDeviceSerializer;
}

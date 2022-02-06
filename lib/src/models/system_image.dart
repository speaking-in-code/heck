import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'system_image.g.dart';

abstract class SystemImage implements Built<SystemImage, SystemImageBuilder> {
  /// Full name of the system image, e.g.
  /// system-images;android-23;google_apis;x86_6
  String get name;

  // Source portion of name, e.g system-images
  String? get source => _getSourceField(0);

  /// OS level, e.g. android-23
  String? get osLevel => _getSourceField(1);

  /// APIS, e.g. google_apis or default
  String? get apis => _getSourceField(2);

  // ABI, e.g. x86 or x86_64
  String? get abi => _getSourceField(3);

  String? _getSourceField(int index) {
    if (_fields.length == 4 && index >= 0 && index < 4) {
      return _fields[index];
    }
    return null;
  }

  @memoized
  List<String> get _fields => name.split(r';');

  SystemImage._();
  factory SystemImage([void Function(SystemImageBuilder) updates]) =
      _$SystemImage;
}

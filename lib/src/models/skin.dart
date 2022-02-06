import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'skin.g.dart';

abstract class Skin implements Built<Skin, SkinBuilder> {
  String get name;

  Skin._();
  factory Skin([void Function(SkinBuilder) updates]) = _$Skin;
}

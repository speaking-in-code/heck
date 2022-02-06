// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_image.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SystemImage extends SystemImage {
  @override
  final String name;
  List<String>? ___fields;

  factory _$SystemImage([void Function(SystemImageBuilder)? updates]) =>
      (new SystemImageBuilder()..update(updates)).build();

  _$SystemImage._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'SystemImage', 'name');
  }

  @override
  List<String> get _fields => ___fields ??= super._fields;

  @override
  SystemImage rebuild(void Function(SystemImageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SystemImageBuilder toBuilder() => new SystemImageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SystemImage && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SystemImage')..add('name', name))
        .toString();
  }
}

class SystemImageBuilder implements Builder<SystemImage, SystemImageBuilder> {
  _$SystemImage? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SystemImageBuilder();

  SystemImageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SystemImage other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SystemImage;
  }

  @override
  void update(void Function(SystemImageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SystemImage build() {
    final _$result = _$v ??
        new _$SystemImage._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'SystemImage', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

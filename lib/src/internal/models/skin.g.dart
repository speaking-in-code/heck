// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skin.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Skin extends Skin {
  @override
  final String name;

  factory _$Skin([void Function(SkinBuilder)? updates]) =>
      (new SkinBuilder()..update(updates)).build();

  _$Skin._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'Skin', 'name');
  }

  @override
  Skin rebuild(void Function(SkinBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SkinBuilder toBuilder() => new SkinBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Skin && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Skin')..add('name', name)).toString();
  }
}

class SkinBuilder implements Builder<Skin, SkinBuilder> {
  _$Skin? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SkinBuilder();

  SkinBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Skin other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Skin;
  }

  @override
  void update(void Function(SkinBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Skin build() {
    final _$result = _$v ??
        new _$Skin._(
            name: BuiltValueNullFieldError.checkNotNull(name, 'Skin', 'name'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

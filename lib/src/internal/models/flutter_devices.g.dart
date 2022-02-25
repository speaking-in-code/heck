// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flutter_devices.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FlutterDevices> _$flutterDevicesSerializer =
    new _$FlutterDevicesSerializer();
Serializer<FlutterDevice> _$flutterDeviceSerializer =
    new _$FlutterDeviceSerializer();

class _$FlutterDevicesSerializer
    implements StructuredSerializer<FlutterDevices> {
  @override
  final Iterable<Type> types = const [FlutterDevices, _$FlutterDevices];
  @override
  final String wireName = 'FlutterDevices';

  @override
  Iterable<Object?> serialize(Serializers serializers, FlutterDevices object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'devices',
      serializers.serialize(object.devices,
          specifiedType:
              const FullType(BuiltList, const [const FullType(FlutterDevice)])),
    ];

    return result;
  }

  @override
  FlutterDevices deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FlutterDevicesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'devices':
          result.devices.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(FlutterDevice)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$FlutterDeviceSerializer implements StructuredSerializer<FlutterDevice> {
  @override
  final Iterable<Type> types = const [FlutterDevice, _$FlutterDevice];
  @override
  final String wireName = 'FlutterDevice';

  @override
  Iterable<Object?> serialize(Serializers serializers, FlutterDevice object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  FlutterDevice deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FlutterDeviceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$FlutterDevices extends FlutterDevices {
  @override
  final BuiltList<FlutterDevice> devices;

  factory _$FlutterDevices([void Function(FlutterDevicesBuilder)? updates]) =>
      (new FlutterDevicesBuilder()..update(updates)).build();

  _$FlutterDevices._({required this.devices}) : super._() {
    BuiltValueNullFieldError.checkNotNull(devices, 'FlutterDevices', 'devices');
  }

  @override
  FlutterDevices rebuild(void Function(FlutterDevicesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FlutterDevicesBuilder toBuilder() =>
      new FlutterDevicesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FlutterDevices && devices == other.devices;
  }

  @override
  int get hashCode {
    return $jf($jc(0, devices.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FlutterDevices')
          ..add('devices', devices))
        .toString();
  }
}

class FlutterDevicesBuilder
    implements Builder<FlutterDevices, FlutterDevicesBuilder> {
  _$FlutterDevices? _$v;

  ListBuilder<FlutterDevice>? _devices;
  ListBuilder<FlutterDevice> get devices =>
      _$this._devices ??= new ListBuilder<FlutterDevice>();
  set devices(ListBuilder<FlutterDevice>? devices) => _$this._devices = devices;

  FlutterDevicesBuilder();

  FlutterDevicesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _devices = $v.devices.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FlutterDevices other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FlutterDevices;
  }

  @override
  void update(void Function(FlutterDevicesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FlutterDevices build() {
    _$FlutterDevices _$result;
    try {
      _$result = _$v ?? new _$FlutterDevices._(devices: devices.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'devices';
        devices.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FlutterDevices', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$FlutterDevice extends FlutterDevice {
  @override
  final String name;
  @override
  final String id;

  factory _$FlutterDevice([void Function(FlutterDeviceBuilder)? updates]) =>
      (new FlutterDeviceBuilder()..update(updates)).build();

  _$FlutterDevice._({required this.name, required this.id}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'FlutterDevice', 'name');
    BuiltValueNullFieldError.checkNotNull(id, 'FlutterDevice', 'id');
  }

  @override
  FlutterDevice rebuild(void Function(FlutterDeviceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FlutterDeviceBuilder toBuilder() => new FlutterDeviceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FlutterDevice && name == other.name && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FlutterDevice')
          ..add('name', name)
          ..add('id', id))
        .toString();
  }
}

class FlutterDeviceBuilder
    implements Builder<FlutterDevice, FlutterDeviceBuilder> {
  _$FlutterDevice? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  FlutterDeviceBuilder();

  FlutterDeviceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FlutterDevice other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FlutterDevice;
  }

  @override
  void update(void Function(FlutterDeviceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FlutterDevice build() {
    final _$result = _$v ??
        new _$FlutterDevice._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'FlutterDevice', 'name'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, 'FlutterDevice', 'id'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

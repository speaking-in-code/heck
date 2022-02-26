// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simctl_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SimctlList> _$simctlListSerializer = new _$SimctlListSerializer();
Serializer<SimctlDeviceType> _$simctlDeviceTypeSerializer =
    new _$SimctlDeviceTypeSerializer();
Serializer<SimctlRuntime> _$simctlRuntimeSerializer =
    new _$SimctlRuntimeSerializer();
Serializer<SimctlDevice> _$simctlDeviceSerializer =
    new _$SimctlDeviceSerializer();

class _$SimctlListSerializer implements StructuredSerializer<SimctlList> {
  @override
  final Iterable<Type> types = const [SimctlList, _$SimctlList];
  @override
  final String wireName = 'SimctlList';

  @override
  Iterable<Object?> serialize(Serializers serializers, SimctlList object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'devicetypes',
      serializers.serialize(object.devicetypes,
          specifiedType: const FullType(
              BuiltList, const [const FullType(SimctlDeviceType)])),
      'devices',
      serializers.serialize(object.devices,
          specifiedType: const FullType(BuiltListMultimap,
              const [const FullType(String), const FullType(SimctlDevice)])),
      'runtimes',
      serializers.serialize(object.runtimes,
          specifiedType:
              const FullType(BuiltList, const [const FullType(SimctlRuntime)])),
    ];

    return result;
  }

  @override
  SimctlList deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SimctlListBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'devicetypes':
          result.devicetypes.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SimctlDeviceType)]))!
              as BuiltList<Object?>);
          break;
        case 'devices':
          result.devices.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltListMultimap, const [
                const FullType(String),
                const FullType(SimctlDevice)
              ]))!);
          break;
        case 'runtimes':
          result.runtimes.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(SimctlRuntime)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$SimctlDeviceTypeSerializer
    implements StructuredSerializer<SimctlDeviceType> {
  @override
  final Iterable<Type> types = const [SimctlDeviceType, _$SimctlDeviceType];
  @override
  final String wireName = 'SimctlDeviceType';

  @override
  Iterable<Object?> serialize(Serializers serializers, SimctlDeviceType object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SimctlDeviceType deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SimctlDeviceTypeBuilder();

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
      }
    }

    return result.build();
  }
}

class _$SimctlRuntimeSerializer implements StructuredSerializer<SimctlRuntime> {
  @override
  final Iterable<Type> types = const [SimctlRuntime, _$SimctlRuntime];
  @override
  final String wireName = 'SimctlRuntime';

  @override
  Iterable<Object?> serialize(Serializers serializers, SimctlRuntime object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'identifier',
      serializers.serialize(object.identifier,
          specifiedType: const FullType(String)),
      'version',
      serializers.serialize(object.version,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SimctlRuntime deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SimctlRuntimeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'identifier':
          result.identifier = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'version':
          result.version = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SimctlDeviceSerializer implements StructuredSerializer<SimctlDevice> {
  @override
  final Iterable<Type> types = const [SimctlDevice, _$SimctlDevice];
  @override
  final String wireName = 'SimctlDevice';

  @override
  Iterable<Object?> serialize(Serializers serializers, SimctlDevice object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'udid',
      serializers.serialize(object.udid, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'dataPath',
      serializers.serialize(object.dataPath,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SimctlDevice deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SimctlDeviceBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'udid':
          result.udid = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'dataPath':
          result.dataPath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SimctlList extends SimctlList {
  @override
  final BuiltList<SimctlDeviceType> devicetypes;
  @override
  final BuiltListMultimap<String, SimctlDevice> devices;
  @override
  final BuiltList<SimctlRuntime> runtimes;

  factory _$SimctlList([void Function(SimctlListBuilder)? updates]) =>
      (new SimctlListBuilder()..update(updates)).build();

  _$SimctlList._(
      {required this.devicetypes,
      required this.devices,
      required this.runtimes})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        devicetypes, 'SimctlList', 'devicetypes');
    BuiltValueNullFieldError.checkNotNull(devices, 'SimctlList', 'devices');
    BuiltValueNullFieldError.checkNotNull(runtimes, 'SimctlList', 'runtimes');
  }

  @override
  SimctlList rebuild(void Function(SimctlListBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SimctlListBuilder toBuilder() => new SimctlListBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SimctlList &&
        devicetypes == other.devicetypes &&
        devices == other.devices &&
        runtimes == other.runtimes;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, devicetypes.hashCode), devices.hashCode),
        runtimes.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SimctlList')
          ..add('devicetypes', devicetypes)
          ..add('devices', devices)
          ..add('runtimes', runtimes))
        .toString();
  }
}

class SimctlListBuilder implements Builder<SimctlList, SimctlListBuilder> {
  _$SimctlList? _$v;

  ListBuilder<SimctlDeviceType>? _devicetypes;
  ListBuilder<SimctlDeviceType> get devicetypes =>
      _$this._devicetypes ??= new ListBuilder<SimctlDeviceType>();
  set devicetypes(ListBuilder<SimctlDeviceType>? devicetypes) =>
      _$this._devicetypes = devicetypes;

  ListMultimapBuilder<String, SimctlDevice>? _devices;
  ListMultimapBuilder<String, SimctlDevice> get devices =>
      _$this._devices ??= new ListMultimapBuilder<String, SimctlDevice>();
  set devices(ListMultimapBuilder<String, SimctlDevice>? devices) =>
      _$this._devices = devices;

  ListBuilder<SimctlRuntime>? _runtimes;
  ListBuilder<SimctlRuntime> get runtimes =>
      _$this._runtimes ??= new ListBuilder<SimctlRuntime>();
  set runtimes(ListBuilder<SimctlRuntime>? runtimes) =>
      _$this._runtimes = runtimes;

  SimctlListBuilder();

  SimctlListBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _devicetypes = $v.devicetypes.toBuilder();
      _devices = $v.devices.toBuilder();
      _runtimes = $v.runtimes.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SimctlList other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SimctlList;
  }

  @override
  void update(void Function(SimctlListBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SimctlList build() {
    _$SimctlList _$result;
    try {
      _$result = _$v ??
          new _$SimctlList._(
              devicetypes: devicetypes.build(),
              devices: devices.build(),
              runtimes: runtimes.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'devicetypes';
        devicetypes.build();
        _$failedField = 'devices';
        devices.build();
        _$failedField = 'runtimes';
        runtimes.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'SimctlList', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$SimctlDeviceType extends SimctlDeviceType {
  @override
  final String name;

  factory _$SimctlDeviceType(
          [void Function(SimctlDeviceTypeBuilder)? updates]) =>
      (new SimctlDeviceTypeBuilder()..update(updates)).build();

  _$SimctlDeviceType._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'SimctlDeviceType', 'name');
  }

  @override
  SimctlDeviceType rebuild(void Function(SimctlDeviceTypeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SimctlDeviceTypeBuilder toBuilder() =>
      new SimctlDeviceTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SimctlDeviceType && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SimctlDeviceType')..add('name', name))
        .toString();
  }
}

class SimctlDeviceTypeBuilder
    implements Builder<SimctlDeviceType, SimctlDeviceTypeBuilder> {
  _$SimctlDeviceType? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SimctlDeviceTypeBuilder();

  SimctlDeviceTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SimctlDeviceType other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SimctlDeviceType;
  }

  @override
  void update(void Function(SimctlDeviceTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SimctlDeviceType build() {
    final _$result = _$v ??
        new _$SimctlDeviceType._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'SimctlDeviceType', 'name'));
    replace(_$result);
    return _$result;
  }
}

class _$SimctlRuntime extends SimctlRuntime {
  @override
  final String identifier;
  @override
  final String version;

  factory _$SimctlRuntime([void Function(SimctlRuntimeBuilder)? updates]) =>
      (new SimctlRuntimeBuilder()..update(updates)).build();

  _$SimctlRuntime._({required this.identifier, required this.version})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        identifier, 'SimctlRuntime', 'identifier');
    BuiltValueNullFieldError.checkNotNull(version, 'SimctlRuntime', 'version');
  }

  @override
  SimctlRuntime rebuild(void Function(SimctlRuntimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SimctlRuntimeBuilder toBuilder() => new SimctlRuntimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SimctlRuntime &&
        identifier == other.identifier &&
        version == other.version;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, identifier.hashCode), version.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SimctlRuntime')
          ..add('identifier', identifier)
          ..add('version', version))
        .toString();
  }
}

class SimctlRuntimeBuilder
    implements Builder<SimctlRuntime, SimctlRuntimeBuilder> {
  _$SimctlRuntime? _$v;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  SimctlRuntimeBuilder();

  SimctlRuntimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _identifier = $v.identifier;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SimctlRuntime other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SimctlRuntime;
  }

  @override
  void update(void Function(SimctlRuntimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SimctlRuntime build() {
    final _$result = _$v ??
        new _$SimctlRuntime._(
            identifier: BuiltValueNullFieldError.checkNotNull(
                identifier, 'SimctlRuntime', 'identifier'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, 'SimctlRuntime', 'version'));
    replace(_$result);
    return _$result;
  }
}

class _$SimctlDevice extends SimctlDevice {
  @override
  final String udid;
  @override
  final String name;
  @override
  final String dataPath;

  factory _$SimctlDevice([void Function(SimctlDeviceBuilder)? updates]) =>
      (new SimctlDeviceBuilder()..update(updates)).build();

  _$SimctlDevice._(
      {required this.udid, required this.name, required this.dataPath})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(udid, 'SimctlDevice', 'udid');
    BuiltValueNullFieldError.checkNotNull(name, 'SimctlDevice', 'name');
    BuiltValueNullFieldError.checkNotNull(dataPath, 'SimctlDevice', 'dataPath');
  }

  @override
  SimctlDevice rebuild(void Function(SimctlDeviceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SimctlDeviceBuilder toBuilder() => new SimctlDeviceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SimctlDevice &&
        udid == other.udid &&
        name == other.name &&
        dataPath == other.dataPath;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, udid.hashCode), name.hashCode), dataPath.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SimctlDevice')
          ..add('udid', udid)
          ..add('name', name)
          ..add('dataPath', dataPath))
        .toString();
  }
}

class SimctlDeviceBuilder
    implements Builder<SimctlDevice, SimctlDeviceBuilder> {
  _$SimctlDevice? _$v;

  String? _udid;
  String? get udid => _$this._udid;
  set udid(String? udid) => _$this._udid = udid;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _dataPath;
  String? get dataPath => _$this._dataPath;
  set dataPath(String? dataPath) => _$this._dataPath = dataPath;

  SimctlDeviceBuilder();

  SimctlDeviceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _udid = $v.udid;
      _name = $v.name;
      _dataPath = $v.dataPath;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SimctlDevice other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SimctlDevice;
  }

  @override
  void update(void Function(SimctlDeviceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SimctlDevice build() {
    final _$result = _$v ??
        new _$SimctlDevice._(
            udid: BuiltValueNullFieldError.checkNotNull(
                udid, 'SimctlDevice', 'udid'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'SimctlDevice', 'name'),
            dataPath: BuiltValueNullFieldError.checkNotNull(
                dataPath, 'SimctlDevice', 'dataPath'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulators.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Simulators extends Simulators {
  @override
  final Iterable<AndroidRuntime> androidRuntimes;
  @override
  final Iterable<AndroidFormFactor> androidFormFactors;
  @override
  final Iterable<AndroidDevice> androidDevices;
  @override
  final Iterable<IOSRuntime> iosRuntimes;
  @override
  final Iterable<IOSFormFactor> iosFormFactors;
  @override
  final Iterable<IOSDevice> iosDevices;

  factory _$Simulators([void Function(SimulatorsBuilder)? updates]) =>
      (new SimulatorsBuilder()..update(updates)).build();

  _$Simulators._(
      {required this.androidRuntimes,
      required this.androidFormFactors,
      required this.androidDevices,
      required this.iosRuntimes,
      required this.iosFormFactors,
      required this.iosDevices})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        androidRuntimes, 'Simulators', 'androidRuntimes');
    BuiltValueNullFieldError.checkNotNull(
        androidFormFactors, 'Simulators', 'androidFormFactors');
    BuiltValueNullFieldError.checkNotNull(
        androidDevices, 'Simulators', 'androidDevices');
    BuiltValueNullFieldError.checkNotNull(
        iosRuntimes, 'Simulators', 'iosRuntimes');
    BuiltValueNullFieldError.checkNotNull(
        iosFormFactors, 'Simulators', 'iosFormFactors');
    BuiltValueNullFieldError.checkNotNull(
        iosDevices, 'Simulators', 'iosDevices');
  }

  @override
  Simulators rebuild(void Function(SimulatorsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SimulatorsBuilder toBuilder() => new SimulatorsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Simulators &&
        androidRuntimes == other.androidRuntimes &&
        androidFormFactors == other.androidFormFactors &&
        androidDevices == other.androidDevices &&
        iosRuntimes == other.iosRuntimes &&
        iosFormFactors == other.iosFormFactors &&
        iosDevices == other.iosDevices;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc(0, androidRuntimes.hashCode),
                        androidFormFactors.hashCode),
                    androidDevices.hashCode),
                iosRuntimes.hashCode),
            iosFormFactors.hashCode),
        iosDevices.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Simulators')
          ..add('androidRuntimes', androidRuntimes)
          ..add('androidFormFactors', androidFormFactors)
          ..add('androidDevices', androidDevices)
          ..add('iosRuntimes', iosRuntimes)
          ..add('iosFormFactors', iosFormFactors)
          ..add('iosDevices', iosDevices))
        .toString();
  }
}

class SimulatorsBuilder implements Builder<Simulators, SimulatorsBuilder> {
  _$Simulators? _$v;

  Iterable<AndroidRuntime>? _androidRuntimes;
  Iterable<AndroidRuntime>? get androidRuntimes => _$this._androidRuntimes;
  set androidRuntimes(Iterable<AndroidRuntime>? androidRuntimes) =>
      _$this._androidRuntimes = androidRuntimes;

  Iterable<AndroidFormFactor>? _androidFormFactors;
  Iterable<AndroidFormFactor>? get androidFormFactors =>
      _$this._androidFormFactors;
  set androidFormFactors(Iterable<AndroidFormFactor>? androidFormFactors) =>
      _$this._androidFormFactors = androidFormFactors;

  Iterable<AndroidDevice>? _androidDevices;
  Iterable<AndroidDevice>? get androidDevices => _$this._androidDevices;
  set androidDevices(Iterable<AndroidDevice>? androidDevices) =>
      _$this._androidDevices = androidDevices;

  Iterable<IOSRuntime>? _iosRuntimes;
  Iterable<IOSRuntime>? get iosRuntimes => _$this._iosRuntimes;
  set iosRuntimes(Iterable<IOSRuntime>? iosRuntimes) =>
      _$this._iosRuntimes = iosRuntimes;

  Iterable<IOSFormFactor>? _iosFormFactors;
  Iterable<IOSFormFactor>? get iosFormFactors => _$this._iosFormFactors;
  set iosFormFactors(Iterable<IOSFormFactor>? iosFormFactors) =>
      _$this._iosFormFactors = iosFormFactors;

  Iterable<IOSDevice>? _iosDevices;
  Iterable<IOSDevice>? get iosDevices => _$this._iosDevices;
  set iosDevices(Iterable<IOSDevice>? iosDevices) =>
      _$this._iosDevices = iosDevices;

  SimulatorsBuilder();

  SimulatorsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _androidRuntimes = $v.androidRuntimes;
      _androidFormFactors = $v.androidFormFactors;
      _androidDevices = $v.androidDevices;
      _iosRuntimes = $v.iosRuntimes;
      _iosFormFactors = $v.iosFormFactors;
      _iosDevices = $v.iosDevices;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Simulators other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Simulators;
  }

  @override
  void update(void Function(SimulatorsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Simulators build() {
    final _$result = _$v ??
        new _$Simulators._(
            androidRuntimes: BuiltValueNullFieldError.checkNotNull(
                androidRuntimes, 'Simulators', 'androidRuntimes'),
            androidFormFactors: BuiltValueNullFieldError.checkNotNull(
                androidFormFactors, 'Simulators', 'androidFormFactors'),
            androidDevices: BuiltValueNullFieldError.checkNotNull(
                androidDevices, 'Simulators', 'androidDevices'),
            iosRuntimes: BuiltValueNullFieldError.checkNotNull(
                iosRuntimes, 'Simulators', 'iosRuntimes'),
            iosFormFactors: BuiltValueNullFieldError.checkNotNull(
                iosFormFactors, 'Simulators', 'iosFormFactors'),
            iosDevices: BuiltValueNullFieldError.checkNotNull(
                iosDevices, 'Simulators', 'iosDevices'));
    replace(_$result);
    return _$result;
  }
}

class _$AndroidRuntime extends AndroidRuntime {
  @override
  final String runtime;

  factory _$AndroidRuntime([void Function(AndroidRuntimeBuilder)? updates]) =>
      (new AndroidRuntimeBuilder()..update(updates)).build();

  _$AndroidRuntime._({required this.runtime}) : super._() {
    BuiltValueNullFieldError.checkNotNull(runtime, 'AndroidRuntime', 'runtime');
  }

  @override
  AndroidRuntime rebuild(void Function(AndroidRuntimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AndroidRuntimeBuilder toBuilder() =>
      new AndroidRuntimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AndroidRuntime && runtime == other.runtime;
  }

  @override
  int get hashCode {
    return $jf($jc(0, runtime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AndroidRuntime')
          ..add('runtime', runtime))
        .toString();
  }
}

class AndroidRuntimeBuilder
    implements Builder<AndroidRuntime, AndroidRuntimeBuilder> {
  _$AndroidRuntime? _$v;

  String? _runtime;
  String? get runtime => _$this._runtime;
  set runtime(String? runtime) => _$this._runtime = runtime;

  AndroidRuntimeBuilder();

  AndroidRuntimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _runtime = $v.runtime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AndroidRuntime other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AndroidRuntime;
  }

  @override
  void update(void Function(AndroidRuntimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AndroidRuntime build() {
    final _$result = _$v ??
        new _$AndroidRuntime._(
            runtime: BuiltValueNullFieldError.checkNotNull(
                runtime, 'AndroidRuntime', 'runtime'));
    replace(_$result);
    return _$result;
  }
}

class _$AndroidFormFactor extends AndroidFormFactor {
  @override
  final String formFactor;

  factory _$AndroidFormFactor(
          [void Function(AndroidFormFactorBuilder)? updates]) =>
      (new AndroidFormFactorBuilder()..update(updates)).build();

  _$AndroidFormFactor._({required this.formFactor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        formFactor, 'AndroidFormFactor', 'formFactor');
  }

  @override
  AndroidFormFactor rebuild(void Function(AndroidFormFactorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AndroidFormFactorBuilder toBuilder() =>
      new AndroidFormFactorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AndroidFormFactor && formFactor == other.formFactor;
  }

  @override
  int get hashCode {
    return $jf($jc(0, formFactor.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AndroidFormFactor')
          ..add('formFactor', formFactor))
        .toString();
  }
}

class AndroidFormFactorBuilder
    implements Builder<AndroidFormFactor, AndroidFormFactorBuilder> {
  _$AndroidFormFactor? _$v;

  String? _formFactor;
  String? get formFactor => _$this._formFactor;
  set formFactor(String? formFactor) => _$this._formFactor = formFactor;

  AndroidFormFactorBuilder();

  AndroidFormFactorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _formFactor = $v.formFactor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AndroidFormFactor other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AndroidFormFactor;
  }

  @override
  void update(void Function(AndroidFormFactorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AndroidFormFactor build() {
    final _$result = _$v ??
        new _$AndroidFormFactor._(
            formFactor: BuiltValueNullFieldError.checkNotNull(
                formFactor, 'AndroidFormFactor', 'formFactor'));
    replace(_$result);
    return _$result;
  }
}

class _$AndroidDevice extends AndroidDevice {
  @override
  final String name;

  factory _$AndroidDevice([void Function(AndroidDeviceBuilder)? updates]) =>
      (new AndroidDeviceBuilder()..update(updates)).build();

  _$AndroidDevice._({required this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'AndroidDevice', 'name');
  }

  @override
  AndroidDevice rebuild(void Function(AndroidDeviceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AndroidDeviceBuilder toBuilder() => new AndroidDeviceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AndroidDevice && name == other.name;
  }

  @override
  int get hashCode {
    return $jf($jc(0, name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AndroidDevice')..add('name', name))
        .toString();
  }
}

class AndroidDeviceBuilder
    implements Builder<AndroidDevice, AndroidDeviceBuilder> {
  _$AndroidDevice? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AndroidDeviceBuilder();

  AndroidDeviceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AndroidDevice other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AndroidDevice;
  }

  @override
  void update(void Function(AndroidDeviceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AndroidDevice build() {
    final _$result = _$v ??
        new _$AndroidDevice._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'AndroidDevice', 'name'));
    replace(_$result);
    return _$result;
  }
}

class _$IOSRuntime extends IOSRuntime {
  @override
  final String version;
  @override
  final String identifier;

  factory _$IOSRuntime([void Function(IOSRuntimeBuilder)? updates]) =>
      (new IOSRuntimeBuilder()..update(updates)).build();

  _$IOSRuntime._({required this.version, required this.identifier})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(version, 'IOSRuntime', 'version');
    BuiltValueNullFieldError.checkNotNull(
        identifier, 'IOSRuntime', 'identifier');
  }

  @override
  IOSRuntime rebuild(void Function(IOSRuntimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IOSRuntimeBuilder toBuilder() => new IOSRuntimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IOSRuntime &&
        version == other.version &&
        identifier == other.identifier;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, version.hashCode), identifier.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('IOSRuntime')
          ..add('version', version)
          ..add('identifier', identifier))
        .toString();
  }
}

class IOSRuntimeBuilder implements Builder<IOSRuntime, IOSRuntimeBuilder> {
  _$IOSRuntime? _$v;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  IOSRuntimeBuilder();

  IOSRuntimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _identifier = $v.identifier;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IOSRuntime other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$IOSRuntime;
  }

  @override
  void update(void Function(IOSRuntimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$IOSRuntime build() {
    final _$result = _$v ??
        new _$IOSRuntime._(
            version: BuiltValueNullFieldError.checkNotNull(
                version, 'IOSRuntime', 'version'),
            identifier: BuiltValueNullFieldError.checkNotNull(
                identifier, 'IOSRuntime', 'identifier'));
    replace(_$result);
    return _$result;
  }
}

class _$IOSFormFactor extends IOSFormFactor {
  @override
  final String formFactor;

  factory _$IOSFormFactor([void Function(IOSFormFactorBuilder)? updates]) =>
      (new IOSFormFactorBuilder()..update(updates)).build();

  _$IOSFormFactor._({required this.formFactor}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        formFactor, 'IOSFormFactor', 'formFactor');
  }

  @override
  IOSFormFactor rebuild(void Function(IOSFormFactorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IOSFormFactorBuilder toBuilder() => new IOSFormFactorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IOSFormFactor && formFactor == other.formFactor;
  }

  @override
  int get hashCode {
    return $jf($jc(0, formFactor.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('IOSFormFactor')
          ..add('formFactor', formFactor))
        .toString();
  }
}

class IOSFormFactorBuilder
    implements Builder<IOSFormFactor, IOSFormFactorBuilder> {
  _$IOSFormFactor? _$v;

  String? _formFactor;
  String? get formFactor => _$this._formFactor;
  set formFactor(String? formFactor) => _$this._formFactor = formFactor;

  IOSFormFactorBuilder();

  IOSFormFactorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _formFactor = $v.formFactor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IOSFormFactor other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$IOSFormFactor;
  }

  @override
  void update(void Function(IOSFormFactorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$IOSFormFactor build() {
    final _$result = _$v ??
        new _$IOSFormFactor._(
            formFactor: BuiltValueNullFieldError.checkNotNull(
                formFactor, 'IOSFormFactor', 'formFactor'));
    replace(_$result);
    return _$result;
  }
}

class _$IOSDevice extends IOSDevice {
  @override
  final String name;
  @override
  final String dataPath;

  factory _$IOSDevice([void Function(IOSDeviceBuilder)? updates]) =>
      (new IOSDeviceBuilder()..update(updates)).build();

  _$IOSDevice._({required this.name, required this.dataPath}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'IOSDevice', 'name');
    BuiltValueNullFieldError.checkNotNull(dataPath, 'IOSDevice', 'dataPath');
  }

  @override
  IOSDevice rebuild(void Function(IOSDeviceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IOSDeviceBuilder toBuilder() => new IOSDeviceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IOSDevice &&
        name == other.name &&
        dataPath == other.dataPath;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), dataPath.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('IOSDevice')
          ..add('name', name)
          ..add('dataPath', dataPath))
        .toString();
  }
}

class IOSDeviceBuilder implements Builder<IOSDevice, IOSDeviceBuilder> {
  _$IOSDevice? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _dataPath;
  String? get dataPath => _$this._dataPath;
  set dataPath(String? dataPath) => _$this._dataPath = dataPath;

  IOSDeviceBuilder();

  IOSDeviceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _dataPath = $v.dataPath;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IOSDevice other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$IOSDevice;
  }

  @override
  void update(void Function(IOSDeviceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$IOSDevice build() {
    final _$result = _$v ??
        new _$IOSDevice._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'IOSDevice', 'name'),
            dataPath: BuiltValueNullFieldError.checkNotNull(
                dataPath, 'IOSDevice', 'dataPath'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new

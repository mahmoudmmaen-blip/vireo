// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationSettings {
  Map<NotificationType, bool> get enabledMap =>
      throw _privateConstructorUsedError;
  int? get workoutHour => throw _privateConstructorUsedError;
  int? get workoutMinute => throw _privateConstructorUsedError;
  int get waterIntervalHours => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationSettingsCopyWith<NotificationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsCopyWith<$Res> {
  factory $NotificationSettingsCopyWith(NotificationSettings value,
          $Res Function(NotificationSettings) then) =
      _$NotificationSettingsCopyWithImpl<$Res, NotificationSettings>;
  @useResult
  $Res call(
      {Map<NotificationType, bool> enabledMap,
      int? workoutHour,
      int? workoutMinute,
      int waterIntervalHours});
}

/// @nodoc
class _$NotificationSettingsCopyWithImpl<$Res,
        $Val extends NotificationSettings>
    implements $NotificationSettingsCopyWith<$Res> {
  _$NotificationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabledMap = null,
    Object? workoutHour = freezed,
    Object? workoutMinute = freezed,
    Object? waterIntervalHours = null,
  }) {
    return _then(_value.copyWith(
      enabledMap: null == enabledMap
          ? _value.enabledMap
          : enabledMap // ignore: cast_nullable_to_non_nullable
              as Map<NotificationType, bool>,
      workoutHour: freezed == workoutHour
          ? _value.workoutHour
          : workoutHour // ignore: cast_nullable_to_non_nullable
              as int?,
      workoutMinute: freezed == workoutMinute
          ? _value.workoutMinute
          : workoutMinute // ignore: cast_nullable_to_non_nullable
              as int?,
      waterIntervalHours: null == waterIntervalHours
          ? _value.waterIntervalHours
          : waterIntervalHours // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingsImplCopyWith<$Res>
    implements $NotificationSettingsCopyWith<$Res> {
  factory _$$NotificationSettingsImplCopyWith(_$NotificationSettingsImpl value,
          $Res Function(_$NotificationSettingsImpl) then) =
      __$$NotificationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<NotificationType, bool> enabledMap,
      int? workoutHour,
      int? workoutMinute,
      int waterIntervalHours});
}

/// @nodoc
class __$$NotificationSettingsImplCopyWithImpl<$Res>
    extends _$NotificationSettingsCopyWithImpl<$Res, _$NotificationSettingsImpl>
    implements _$$NotificationSettingsImplCopyWith<$Res> {
  __$$NotificationSettingsImplCopyWithImpl(_$NotificationSettingsImpl _value,
      $Res Function(_$NotificationSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabledMap = null,
    Object? workoutHour = freezed,
    Object? workoutMinute = freezed,
    Object? waterIntervalHours = null,
  }) {
    return _then(_$NotificationSettingsImpl(
      enabledMap: null == enabledMap
          ? _value._enabledMap
          : enabledMap // ignore: cast_nullable_to_non_nullable
              as Map<NotificationType, bool>,
      workoutHour: freezed == workoutHour
          ? _value.workoutHour
          : workoutHour // ignore: cast_nullable_to_non_nullable
              as int?,
      workoutMinute: freezed == workoutMinute
          ? _value.workoutMinute
          : workoutMinute // ignore: cast_nullable_to_non_nullable
              as int?,
      waterIntervalHours: null == waterIntervalHours
          ? _value.waterIntervalHours
          : waterIntervalHours // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$NotificationSettingsImpl extends _NotificationSettings {
  const _$NotificationSettingsImpl(
      {final Map<NotificationType, bool> enabledMap = const {},
      this.workoutHour,
      this.workoutMinute,
      this.waterIntervalHours = 2})
      : _enabledMap = enabledMap,
        super._();

  final Map<NotificationType, bool> _enabledMap;
  @override
  @JsonKey()
  Map<NotificationType, bool> get enabledMap {
    if (_enabledMap is EqualUnmodifiableMapView) return _enabledMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_enabledMap);
  }

  @override
  final int? workoutHour;
  @override
  final int? workoutMinute;
  @override
  @JsonKey()
  final int waterIntervalHours;

  @override
  String toString() {
    return 'NotificationSettings(enabledMap: $enabledMap, workoutHour: $workoutHour, workoutMinute: $workoutMinute, waterIntervalHours: $waterIntervalHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsImpl &&
            const DeepCollectionEquality()
                .equals(other._enabledMap, _enabledMap) &&
            (identical(other.workoutHour, workoutHour) ||
                other.workoutHour == workoutHour) &&
            (identical(other.workoutMinute, workoutMinute) ||
                other.workoutMinute == workoutMinute) &&
            (identical(other.waterIntervalHours, waterIntervalHours) ||
                other.waterIntervalHours == waterIntervalHours));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_enabledMap),
      workoutHour,
      workoutMinute,
      waterIntervalHours);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith =>
          __$$NotificationSettingsImplCopyWithImpl<_$NotificationSettingsImpl>(
              this, _$identity);
}

abstract class _NotificationSettings extends NotificationSettings {
  const factory _NotificationSettings(
      {final Map<NotificationType, bool> enabledMap,
      final int? workoutHour,
      final int? workoutMinute,
      final int waterIntervalHours}) = _$NotificationSettingsImpl;
  const _NotificationSettings._() : super._();

  @override
  Map<NotificationType, bool> get enabledMap;
  @override
  int? get workoutHour;
  @override
  int? get workoutMinute;
  @override
  int get waterIntervalHours;
  @override
  @JsonKey(ignore: true)
  _$$NotificationSettingsImplCopyWith<_$NotificationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

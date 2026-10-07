// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MealEntry {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get calories => throw _privateConstructorUsedError;
  double get protein => throw _privateConstructorUsedError;
  double get carbs => throw _privateConstructorUsedError;
  double get fats => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MealEntryCopyWith<MealEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealEntryCopyWith<$Res> {
  factory $MealEntryCopyWith(MealEntry value, $Res Function(MealEntry) then) =
      _$MealEntryCopyWithImpl<$Res, MealEntry>;
  @useResult
  $Res call(
      {String id,
      String name,
      int calories,
      double protein,
      double carbs,
      double fats,
      DateTime time});
}

/// @nodoc
class _$MealEntryCopyWithImpl<$Res, $Val extends MealEntry>
    implements $MealEntryCopyWith<$Res> {
  _$MealEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? calories = null,
    Object? protein = null,
    Object? carbs = null,
    Object? fats = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      fats: null == fats
          ? _value.fats
          : fats // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealEntryImplCopyWith<$Res>
    implements $MealEntryCopyWith<$Res> {
  factory _$$MealEntryImplCopyWith(
          _$MealEntryImpl value, $Res Function(_$MealEntryImpl) then) =
      __$$MealEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int calories,
      double protein,
      double carbs,
      double fats,
      DateTime time});
}

/// @nodoc
class __$$MealEntryImplCopyWithImpl<$Res>
    extends _$MealEntryCopyWithImpl<$Res, _$MealEntryImpl>
    implements _$$MealEntryImplCopyWith<$Res> {
  __$$MealEntryImplCopyWithImpl(
      _$MealEntryImpl _value, $Res Function(_$MealEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? calories = null,
    Object? protein = null,
    Object? carbs = null,
    Object? fats = null,
    Object? time = null,
  }) {
    return _then(_$MealEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      calories: null == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      fats: null == fats
          ? _value.fats
          : fats // ignore: cast_nullable_to_non_nullable
              as double,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$MealEntryImpl implements _MealEntry {
  const _$MealEntryImpl(
      {required this.id,
      required this.name,
      required this.calories,
      required this.protein,
      required this.carbs,
      required this.fats,
      required this.time});

  @override
  final String id;
  @override
  final String name;
  @override
  final int calories;
  @override
  final double protein;
  @override
  final double carbs;
  @override
  final double fats;
  @override
  final DateTime time;

  @override
  String toString() {
    return 'MealEntry(id: $id, name: $name, calories: $calories, protein: $protein, carbs: $carbs, fats: $fats, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fats, fats) || other.fats == fats) &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, calories, protein, carbs, fats, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealEntryImplCopyWith<_$MealEntryImpl> get copyWith =>
      __$$MealEntryImplCopyWithImpl<_$MealEntryImpl>(this, _$identity);
}

abstract class _MealEntry implements MealEntry {
  const factory _MealEntry(
      {required final String id,
      required final String name,
      required final int calories,
      required final double protein,
      required final double carbs,
      required final double fats,
      required final DateTime time}) = _$MealEntryImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  int get calories;
  @override
  double get protein;
  @override
  double get carbs;
  @override
  double get fats;
  @override
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$MealEntryImplCopyWith<_$MealEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WorkoutEntry {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  int get caloriesBurned => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WorkoutEntryCopyWith<WorkoutEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutEntryCopyWith<$Res> {
  factory $WorkoutEntryCopyWith(
          WorkoutEntry value, $Res Function(WorkoutEntry) then) =
      _$WorkoutEntryCopyWithImpl<$Res, WorkoutEntry>;
  @useResult
  $Res call(
      {String id,
      String name,
      int duration,
      int caloriesBurned,
      DateTime time});
}

/// @nodoc
class _$WorkoutEntryCopyWithImpl<$Res, $Val extends WorkoutEntry>
    implements $WorkoutEntryCopyWith<$Res> {
  _$WorkoutEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? duration = null,
    Object? caloriesBurned = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      caloriesBurned: null == caloriesBurned
          ? _value.caloriesBurned
          : caloriesBurned // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutEntryImplCopyWith<$Res>
    implements $WorkoutEntryCopyWith<$Res> {
  factory _$$WorkoutEntryImplCopyWith(
          _$WorkoutEntryImpl value, $Res Function(_$WorkoutEntryImpl) then) =
      __$$WorkoutEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int duration,
      int caloriesBurned,
      DateTime time});
}

/// @nodoc
class __$$WorkoutEntryImplCopyWithImpl<$Res>
    extends _$WorkoutEntryCopyWithImpl<$Res, _$WorkoutEntryImpl>
    implements _$$WorkoutEntryImplCopyWith<$Res> {
  __$$WorkoutEntryImplCopyWithImpl(
      _$WorkoutEntryImpl _value, $Res Function(_$WorkoutEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? duration = null,
    Object? caloriesBurned = null,
    Object? time = null,
  }) {
    return _then(_$WorkoutEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      caloriesBurned: null == caloriesBurned
          ? _value.caloriesBurned
          : caloriesBurned // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$WorkoutEntryImpl implements _WorkoutEntry {
  const _$WorkoutEntryImpl(
      {required this.id,
      required this.name,
      required this.duration,
      required this.caloriesBurned,
      required this.time});

  @override
  final String id;
  @override
  final String name;
  @override
  final int duration;
  @override
  final int caloriesBurned;
  @override
  final DateTime time;

  @override
  String toString() {
    return 'WorkoutEntry(id: $id, name: $name, duration: $duration, caloriesBurned: $caloriesBurned, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.caloriesBurned, caloriesBurned) ||
                other.caloriesBurned == caloriesBurned) &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, duration, caloriesBurned, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutEntryImplCopyWith<_$WorkoutEntryImpl> get copyWith =>
      __$$WorkoutEntryImplCopyWithImpl<_$WorkoutEntryImpl>(this, _$identity);
}

abstract class _WorkoutEntry implements WorkoutEntry {
  const factory _WorkoutEntry(
      {required final String id,
      required final String name,
      required final int duration,
      required final int caloriesBurned,
      required final DateTime time}) = _$WorkoutEntryImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  int get duration;
  @override
  int get caloriesBurned;
  @override
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutEntryImplCopyWith<_$WorkoutEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WaterEntry {
  String get id => throw _privateConstructorUsedError;
  int get amountMl => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WaterEntryCopyWith<WaterEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaterEntryCopyWith<$Res> {
  factory $WaterEntryCopyWith(
          WaterEntry value, $Res Function(WaterEntry) then) =
      _$WaterEntryCopyWithImpl<$Res, WaterEntry>;
  @useResult
  $Res call({String id, int amountMl, DateTime time});
}

/// @nodoc
class _$WaterEntryCopyWithImpl<$Res, $Val extends WaterEntry>
    implements $WaterEntryCopyWith<$Res> {
  _$WaterEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amountMl = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amountMl: null == amountMl
          ? _value.amountMl
          : amountMl // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WaterEntryImplCopyWith<$Res>
    implements $WaterEntryCopyWith<$Res> {
  factory _$$WaterEntryImplCopyWith(
          _$WaterEntryImpl value, $Res Function(_$WaterEntryImpl) then) =
      __$$WaterEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int amountMl, DateTime time});
}

/// @nodoc
class __$$WaterEntryImplCopyWithImpl<$Res>
    extends _$WaterEntryCopyWithImpl<$Res, _$WaterEntryImpl>
    implements _$$WaterEntryImplCopyWith<$Res> {
  __$$WaterEntryImplCopyWithImpl(
      _$WaterEntryImpl _value, $Res Function(_$WaterEntryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amountMl = null,
    Object? time = null,
  }) {
    return _then(_$WaterEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amountMl: null == amountMl
          ? _value.amountMl
          : amountMl // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$WaterEntryImpl implements _WaterEntry {
  const _$WaterEntryImpl(
      {required this.id, required this.amountMl, required this.time});

  @override
  final String id;
  @override
  final int amountMl;
  @override
  final DateTime time;

  @override
  String toString() {
    return 'WaterEntry(id: $id, amountMl: $amountMl, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaterEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amountMl, amountMl) ||
                other.amountMl == amountMl) &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, amountMl, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WaterEntryImplCopyWith<_$WaterEntryImpl> get copyWith =>
      __$$WaterEntryImplCopyWithImpl<_$WaterEntryImpl>(this, _$identity);
}

abstract class _WaterEntry implements WaterEntry {
  const factory _WaterEntry(
      {required final String id,
      required final int amountMl,
      required final DateTime time}) = _$WaterEntryImpl;

  @override
  String get id;
  @override
  int get amountMl;
  @override
  DateTime get time;
  @override
  @JsonKey(ignore: true)
  _$$WaterEntryImplCopyWith<_$WaterEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

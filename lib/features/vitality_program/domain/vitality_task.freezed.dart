// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vitality_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VitalityTask {
  String get id => throw _privateConstructorUsedError;
  String get titleEn => throw _privateConstructorUsedError;
  String get titleAr => throw _privateConstructorUsedError;
  VitalityTaskCategory get category => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  List<DateTime> get completionDates => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VitalityTaskCopyWith<VitalityTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VitalityTaskCopyWith<$Res> {
  factory $VitalityTaskCopyWith(
          VitalityTask value, $Res Function(VitalityTask) then) =
      _$VitalityTaskCopyWithImpl<$Res, VitalityTask>;
  @useResult
  $Res call(
      {String id,
      String titleEn,
      String titleAr,
      VitalityTaskCategory category,
      bool isCompleted,
      List<DateTime> completionDates});
}

/// @nodoc
class _$VitalityTaskCopyWithImpl<$Res, $Val extends VitalityTask>
    implements $VitalityTaskCopyWith<$Res> {
  _$VitalityTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titleEn = null,
    Object? titleAr = null,
    Object? category = null,
    Object? isCompleted = null,
    Object? completionDates = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titleEn: null == titleEn
          ? _value.titleEn
          : titleEn // ignore: cast_nullable_to_non_nullable
              as String,
      titleAr: null == titleAr
          ? _value.titleAr
          : titleAr // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as VitalityTaskCategory,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completionDates: null == completionDates
          ? _value.completionDates
          : completionDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VitalityTaskImplCopyWith<$Res>
    implements $VitalityTaskCopyWith<$Res> {
  factory _$$VitalityTaskImplCopyWith(
          _$VitalityTaskImpl value, $Res Function(_$VitalityTaskImpl) then) =
      __$$VitalityTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String titleEn,
      String titleAr,
      VitalityTaskCategory category,
      bool isCompleted,
      List<DateTime> completionDates});
}

/// @nodoc
class __$$VitalityTaskImplCopyWithImpl<$Res>
    extends _$VitalityTaskCopyWithImpl<$Res, _$VitalityTaskImpl>
    implements _$$VitalityTaskImplCopyWith<$Res> {
  __$$VitalityTaskImplCopyWithImpl(
      _$VitalityTaskImpl _value, $Res Function(_$VitalityTaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? titleEn = null,
    Object? titleAr = null,
    Object? category = null,
    Object? isCompleted = null,
    Object? completionDates = null,
  }) {
    return _then(_$VitalityTaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      titleEn: null == titleEn
          ? _value.titleEn
          : titleEn // ignore: cast_nullable_to_non_nullable
              as String,
      titleAr: null == titleAr
          ? _value.titleAr
          : titleAr // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as VitalityTaskCategory,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completionDates: null == completionDates
          ? _value._completionDates
          : completionDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
    ));
  }
}

/// @nodoc

class _$VitalityTaskImpl implements _VitalityTask {
  const _$VitalityTaskImpl(
      {required this.id,
      required this.titleEn,
      required this.titleAr,
      required this.category,
      this.isCompleted = false,
      final List<DateTime> completionDates = const <DateTime>[]})
      : _completionDates = completionDates;

  @override
  final String id;
  @override
  final String titleEn;
  @override
  final String titleAr;
  @override
  final VitalityTaskCategory category;
  @override
  @JsonKey()
  final bool isCompleted;
  final List<DateTime> _completionDates;
  @override
  @JsonKey()
  List<DateTime> get completionDates {
    if (_completionDates is EqualUnmodifiableListView) return _completionDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completionDates);
  }

  @override
  String toString() {
    return 'VitalityTask(id: $id, titleEn: $titleEn, titleAr: $titleAr, category: $category, isCompleted: $isCompleted, completionDates: $completionDates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VitalityTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.titleEn, titleEn) || other.titleEn == titleEn) &&
            (identical(other.titleAr, titleAr) || other.titleAr == titleAr) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality()
                .equals(other._completionDates, _completionDates));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, titleEn, titleAr, category,
      isCompleted, const DeepCollectionEquality().hash(_completionDates));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VitalityTaskImplCopyWith<_$VitalityTaskImpl> get copyWith =>
      __$$VitalityTaskImplCopyWithImpl<_$VitalityTaskImpl>(this, _$identity);
}

abstract class _VitalityTask implements VitalityTask {
  const factory _VitalityTask(
      {required final String id,
      required final String titleEn,
      required final String titleAr,
      required final VitalityTaskCategory category,
      final bool isCompleted,
      final List<DateTime> completionDates}) = _$VitalityTaskImpl;

  @override
  String get id;
  @override
  String get titleEn;
  @override
  String get titleAr;
  @override
  VitalityTaskCategory get category;
  @override
  bool get isCompleted;
  @override
  List<DateTime> get completionDates;
  @override
  @JsonKey(ignore: true)
  _$$VitalityTaskImplCopyWith<_$VitalityTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

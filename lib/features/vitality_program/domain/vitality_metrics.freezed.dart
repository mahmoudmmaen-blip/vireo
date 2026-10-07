// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vitality_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VitalityMetrics {
  DateTime get date => throw _privateConstructorUsedError;
  int get morningEnergyScore => throw _privateConstructorUsedError;
  int get sleepQuality => throw _privateConstructorUsedError;
  int get workoutPerformance => throw _privateConstructorUsedError;
  int get stressLevel => throw _privateConstructorUsedError;
  double? get bodyFatPercentage => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VitalityMetricsCopyWith<VitalityMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VitalityMetricsCopyWith<$Res> {
  factory $VitalityMetricsCopyWith(
          VitalityMetrics value, $Res Function(VitalityMetrics) then) =
      _$VitalityMetricsCopyWithImpl<$Res, VitalityMetrics>;
  @useResult
  $Res call(
      {DateTime date,
      int morningEnergyScore,
      int sleepQuality,
      int workoutPerformance,
      int stressLevel,
      double? bodyFatPercentage,
      double? weight});
}

/// @nodoc
class _$VitalityMetricsCopyWithImpl<$Res, $Val extends VitalityMetrics>
    implements $VitalityMetricsCopyWith<$Res> {
  _$VitalityMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? morningEnergyScore = null,
    Object? sleepQuality = null,
    Object? workoutPerformance = null,
    Object? stressLevel = null,
    Object? bodyFatPercentage = freezed,
    Object? weight = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      morningEnergyScore: null == morningEnergyScore
          ? _value.morningEnergyScore
          : morningEnergyScore // ignore: cast_nullable_to_non_nullable
              as int,
      sleepQuality: null == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as int,
      workoutPerformance: null == workoutPerformance
          ? _value.workoutPerformance
          : workoutPerformance // ignore: cast_nullable_to_non_nullable
              as int,
      stressLevel: null == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as int,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VitalityMetricsImplCopyWith<$Res>
    implements $VitalityMetricsCopyWith<$Res> {
  factory _$$VitalityMetricsImplCopyWith(_$VitalityMetricsImpl value,
          $Res Function(_$VitalityMetricsImpl) then) =
      __$$VitalityMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      int morningEnergyScore,
      int sleepQuality,
      int workoutPerformance,
      int stressLevel,
      double? bodyFatPercentage,
      double? weight});
}

/// @nodoc
class __$$VitalityMetricsImplCopyWithImpl<$Res>
    extends _$VitalityMetricsCopyWithImpl<$Res, _$VitalityMetricsImpl>
    implements _$$VitalityMetricsImplCopyWith<$Res> {
  __$$VitalityMetricsImplCopyWithImpl(
      _$VitalityMetricsImpl _value, $Res Function(_$VitalityMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? morningEnergyScore = null,
    Object? sleepQuality = null,
    Object? workoutPerformance = null,
    Object? stressLevel = null,
    Object? bodyFatPercentage = freezed,
    Object? weight = freezed,
  }) {
    return _then(_$VitalityMetricsImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      morningEnergyScore: null == morningEnergyScore
          ? _value.morningEnergyScore
          : morningEnergyScore // ignore: cast_nullable_to_non_nullable
              as int,
      sleepQuality: null == sleepQuality
          ? _value.sleepQuality
          : sleepQuality // ignore: cast_nullable_to_non_nullable
              as int,
      workoutPerformance: null == workoutPerformance
          ? _value.workoutPerformance
          : workoutPerformance // ignore: cast_nullable_to_non_nullable
              as int,
      stressLevel: null == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as int,
      bodyFatPercentage: freezed == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$VitalityMetricsImpl implements _VitalityMetrics {
  const _$VitalityMetricsImpl(
      {required this.date,
      required this.morningEnergyScore,
      required this.sleepQuality,
      required this.workoutPerformance,
      required this.stressLevel,
      this.bodyFatPercentage,
      this.weight});

  @override
  final DateTime date;
  @override
  final int morningEnergyScore;
  @override
  final int sleepQuality;
  @override
  final int workoutPerformance;
  @override
  final int stressLevel;
  @override
  final double? bodyFatPercentage;
  @override
  final double? weight;

  @override
  String toString() {
    return 'VitalityMetrics(date: $date, morningEnergyScore: $morningEnergyScore, sleepQuality: $sleepQuality, workoutPerformance: $workoutPerformance, stressLevel: $stressLevel, bodyFatPercentage: $bodyFatPercentage, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VitalityMetricsImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.morningEnergyScore, morningEnergyScore) ||
                other.morningEnergyScore == morningEnergyScore) &&
            (identical(other.sleepQuality, sleepQuality) ||
                other.sleepQuality == sleepQuality) &&
            (identical(other.workoutPerformance, workoutPerformance) ||
                other.workoutPerformance == workoutPerformance) &&
            (identical(other.stressLevel, stressLevel) ||
                other.stressLevel == stressLevel) &&
            (identical(other.bodyFatPercentage, bodyFatPercentage) ||
                other.bodyFatPercentage == bodyFatPercentage) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, morningEnergyScore,
      sleepQuality, workoutPerformance, stressLevel, bodyFatPercentage, weight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VitalityMetricsImplCopyWith<_$VitalityMetricsImpl> get copyWith =>
      __$$VitalityMetricsImplCopyWithImpl<_$VitalityMetricsImpl>(
          this, _$identity);
}

abstract class _VitalityMetrics implements VitalityMetrics {
  const factory _VitalityMetrics(
      {required final DateTime date,
      required final int morningEnergyScore,
      required final int sleepQuality,
      required final int workoutPerformance,
      required final int stressLevel,
      final double? bodyFatPercentage,
      final double? weight}) = _$VitalityMetricsImpl;

  @override
  DateTime get date;
  @override
  int get morningEnergyScore;
  @override
  int get sleepQuality;
  @override
  int get workoutPerformance;
  @override
  int get stressLevel;
  @override
  double? get bodyFatPercentage;
  @override
  double? get weight;
  @override
  @JsonKey(ignore: true)
  _$$VitalityMetricsImplCopyWith<_$VitalityMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VitalityWeeklyReport {
  int get weekNumber => throw _privateConstructorUsedError;
  double get completionPercentage => throw _privateConstructorUsedError;
  double get averageMorningEnergy => throw _privateConstructorUsedError;
  double get averageSleepQuality => throw _privateConstructorUsedError;
  double get averageWorkoutPerformance => throw _privateConstructorUsedError;
  VitalityTrendDirection get energyTrend => throw _privateConstructorUsedError;
  VitalityTrendDirection get sleepTrend => throw _privateConstructorUsedError;
  VitalityTrendDirection get workoutTrend => throw _privateConstructorUsedError;
  bool get isImproving => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VitalityWeeklyReportCopyWith<VitalityWeeklyReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VitalityWeeklyReportCopyWith<$Res> {
  factory $VitalityWeeklyReportCopyWith(VitalityWeeklyReport value,
          $Res Function(VitalityWeeklyReport) then) =
      _$VitalityWeeklyReportCopyWithImpl<$Res, VitalityWeeklyReport>;
  @useResult
  $Res call(
      {int weekNumber,
      double completionPercentage,
      double averageMorningEnergy,
      double averageSleepQuality,
      double averageWorkoutPerformance,
      VitalityTrendDirection energyTrend,
      VitalityTrendDirection sleepTrend,
      VitalityTrendDirection workoutTrend,
      bool isImproving});
}

/// @nodoc
class _$VitalityWeeklyReportCopyWithImpl<$Res,
        $Val extends VitalityWeeklyReport>
    implements $VitalityWeeklyReportCopyWith<$Res> {
  _$VitalityWeeklyReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekNumber = null,
    Object? completionPercentage = null,
    Object? averageMorningEnergy = null,
    Object? averageSleepQuality = null,
    Object? averageWorkoutPerformance = null,
    Object? energyTrend = null,
    Object? sleepTrend = null,
    Object? workoutTrend = null,
    Object? isImproving = null,
  }) {
    return _then(_value.copyWith(
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      averageMorningEnergy: null == averageMorningEnergy
          ? _value.averageMorningEnergy
          : averageMorningEnergy // ignore: cast_nullable_to_non_nullable
              as double,
      averageSleepQuality: null == averageSleepQuality
          ? _value.averageSleepQuality
          : averageSleepQuality // ignore: cast_nullable_to_non_nullable
              as double,
      averageWorkoutPerformance: null == averageWorkoutPerformance
          ? _value.averageWorkoutPerformance
          : averageWorkoutPerformance // ignore: cast_nullable_to_non_nullable
              as double,
      energyTrend: null == energyTrend
          ? _value.energyTrend
          : energyTrend // ignore: cast_nullable_to_non_nullable
              as VitalityTrendDirection,
      sleepTrend: null == sleepTrend
          ? _value.sleepTrend
          : sleepTrend // ignore: cast_nullable_to_non_nullable
              as VitalityTrendDirection,
      workoutTrend: null == workoutTrend
          ? _value.workoutTrend
          : workoutTrend // ignore: cast_nullable_to_non_nullable
              as VitalityTrendDirection,
      isImproving: null == isImproving
          ? _value.isImproving
          : isImproving // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VitalityWeeklyReportImplCopyWith<$Res>
    implements $VitalityWeeklyReportCopyWith<$Res> {
  factory _$$VitalityWeeklyReportImplCopyWith(_$VitalityWeeklyReportImpl value,
          $Res Function(_$VitalityWeeklyReportImpl) then) =
      __$$VitalityWeeklyReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int weekNumber,
      double completionPercentage,
      double averageMorningEnergy,
      double averageSleepQuality,
      double averageWorkoutPerformance,
      VitalityTrendDirection energyTrend,
      VitalityTrendDirection sleepTrend,
      VitalityTrendDirection workoutTrend,
      bool isImproving});
}

/// @nodoc
class __$$VitalityWeeklyReportImplCopyWithImpl<$Res>
    extends _$VitalityWeeklyReportCopyWithImpl<$Res, _$VitalityWeeklyReportImpl>
    implements _$$VitalityWeeklyReportImplCopyWith<$Res> {
  __$$VitalityWeeklyReportImplCopyWithImpl(_$VitalityWeeklyReportImpl _value,
      $Res Function(_$VitalityWeeklyReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekNumber = null,
    Object? completionPercentage = null,
    Object? averageMorningEnergy = null,
    Object? averageSleepQuality = null,
    Object? averageWorkoutPerformance = null,
    Object? energyTrend = null,
    Object? sleepTrend = null,
    Object? workoutTrend = null,
    Object? isImproving = null,
  }) {
    return _then(_$VitalityWeeklyReportImpl(
      weekNumber: null == weekNumber
          ? _value.weekNumber
          : weekNumber // ignore: cast_nullable_to_non_nullable
              as int,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      averageMorningEnergy: null == averageMorningEnergy
          ? _value.averageMorningEnergy
          : averageMorningEnergy // ignore: cast_nullable_to_non_nullable
              as double,
      averageSleepQuality: null == averageSleepQuality
          ? _value.averageSleepQuality
          : averageSleepQuality // ignore: cast_nullable_to_non_nullable
              as double,
      averageWorkoutPerformance: null == averageWorkoutPerformance
          ? _value.averageWorkoutPerformance
          : averageWorkoutPerformance // ignore: cast_nullable_to_non_nullable
              as double,
      energyTrend: null == energyTrend
          ? _value.energyTrend
          : energyTrend // ignore: cast_nullable_to_non_nullable
              as VitalityTrendDirection,
      sleepTrend: null == sleepTrend
          ? _value.sleepTrend
          : sleepTrend // ignore: cast_nullable_to_non_nullable
              as VitalityTrendDirection,
      workoutTrend: null == workoutTrend
          ? _value.workoutTrend
          : workoutTrend // ignore: cast_nullable_to_non_nullable
              as VitalityTrendDirection,
      isImproving: null == isImproving
          ? _value.isImproving
          : isImproving // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$VitalityWeeklyReportImpl implements _VitalityWeeklyReport {
  const _$VitalityWeeklyReportImpl(
      {required this.weekNumber,
      required this.completionPercentage,
      required this.averageMorningEnergy,
      required this.averageSleepQuality,
      required this.averageWorkoutPerformance,
      required this.energyTrend,
      required this.sleepTrend,
      required this.workoutTrend,
      required this.isImproving});

  @override
  final int weekNumber;
  @override
  final double completionPercentage;
  @override
  final double averageMorningEnergy;
  @override
  final double averageSleepQuality;
  @override
  final double averageWorkoutPerformance;
  @override
  final VitalityTrendDirection energyTrend;
  @override
  final VitalityTrendDirection sleepTrend;
  @override
  final VitalityTrendDirection workoutTrend;
  @override
  final bool isImproving;

  @override
  String toString() {
    return 'VitalityWeeklyReport(weekNumber: $weekNumber, completionPercentage: $completionPercentage, averageMorningEnergy: $averageMorningEnergy, averageSleepQuality: $averageSleepQuality, averageWorkoutPerformance: $averageWorkoutPerformance, energyTrend: $energyTrend, sleepTrend: $sleepTrend, workoutTrend: $workoutTrend, isImproving: $isImproving)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VitalityWeeklyReportImpl &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.averageMorningEnergy, averageMorningEnergy) ||
                other.averageMorningEnergy == averageMorningEnergy) &&
            (identical(other.averageSleepQuality, averageSleepQuality) ||
                other.averageSleepQuality == averageSleepQuality) &&
            (identical(other.averageWorkoutPerformance,
                    averageWorkoutPerformance) ||
                other.averageWorkoutPerformance == averageWorkoutPerformance) &&
            (identical(other.energyTrend, energyTrend) ||
                other.energyTrend == energyTrend) &&
            (identical(other.sleepTrend, sleepTrend) ||
                other.sleepTrend == sleepTrend) &&
            (identical(other.workoutTrend, workoutTrend) ||
                other.workoutTrend == workoutTrend) &&
            (identical(other.isImproving, isImproving) ||
                other.isImproving == isImproving));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      weekNumber,
      completionPercentage,
      averageMorningEnergy,
      averageSleepQuality,
      averageWorkoutPerformance,
      energyTrend,
      sleepTrend,
      workoutTrend,
      isImproving);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VitalityWeeklyReportImplCopyWith<_$VitalityWeeklyReportImpl>
      get copyWith =>
          __$$VitalityWeeklyReportImplCopyWithImpl<_$VitalityWeeklyReportImpl>(
              this, _$identity);
}

abstract class _VitalityWeeklyReport implements VitalityWeeklyReport {
  const factory _VitalityWeeklyReport(
      {required final int weekNumber,
      required final double completionPercentage,
      required final double averageMorningEnergy,
      required final double averageSleepQuality,
      required final double averageWorkoutPerformance,
      required final VitalityTrendDirection energyTrend,
      required final VitalityTrendDirection sleepTrend,
      required final VitalityTrendDirection workoutTrend,
      required final bool isImproving}) = _$VitalityWeeklyReportImpl;

  @override
  int get weekNumber;
  @override
  double get completionPercentage;
  @override
  double get averageMorningEnergy;
  @override
  double get averageSleepQuality;
  @override
  double get averageWorkoutPerformance;
  @override
  VitalityTrendDirection get energyTrend;
  @override
  VitalityTrendDirection get sleepTrend;
  @override
  VitalityTrendDirection get workoutTrend;
  @override
  bool get isImproving;
  @override
  @JsonKey(ignore: true)
  _$$VitalityWeeklyReportImplCopyWith<_$VitalityWeeklyReportImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$VitalityProgramProgress {
  int get currentWeek => throw _privateConstructorUsedError;
  bool get hasStarted => throw _privateConstructorUsedError;
  bool get isProgramComplete => throw _privateConstructorUsedError;
  Set<int> get unlockedWeeks => throw _privateConstructorUsedError;
  Set<String> get completedTaskIdsToday => throw _privateConstructorUsedError;
  Map<String, List<String>> get taskCompletionDates =>
      throw _privateConstructorUsedError;
  Set<String> get earnedBadges => throw _privateConstructorUsedError;
  Map<String, int> get categoryStreaks => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VitalityProgramProgressCopyWith<VitalityProgramProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VitalityProgramProgressCopyWith<$Res> {
  factory $VitalityProgramProgressCopyWith(VitalityProgramProgress value,
          $Res Function(VitalityProgramProgress) then) =
      _$VitalityProgramProgressCopyWithImpl<$Res, VitalityProgramProgress>;
  @useResult
  $Res call(
      {int currentWeek,
      bool hasStarted,
      bool isProgramComplete,
      Set<int> unlockedWeeks,
      Set<String> completedTaskIdsToday,
      Map<String, List<String>> taskCompletionDates,
      Set<String> earnedBadges,
      Map<String, int> categoryStreaks,
      DateTime? startedAt});
}

/// @nodoc
class _$VitalityProgramProgressCopyWithImpl<$Res,
        $Val extends VitalityProgramProgress>
    implements $VitalityProgramProgressCopyWith<$Res> {
  _$VitalityProgramProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWeek = null,
    Object? hasStarted = null,
    Object? isProgramComplete = null,
    Object? unlockedWeeks = null,
    Object? completedTaskIdsToday = null,
    Object? taskCompletionDates = null,
    Object? earnedBadges = null,
    Object? categoryStreaks = null,
    Object? startedAt = freezed,
  }) {
    return _then(_value.copyWith(
      currentWeek: null == currentWeek
          ? _value.currentWeek
          : currentWeek // ignore: cast_nullable_to_non_nullable
              as int,
      hasStarted: null == hasStarted
          ? _value.hasStarted
          : hasStarted // ignore: cast_nullable_to_non_nullable
              as bool,
      isProgramComplete: null == isProgramComplete
          ? _value.isProgramComplete
          : isProgramComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedWeeks: null == unlockedWeeks
          ? _value.unlockedWeeks
          : unlockedWeeks // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      completedTaskIdsToday: null == completedTaskIdsToday
          ? _value.completedTaskIdsToday
          : completedTaskIdsToday // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      taskCompletionDates: null == taskCompletionDates
          ? _value.taskCompletionDates
          : taskCompletionDates // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      earnedBadges: null == earnedBadges
          ? _value.earnedBadges
          : earnedBadges // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      categoryStreaks: null == categoryStreaks
          ? _value.categoryStreaks
          : categoryStreaks // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VitalityProgramProgressImplCopyWith<$Res>
    implements $VitalityProgramProgressCopyWith<$Res> {
  factory _$$VitalityProgramProgressImplCopyWith(
          _$VitalityProgramProgressImpl value,
          $Res Function(_$VitalityProgramProgressImpl) then) =
      __$$VitalityProgramProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentWeek,
      bool hasStarted,
      bool isProgramComplete,
      Set<int> unlockedWeeks,
      Set<String> completedTaskIdsToday,
      Map<String, List<String>> taskCompletionDates,
      Set<String> earnedBadges,
      Map<String, int> categoryStreaks,
      DateTime? startedAt});
}

/// @nodoc
class __$$VitalityProgramProgressImplCopyWithImpl<$Res>
    extends _$VitalityProgramProgressCopyWithImpl<$Res,
        _$VitalityProgramProgressImpl>
    implements _$$VitalityProgramProgressImplCopyWith<$Res> {
  __$$VitalityProgramProgressImplCopyWithImpl(
      _$VitalityProgramProgressImpl _value,
      $Res Function(_$VitalityProgramProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWeek = null,
    Object? hasStarted = null,
    Object? isProgramComplete = null,
    Object? unlockedWeeks = null,
    Object? completedTaskIdsToday = null,
    Object? taskCompletionDates = null,
    Object? earnedBadges = null,
    Object? categoryStreaks = null,
    Object? startedAt = freezed,
  }) {
    return _then(_$VitalityProgramProgressImpl(
      currentWeek: null == currentWeek
          ? _value.currentWeek
          : currentWeek // ignore: cast_nullable_to_non_nullable
              as int,
      hasStarted: null == hasStarted
          ? _value.hasStarted
          : hasStarted // ignore: cast_nullable_to_non_nullable
              as bool,
      isProgramComplete: null == isProgramComplete
          ? _value.isProgramComplete
          : isProgramComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockedWeeks: null == unlockedWeeks
          ? _value._unlockedWeeks
          : unlockedWeeks // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      completedTaskIdsToday: null == completedTaskIdsToday
          ? _value._completedTaskIdsToday
          : completedTaskIdsToday // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      taskCompletionDates: null == taskCompletionDates
          ? _value._taskCompletionDates
          : taskCompletionDates // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
      earnedBadges: null == earnedBadges
          ? _value._earnedBadges
          : earnedBadges // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      categoryStreaks: null == categoryStreaks
          ? _value._categoryStreaks
          : categoryStreaks // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$VitalityProgramProgressImpl implements _VitalityProgramProgress {
  const _$VitalityProgramProgressImpl(
      {this.currentWeek = 1,
      this.hasStarted = false,
      this.isProgramComplete = false,
      final Set<int> unlockedWeeks = const <int>{1},
      final Set<String> completedTaskIdsToday = const <String>{},
      final Map<String, List<String>> taskCompletionDates =
          const <String, List<String>>{},
      final Set<String> earnedBadges = const <String>{},
      final Map<String, int> categoryStreaks = const <String, int>{},
      this.startedAt})
      : _unlockedWeeks = unlockedWeeks,
        _completedTaskIdsToday = completedTaskIdsToday,
        _taskCompletionDates = taskCompletionDates,
        _earnedBadges = earnedBadges,
        _categoryStreaks = categoryStreaks;

  @override
  @JsonKey()
  final int currentWeek;
  @override
  @JsonKey()
  final bool hasStarted;
  @override
  @JsonKey()
  final bool isProgramComplete;
  final Set<int> _unlockedWeeks;
  @override
  @JsonKey()
  Set<int> get unlockedWeeks {
    if (_unlockedWeeks is EqualUnmodifiableSetView) return _unlockedWeeks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_unlockedWeeks);
  }

  final Set<String> _completedTaskIdsToday;
  @override
  @JsonKey()
  Set<String> get completedTaskIdsToday {
    if (_completedTaskIdsToday is EqualUnmodifiableSetView)
      return _completedTaskIdsToday;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_completedTaskIdsToday);
  }

  final Map<String, List<String>> _taskCompletionDates;
  @override
  @JsonKey()
  Map<String, List<String>> get taskCompletionDates {
    if (_taskCompletionDates is EqualUnmodifiableMapView)
      return _taskCompletionDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_taskCompletionDates);
  }

  final Set<String> _earnedBadges;
  @override
  @JsonKey()
  Set<String> get earnedBadges {
    if (_earnedBadges is EqualUnmodifiableSetView) return _earnedBadges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_earnedBadges);
  }

  final Map<String, int> _categoryStreaks;
  @override
  @JsonKey()
  Map<String, int> get categoryStreaks {
    if (_categoryStreaks is EqualUnmodifiableMapView) return _categoryStreaks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryStreaks);
  }

  @override
  final DateTime? startedAt;

  @override
  String toString() {
    return 'VitalityProgramProgress(currentWeek: $currentWeek, hasStarted: $hasStarted, isProgramComplete: $isProgramComplete, unlockedWeeks: $unlockedWeeks, completedTaskIdsToday: $completedTaskIdsToday, taskCompletionDates: $taskCompletionDates, earnedBadges: $earnedBadges, categoryStreaks: $categoryStreaks, startedAt: $startedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VitalityProgramProgressImpl &&
            (identical(other.currentWeek, currentWeek) ||
                other.currentWeek == currentWeek) &&
            (identical(other.hasStarted, hasStarted) ||
                other.hasStarted == hasStarted) &&
            (identical(other.isProgramComplete, isProgramComplete) ||
                other.isProgramComplete == isProgramComplete) &&
            const DeepCollectionEquality()
                .equals(other._unlockedWeeks, _unlockedWeeks) &&
            const DeepCollectionEquality()
                .equals(other._completedTaskIdsToday, _completedTaskIdsToday) &&
            const DeepCollectionEquality()
                .equals(other._taskCompletionDates, _taskCompletionDates) &&
            const DeepCollectionEquality()
                .equals(other._earnedBadges, _earnedBadges) &&
            const DeepCollectionEquality()
                .equals(other._categoryStreaks, _categoryStreaks) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentWeek,
      hasStarted,
      isProgramComplete,
      const DeepCollectionEquality().hash(_unlockedWeeks),
      const DeepCollectionEquality().hash(_completedTaskIdsToday),
      const DeepCollectionEquality().hash(_taskCompletionDates),
      const DeepCollectionEquality().hash(_earnedBadges),
      const DeepCollectionEquality().hash(_categoryStreaks),
      startedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VitalityProgramProgressImplCopyWith<_$VitalityProgramProgressImpl>
      get copyWith => __$$VitalityProgramProgressImplCopyWithImpl<
          _$VitalityProgramProgressImpl>(this, _$identity);
}

abstract class _VitalityProgramProgress implements VitalityProgramProgress {
  const factory _VitalityProgramProgress(
      {final int currentWeek,
      final bool hasStarted,
      final bool isProgramComplete,
      final Set<int> unlockedWeeks,
      final Set<String> completedTaskIdsToday,
      final Map<String, List<String>> taskCompletionDates,
      final Set<String> earnedBadges,
      final Map<String, int> categoryStreaks,
      final DateTime? startedAt}) = _$VitalityProgramProgressImpl;

  @override
  int get currentWeek;
  @override
  bool get hasStarted;
  @override
  bool get isProgramComplete;
  @override
  Set<int> get unlockedWeeks;
  @override
  Set<String> get completedTaskIdsToday;
  @override
  Map<String, List<String>> get taskCompletionDates;
  @override
  Set<String> get earnedBadges;
  @override
  Map<String, int> get categoryStreaks;
  @override
  DateTime? get startedAt;
  @override
  @JsonKey(ignore: true)
  _$$VitalityProgramProgressImplCopyWith<_$VitalityProgramProgressImpl>
      get copyWith => throw _privateConstructorUsedError;
}

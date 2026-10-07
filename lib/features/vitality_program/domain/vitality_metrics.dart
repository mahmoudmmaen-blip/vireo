import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vireo/features/vitality_program/domain/vitality_program_phase.dart';

part 'vitality_metrics.freezed.dart';

@freezed
class VitalityMetrics with _$VitalityMetrics {
  const factory VitalityMetrics({
    required DateTime date,
    required int morningEnergyScore,
    required int sleepQuality,
    required int workoutPerformance,
    required int stressLevel,
    double? bodyFatPercentage,
    double? weight,
  }) = _VitalityMetrics;
}

@freezed
class VitalityWeeklyReport with _$VitalityWeeklyReport {
  const factory VitalityWeeklyReport({
    required int weekNumber,
    required double completionPercentage,
    required double averageMorningEnergy,
    required double averageSleepQuality,
    required double averageWorkoutPerformance,
    required VitalityTrendDirection energyTrend,
    required VitalityTrendDirection sleepTrend,
    required VitalityTrendDirection workoutTrend,
    required bool isImproving,
  }) = _VitalityWeeklyReport;
}

@freezed
class VitalityProgramProgress with _$VitalityProgramProgress {
  const factory VitalityProgramProgress({
    @Default(1) int currentWeek,
    @Default(false) bool hasStarted,
    @Default(false) bool isProgramComplete,
    @Default(<int>{1}) Set<int> unlockedWeeks,
    @Default(<String>{}) Set<String> completedTaskIdsToday,
    @Default(<String, List<String>>{}) Map<String, List<String>> taskCompletionDates,
    @Default(<String>{}) Set<String> earnedBadges,
    @Default(<String, int>{}) Map<String, int> categoryStreaks,
    DateTime? startedAt,
  }) = _VitalityProgramProgress;
}

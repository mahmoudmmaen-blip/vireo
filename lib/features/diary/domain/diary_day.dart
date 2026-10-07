import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vireo/features/diary/domain/diary_entry.dart';

part 'diary_day.freezed.dart';

@freezed
class DiaryDay with _$DiaryDay {
  const factory DiaryDay({
    required DateTime date,
    @Default([]) List<MealEntry> meals,
    @Default([]) List<WorkoutEntry> workouts,
    @Default([]) List<WaterEntry> waterLogs,
    @Default(0) int waterIntake,
    @Default(0) int totalCaloriesIn,
    @Default(0) int totalCaloriesOut,
    @Default(0) int netBalance,
    @Default(0) int tdee,
    @Default(0) int proteinTotal,
    @Default(0) int proteinTarget,
    @Default(false) bool isGoalMet,
    @Default(true) bool hasTdee,
    DateTime? lastUpdated,
    @Default(false) bool fromCache,
  }) = _DiaryDay;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_entry.freezed.dart';

@freezed
class MealEntry with _$MealEntry {
  const factory MealEntry({
    required String id,
    required String name,
    required int calories,
    required double protein,
    required double carbs,
    required double fats,
    required DateTime time,
  }) = _MealEntry;
}

@freezed
class WorkoutEntry with _$WorkoutEntry {
  const factory WorkoutEntry({
    required String id,
    required String name,
    required int duration,
    required int caloriesBurned,
    required DateTime time,
  }) = _WorkoutEntry;
}

@freezed
class WaterEntry with _$WaterEntry {
  const factory WaterEntry({
    required String id,
    required int amountMl,
    required DateTime time,
  }) = _WaterEntry;
}

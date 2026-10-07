import 'package:vireo/features/diary/domain/diary_day.dart';
import 'package:vireo/features/diary/domain/diary_entry.dart';

abstract interface class IDiaryRepository {
  Future<DiaryDay> getDay(DateTime date);

  Future<List<DiaryDay>> getWeek(DateTime startDate);

  Future<void> saveMealEntry(DateTime date, MealEntry meal);

  Future<void> saveWorkoutEntry(DateTime date, WorkoutEntry workout);
}

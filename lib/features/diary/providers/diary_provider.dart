import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/cardio/providers/cardio_log_provider.dart';
import 'package:vireo/features/diary/data/diary_repository_impl.dart';
import 'package:vireo/features/diary/domain/diary_day.dart';
import 'package:vireo/features/diary/domain/i_diary_repository.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';

final diarySelectedDateProvider = StateProvider<DateTime>(
  (ref) => diaryDateOnly(DateTime.now()),
);

final diaryRepositoryProvider = Provider<IDiaryRepository>((ref) {
  return DiaryRepositoryImpl(
    readAiLogs: () => ref.read(aiMealLogProvider),
    readCardioLogs: () => ref.read(cardioLogProvider),
    readWaterMl: () => ref.read(waterTrackerProvider),
    readCalorieTarget: () => ref.read(calorieGoalProvider),
    readConfirmedMeals: () => ref.read(confirmedMealsProvider),
    readTodayMeals: () => ref.read(effectiveTodayMealsProvider).valueOrNull ?? [],
    readVitalityLog: () => ref.read(vitalityDailyLogProvider),
    readWorkoutSession: () async {
      try {
        return await ref.read(todayWorkoutProvider.future);
      } catch (_) {
        return null;
      }
    },
    readFitnessGoal: diaryFitnessGoalFromProfile,
    readWeightKg: diaryWeightKgFromProfile,
    saveAiMeal: (result, loggedAt) =>
        ref.read(aiMealLogProvider.notifier).save(result, loggedAt: loggedAt),
    saveCardioWorkout: ({
      required activity,
      required durationMinutes,
      required weightKg,
      loggedAt,
      caloriesOverride,
    }) =>
        ref.read(cardioLogProvider.notifier).logActivity(
              activity: activity,
              durationMinutes: durationMinutes,
              weightKg: weightKg,
              loggedAt: loggedAt,
              caloriesOverride: caloriesOverride,
            ),
  );
});

class DiaryNotifier extends AsyncNotifier<DiaryDay> {
  @override
  Future<DiaryDay> build() async {
    _watchDiarySources(ref);

    final date = ref.watch(diarySelectedDateProvider);
    return ref.read(diaryRepositoryProvider).getDay(date);
  }

  Future<void> selectDate(DateTime date) async {
    ref.read(diarySelectedDateProvider.notifier).state = diaryDateOnly(date);
    ref.invalidateSelf();
    await future;
  }
}

final diaryProvider =
    AsyncNotifierProvider<DiaryNotifier, DiaryDay>(DiaryNotifier.new);

final weeklyDiaryProvider = FutureProvider<List<DiaryDay>>((ref) async {
  _watchDiarySources(ref);
  final today = diaryDateOnly(DateTime.now());
  final start = today.subtract(const Duration(days: 6));
  return ref.read(diaryRepositoryProvider).getWeek(start);
});

/// Sun–Sat calendar week for the currently selected diary date.
final calendarWeekDiaryProvider = FutureProvider<List<DiaryDay>>((ref) async {
  _watchDiarySources(ref);
  final selected = ref.watch(diarySelectedDateProvider);
  final sunday = diaryWeekDaysFor(selected).first;
  return ref.read(diaryRepositoryProvider).getWeek(sunday);
});

void _watchDiarySources(Ref ref) {
  ref.watch(aiMealLogProvider);
  ref.watch(cardioLogProvider);
  ref.watch(waterTrackerProvider);
  ref.watch(confirmedMealsProvider);
  ref.watch(effectiveTodayMealsProvider);
  ref.watch(calorieGoalProvider);
  ref.watch(vitalityDailyLogProvider);
}

/// Sunday-start week containing [anchor].
List<DateTime> diaryWeekDaysFor(DateTime anchor) {
  final day = diaryDateOnly(anchor);
  final sunday = day.subtract(Duration(days: day.weekday % 7));
  return List.generate(7, (i) => sunday.add(Duration(days: i)));
}

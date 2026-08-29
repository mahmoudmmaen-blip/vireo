import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/utils/cardio_calorie_calculator.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/cardio/providers/cardio_log_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/progress/models/daily_deficit_entry.dart';

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

int _aiMealCaloriesForDay(List<AiMealLogEntry> logs, DateTime day) {
  return logs
      .where((e) => _isSameDay(e.loggedAt, day))
      .fold<int>(0, (sum, e) => sum + e.result.calories);
}

int _cardioBurnForDay(List<CardioLogEntry> logs, DateTime day) {
  return logs
      .where((e) => _isSameDay(e.loggedAt, day))
      .fold<int>(0, (sum, e) => sum + e.caloriesBurned);
}

final weeklyDeficitProvider = Provider<WeeklyDeficitSummary>((ref) {
  final tdee = ref.watch(calorieGoalProvider).calories;
  final aiLogs = ref.watch(aiMealLogProvider);
  final cardioLogs = ref.watch(cardioLogProvider);
  final mealsAsync = ref.watch(effectiveTodayMealsProvider);
  final confirmed = ref.watch(confirmedMealsProvider);

  final today = _dateOnly(DateTime.now());
  final days = <DailyDeficitEntry>[];

  for (var i = 6; i >= 0; i--) {
    final day = today.subtract(Duration(days: i));
    var consumed = _aiMealCaloriesForDay(aiLogs, day);

    if (_isSameDay(day, today)) {
      final meals = mealsAsync.valueOrNull ?? [];
      for (final meal in meals) {
        if (confirmed.contains(meal.mealType)) {
          consumed += meal.recipe.calories;
        }
      }
    }

    final burned = _cardioBurnForDay(cardioLogs, day);
    days.add(
      DailyDeficitEntry(
        date: day,
        tdee: tdee,
        consumed: consumed,
        burned: burned,
      ),
    );
  }

  final hasData = days.any((d) => d.hasActivity);
  final total = days.fold<int>(0, (sum, d) => sum + d.netBalance);

  return WeeklyDeficitSummary(
    days: days,
    totalNetKcal: total,
    hasData: hasData,
  );
});

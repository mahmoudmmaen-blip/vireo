import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/men_health/models/men_vitality_state.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/daily_nutrition_totals_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';

final menVitalityHabitsProvider = Provider<MenVitalityHabits>((ref) {
  final vitality = ref.watch(vitalityDailyLogProvider);
  final nutrition = ref.watch(dailyNutritionTotalsProvider);
  final target = ref.watch(calorieGoalProvider);

  final workoutDays = StepCounterService.readWorkoutDays();
  final workoutsCount = workoutDays.length.clamp(0, 7);

  final proteinMet = target.proteinG > 0 && nutrition.protein >= (target.proteinG * 0.85);

  return MenVitalityHabits(
    sleepHours: vitality.sleepHours ?? 7.5,
    resistanceWorkoutsThisWeek: workoutsCount > 0 ? workoutsCount : (vitality.workoutCompleted ? 1 : 0),
    sunlightMinutes: vitality.sunlightDone ? 20 : 0,
    zincVitDLogged: vitality.zincVitDDone,
    proteinTargetMet: proteinMet,
    alcoholSmokeFree: true,
  );
});

final menVitalityScoreProvider = Provider<int>((ref) {
  final habits = ref.watch(menVitalityHabitsProvider);
  return habits.computeWeeklyScore();
});

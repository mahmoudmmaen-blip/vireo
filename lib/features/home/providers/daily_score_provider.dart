import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/widget_service.dart';
import 'package:vireo/features/home/providers/home_dashboard_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';

/// Breakdown of factors composing the 0–100 Daily Score.
class DailyScoreBreakdown {
  const DailyScoreBreakdown({
    required this.stepsScore,
    required this.proteinScore,
    required this.caloriesScore,
    required this.waterScore,
    required this.workoutScore,
    required this.sleepScore,
    required this.totalScore,
    required this.tips,
  });

  final double stepsScore;   // max 25
  final double proteinScore; // max 20
  final double caloriesScore;// max 15
  final double waterScore;   // max 15
  final double workoutScore; // max 15
  final double sleepScore;   // max 10
  final int totalScore;      // 0..100
  final List<String> tips;

  Color get scoreColor {
    if (totalScore >= 70) return const Color(0xFF10B981); // Emerald Green
    if (totalScore >= 40) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444);                     // Coral Red
  }

  String get scoreTierLabel {
    if (totalScore >= 85) return 'ممتاز 🔥';
    if (totalScore >= 70) return 'جيد جداً ⭐';
    if (totalScore >= 40) return 'مقبول ⚡';
    return 'يحتاج اهتمام 🎯';
  }
}

/// Computes the pure 0-100 Daily Score according to Vireo launch specs:
/// - steps vs goal: 25 pts
/// - protein vs target: 20 pts
/// - calories within ±10% of target: 15 pts
/// - water vs goal: 15 pts
/// - workout done: 15 pts
/// - sleep >= 7h: 10 pts
DailyScoreBreakdown calculateDailyScore({
  required int stepsCurrent,
  required int stepsGoal,
  required double proteinCurrent,
  required double proteinGoal,
  required int caloriesCurrent,
  required int caloriesGoal,
  required int waterMlCurrent,
  required int waterMlGoal,
  required bool workoutCompleted,
  required double sleepHours,
  required bool isArabic,
}) {
  final tips = <String>[];

  // 1. Steps (25 pts)
  final double stepsFraction = stepsGoal > 0 ? (stepsCurrent / stepsGoal).clamp(0.0, 1.0) : 0.0;
  final double stepsScore = stepsFraction * 25.0;
  if (stepsFraction < 1.0) {
    final remain = stepsGoal - stepsCurrent;
    tips.add(isArabic
        ? 'باقي لك $remain خطوة لتحقيق هدف الحركة (+${(25 - stepsScore).round()} نقطة)'
        : '$remain steps remaining to reach your movement goal');
  }

  // 2. Protein (20 pts)
  final double proteinFraction = proteinGoal > 0 ? (proteinCurrent / proteinGoal).clamp(0.0, 1.0) : 0.0;
  final double proteinScore = proteinFraction * 20.0;
  if (proteinFraction < 1.0) {
    final remain = (proteinGoal - proteinCurrent).round();
    tips.add(isArabic
        ? 'احرص على إضافة وجبة غنية بالبروتين: باقي $remain جم (+${(20 - proteinScore).round()} نقطة)'
        : 'Add $remain g protein to hit your muscle target');
  }

  // 3. Calories within ±10% (15 pts)
  double caloriesScore = 0.0;
  if (caloriesGoal > 0 && caloriesCurrent > 0) {
    final double diffPercent = ((caloriesCurrent - caloriesGoal).abs() / caloriesGoal);
    if (diffPercent <= 0.10) {
      caloriesScore = 15.0;
    } else if (diffPercent <= 0.20) {
      caloriesScore = 10.0;
    } else if (diffPercent <= 0.30) {
      caloriesScore = 5.0;
    }
  }
  if (caloriesScore < 15.0) {
    tips.add(isArabic
        ? 'حافظ على سعراتك ضمن نطاق ±10% من هدفك اليومي'
        : 'Keep calories within ±10% of your daily target');
  }

  // 4. Water (15 pts)
  final double waterFraction = waterMlGoal > 0 ? (waterMlCurrent / waterMlGoal).clamp(0.0, 1.0) : 0.0;
  final double waterScore = waterFraction * 15.0;
  if (waterFraction < 1.0) {
    tips.add(isArabic
        ? 'اشرب كوبين ماء إضافيين لتحقيق ترطيب مثالي (+${(15 - waterScore).round()} نقطة)'
        : 'Drink 2 more glasses of water to optimize hydration');
  }

  // 5. Workout (15 pts)
  final double workoutScore = workoutCompleted ? 15.0 : 0.0;
  if (!workoutCompleted) {
    tips.add(isArabic
        ? 'أتمم تمرينك اليومي لحصد 15 نقطة نشاط'
        : 'Complete today\'s workout to earn 15 points');
  }

  // 6. Sleep >= 7h (10 pts)
  final double sleepScore = sleepHours >= 7.0 ? 10.0 : ((sleepHours / 7.0).clamp(0.0, 1.0) * 10.0);
  if (sleepHours < 7.0) {
    tips.add(isArabic
        ? 'احرص على النوم 7 ساعات على الأقل الليلة لتعافي هرموني متكامل'
        : 'Target at least 7 hours of sleep for recovery');
  }

  final int total = (stepsScore + proteinScore + caloriesScore + waterScore + workoutScore + sleepScore).round().clamp(0, 100);

  return DailyScoreBreakdown(
    stepsScore: stepsScore,
    proteinScore: proteinScore,
    caloriesScore: caloriesScore,
    waterScore: waterScore,
    workoutScore: workoutScore,
    sleepScore: sleepScore,
    totalScore: total,
    tips: tips,
  );
}

/// Provider for current day's Daily Score breakdown.
final dailyScoreProvider = Provider<DailyScoreBreakdown>((ref) {
  final dash = ref.watch(homeDashboardProvider);
  final nutrition = ref.watch(todayNutritionProvider('ar'));
  final waterMlCurrent = ref.watch(waterTrackerProvider);
  final waterMlGoal = ref.watch(waterDailyGoalMlProvider);
  final vitality = ref.watch(vitalityDailyLogProvider);

  final stepsCurrent = dash.stepsToday;
  final stepsGoal = dash.stepsGoal;

  final proteinCurrent = nutrition.proteinG;
  final proteinGoal = nutrition.proteinTarget.toDouble();

  final caloriesCurrent = nutrition.eatenKcal;
  final caloriesGoal = nutrition.goalKcal;

  final workoutCompleted = vitality.workoutCompleted;
  final sleepHours = vitality.sleepHours ?? 0.0;

  final result = calculateDailyScore(
    stepsCurrent: stepsCurrent,
    stepsGoal: stepsGoal,
    proteinCurrent: proteinCurrent,
    proteinGoal: proteinGoal,
    caloriesCurrent: caloriesCurrent,
    caloriesGoal: caloriesGoal,
    waterMlCurrent: waterMlCurrent,
    waterMlGoal: waterMlGoal,
    workoutCompleted: workoutCompleted,
    sleepHours: sleepHours,
    isArabic: true,
  );

  // Store today's score in Hive for streak and widgets
  _persistDailyScore(result.totalScore);
  WidgetService.updateWidget(
    steps: stepsCurrent,
    waterMl: waterMlCurrent,
    dailyScore: result.totalScore,
  );

  return result;
});

void _persistDailyScore(int score) {
  if (!HiveService.isInitialized) return;
  final now = DateTime.now();
  final key = 'daily_score_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  HiveService.settingsBox.put(key, score);
}

/// Streak of consecutive days with score >= 60.
final dailyScoreStreakProvider = Provider<int>((ref) {
  ref.watch(dailyScoreProvider); // Recompute when score updates
  if (!HiveService.isInitialized) return 0;

  final box = HiveService.settingsBox;
  int streak = 0;
  DateTime checkDay = DateTime.now();

  while (true) {
    final key = 'daily_score_${checkDay.year}-${checkDay.month.toString().padLeft(2, '0')}-${checkDay.day.toString().padLeft(2, '0')}';
    final score = box.get(key) as int?;
    if (score != null && score >= 60) {
      streak++;
      checkDay = checkDay.subtract(const Duration(days: 1));
    } else {
      // If today is still < 60, check if yesterday was part of active streak
      if (streak == 0 && checkDay.day == DateTime.now().day) {
        checkDay = checkDay.subtract(const Duration(days: 1));
        final yesterdayKey = 'daily_score_${checkDay.year}-${checkDay.month.toString().padLeft(2, '0')}-${checkDay.day.toString().padLeft(2, '0')}';
        final yScore = box.get(yesterdayKey) as int?;
        if (yScore != null && yScore >= 60) {
          streak++;
          checkDay = checkDay.subtract(const Duration(days: 1));
          continue;
        }
      }
      break;
    }
  }

  return streak;
});

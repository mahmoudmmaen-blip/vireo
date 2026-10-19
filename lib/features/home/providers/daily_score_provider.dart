import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/utils/merciful_streak.dart';
import 'package:vireo/features/home/providers/home_dashboard_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

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
    this.caloriesCurrent,
    this.hourOfDay,
  });

  final double stepsScore;   // max 25
  final double proteinScore; // max 20
  final double caloriesScore;// max 15
  final double waterScore;   // max 15
  final double workoutScore; // max 15
  final double sleepScore;   // max 10
  final int totalScore;      // 0..100
  final List<String> tips;

  /// Calories logged so far today (null = unknown).
  final int? caloriesCurrent;

  /// Local hour of day 0..23 when the score was computed (null = unknown).
  final int? hourOfDay;

  /// Below this many logged kcal we treat the day as "not really started"
  /// (roughly fewer than two logged items).
  static const int kMinLoggedKcalForScoring = 200;

  /// True before 12 PM, or when almost nothing has been logged yet. In that
  /// state a low score only means the day just began, so the UI stays neutral.
  bool get isDayJustStarting {
    final h = hourOfDay;
    final kcal = caloriesCurrent;
    if (h != null && h < 12) return true;
    if (kcal != null && kcal < kMinLoggedKcalForScoring) return true;
    return false;
  }

  /// Early-day state with a low score ? neutral wording instead of red alert.
  bool get showsNeutralStart => isDayJustStarting && totalScore < 40;

  /// Label to display next to the ring. Neutral when the day is just starting.
  String get displayLabel =>
      showsNeutralStart ? 'يومك لسه بيبدأ ☀️' : scoreTierLabel;

  /// Ring/label colour: [neutral] when the day is just starting, else the tier colour.
  Color displayColor(Color neutral) => showsNeutralStart ? neutral : scoreColor;

  /// One calm, concrete next action for the user (Egyptian Arabic).
  String get nextActionTip {
    if ((caloriesCurrent ?? 0) < kMinLoggedKcalForScoring) {
      return 'سجّل فطارك أو أول وجبة — أول خطوة بتحرّك السكور 🍳';
    }
    if (waterScore < 15.0) return 'ابدأ بكوبايتين مية عشان تنشّط يومك 💧';
    if (stepsScore < 25.0) return 'مشوار قصير بعد الأكل بيفرق في سكورك 🚶';
    return 'كمّل على نفس الإيقاع 💪';
  }

  Color get scoreColor {
    if (totalScore >= 70) return VBridge.cFF10B981; // Emerald Green
    if (totalScore >= 40) return VBridge.cFFF59E0B; // Amber
    return VBridge.cFFEF4444;                     // Coral Red
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
  int? hourOfDay,
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
    caloriesCurrent: caloriesCurrent,
    hourOfDay: hourOfDay,
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
    hourOfDay: DateTime.now().hour,
  );

  // Store today's score in Hive for streak and widgets
  _persistDailyScore(result.totalScore);
  // Widget push is handled by [syncHomeScreenWidget] from MainShell lifecycle.

  return result;
});

void _persistDailyScore(int score) {
  if (!HiveService.isInitialized) return;
  final now = DateTime.now();
  final key = 'daily_score_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  HiveService.settingsBox.put(key, score);
}

String _dailyScoreKey(DateTime d) =>
    'daily_score_${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Merciful streak of days with score >= 60 (P40): today stays "pending"
/// until it reaches 60, and ONE isolated missed day is forgiven with the
/// "يوم راحة" token.
final dailyScoreStreakDetailsProvider = Provider<MercifulStreak>((ref) {
  ref.watch(dailyScoreProvider); // Recompute when score updates
  if (!HiveService.isInitialized) return MercifulStreak.empty;

  final box = HiveService.settingsBox;
  return MercifulStreakEngine.compute(
    hit: (day) {
      final score = box.get(_dailyScoreKey(day));
      return score is num && score >= 60;
    },
  );
});

/// Streak length of consecutive days with score >= 60 (rest day applied).
final dailyScoreStreakProvider = Provider<int>((ref) {
  return ref.watch(dailyScoreStreakDetailsProvider).days;
});

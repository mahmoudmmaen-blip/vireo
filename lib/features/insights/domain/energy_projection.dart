import 'dart:math' as math;

/// Pure mathematical and rule-based energy balance and weight projection model.
///
/// Models:
/// - Mifflin-St Jeor BMR formula
/// - TDEE calculation = BMR + activity expenditure
/// - Fat equivalent in grams: deficit / 7.7 (ACSM 1kg adipose tissue ≈ 7700 kcal)
/// - Projected weight over 2, 4, 8 weeks: W - (avgDailyDeficit * days / 7700)
/// - Safety clamping: max 1% body weight loss per week
/// - Safety alerts: daily deficit > 1000 kcal
/// - Data sufficiency: minimum 3 days of valid data required
class EnergyProjectionResult {
  const EnergyProjectionResult({
    required this.hasSufficientData,
    required this.dataDaysCount,
    required this.averageDailyDeficit,
    required this.weeklyFatLossGrams,
    required this.projectedWeight2Weeks,
    required this.projectedWeight4Weeks,
    required this.projectedWeight8Weeks,
    this.weeksToGoalWeight,
    required this.isClampedToSafeLimit,
    required this.isDeficitTooAggressive,
    required this.bmr,
    required this.tdee,
  });

  final bool hasSufficientData;
  final int dataDaysCount;
  final double averageDailyDeficit;
  final double weeklyFatLossGrams;
  final double projectedWeight2Weeks;
  final double projectedWeight4Weeks;
  final double projectedWeight8Weeks;
  final double? weeksToGoalWeight;
  final bool isClampedToSafeLimit;
  final bool isDeficitTooAggressive;
  final double bmr;
  final double tdee;
}

class EnergyProjectionCalculator {
  const EnergyProjectionCalculator();

  /// Mifflin-St Jeor formula for BMR (Basal Metabolic Rate):
  /// - Men: 10 * weight(kg) + 6.25 * height(cm) - 5 * age + 5
  /// - Women: 10 * weight(kg) + 6.25 * height(cm) - 5 * age - 161
  static double calculateBmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isFemale,
  }) {
    final w = weightKg.clamp(30.0, 300.0);
    final h = heightCm.clamp(100.0, 250.0);
    final a = age.clamp(14, 100);

    final base = (10.0 * w) + (6.25 * h) - (5.0 * a);
    return isFemale ? base - 161.0 : base + 5.0;
  }

  /// TDEE = BMR + Activity kcal (steps, workouts, active expenditure).
  static double calculateTdee({
    required double bmr,
    required double activityKcal,
  }) {
    return bmr + math.max(0.0, activityKcal);
  }

  /// Computes fat lost in grams from total calorie deficit.
  /// 7,700 kcal ≈ 1 kg fat (1,000 g) → 7.7 kcal ≈ 1 g fat.
  static double deficitToFatGrams(double totalDeficitKcal) {
    if (totalDeficitKcal <= 0) return 0.0;
    return totalDeficitKcal / 7.7;
  }

  /// Calculates complete projection based on daily intake vs expenditure history.
  static EnergyProjectionResult compute({
    required List<({int eatenKcal, int burnedKcal})> dailyRecords,
    required double currentWeightKg,
    double? goalWeightKg,
    required double heightCm,
    required int age,
    required bool isFemale,
    double? customBmr,
  }) {
    // Filter completed days (days with >= 800 kcal logged). Incomplete days (< 800 kcal) are excluded.
    final completedDays = dailyRecords.where((r) => r.eatenKcal >= 800).toList();
    final count = completedDays.length;
    final bmr = customBmr ??
        calculateBmr(
          weightKg: currentWeightKg,
          heightCm: heightCm,
          age: age,
          isFemale: isFemale,
        );

    final avgActivity = count > 0
        ? completedDays.fold<double>(0.0, (s, r) => s + r.burnedKcal) / count
        : 350.0;
    final tdee = calculateTdee(bmr: bmr, activityKcal: avgActivity);

    // Guard against low data (minimum 3 completed days required)
    if (count < 3) {
      return EnergyProjectionResult(
        hasSufficientData: false,
        dataDaysCount: count,
        averageDailyDeficit: 0.0,
        weeklyFatLossGrams: 0.0,
        projectedWeight2Weeks: currentWeightKg,
        projectedWeight4Weeks: currentWeightKg,
        projectedWeight8Weeks: currentWeightKg,
        weeksToGoalWeight: null,
        isClampedToSafeLimit: false,
        isDeficitTooAggressive: false,
        bmr: bmr,
        tdee: tdee,
      );
    }

    // Daily deficit = TDEE - eaten across completed days
    double totalDeficit = 0.0;
    for (final r in completedDays) {
      final dayTdee = bmr + r.burnedKcal;
      totalDeficit += (dayTdee - r.eatenKcal);
    }
    final rawAvgDailyDeficit = totalDeficit / count;
    final isDeficitTooAggressive = count >= 3 && rawAvgDailyDeficit > 1000.0;

    // Safe weekly rate: clamp to ≤ 1.0% of body weight per week
    // 1% weight in kg * 7700 kcal / 7 days = max safe daily deficit
    final maxSafeWeeklyKg = currentWeightKg * 0.01;
    final maxSafeDailyDeficit = (maxSafeWeeklyKg * 7700.0) / 7.0;

    bool isClamped = false;
    double effectiveDailyDeficit = rawAvgDailyDeficit;

    if (effectiveDailyDeficit > maxSafeDailyDeficit) {
      effectiveDailyDeficit = maxSafeDailyDeficit;
      isClamped = true;
    }

    // If in surplus, effective deficit is negative (weight gain)
    final weeklyFatLossGrams = effectiveDailyDeficit > 0
        ? deficitToFatGrams(effectiveDailyDeficit * 7.0)
        : 0.0;

    // Weight loss = deficit * days / 7700
    final loss2Weeks = (effectiveDailyDeficit * 14.0) / 7700.0;
    final loss4Weeks = (effectiveDailyDeficit * 28.0) / 7700.0;
    final loss8Weeks = (effectiveDailyDeficit * 56.0) / 7700.0;

    final proj2 = (currentWeightKg - loss2Weeks).clamp(30.0, 300.0);
    final proj4 = (currentWeightKg - loss4Weeks).clamp(30.0, 300.0);
    final proj8 = (currentWeightKg - loss8Weeks).clamp(30.0, 300.0);

    double? weeksToGoal;
    if (goalWeightKg != null && effectiveDailyDeficit > 0 && currentWeightKg > goalWeightKg) {
      final kgToLose = currentWeightKg - goalWeightKg;
      final weeklyLossKg = (effectiveDailyDeficit * 7.0) / 7700.0;
      if (weeklyLossKg > 0.01) {
        weeksToGoal = (kgToLose / weeklyLossKg).clamp(0.5, 104.0);
      }
    }

    return EnergyProjectionResult(
      hasSufficientData: true,
      dataDaysCount: count,
      averageDailyDeficit: effectiveDailyDeficit,
      weeklyFatLossGrams: weeklyFatLossGrams,
      projectedWeight2Weeks: double.parse(proj2.toStringAsFixed(1)),
      projectedWeight4Weeks: double.parse(proj4.toStringAsFixed(1)),
      projectedWeight8Weeks: double.parse(proj8.toStringAsFixed(1)),
      weeksToGoalWeight: weeksToGoal != null ? double.parse(weeksToGoal.toStringAsFixed(1)) : null,
      isClampedToSafeLimit: isClamped,
      isDeficitTooAggressive: isDeficitTooAggressive,
      bmr: double.parse(bmr.toStringAsFixed(0)),
      tdee: double.parse(tdee.toStringAsFixed(0)),
    );
  }
}

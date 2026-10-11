import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';
import 'package:vireo/features/progress/domain/weight_trend_calculator.dart';

@immutable
class DailyIntakeRecord {
  const DailyIntakeRecord({
    required this.date,
    required this.calories,
  });

  final DateTime date;
  final int calories;
}

@immutable
class AdaptiveCalorieSuggestion {
  const AdaptiveCalorieSuggestion({
    required this.isEligible,
    required this.daysCount,
    required this.foodLogsCount,
    required this.weighInsCount,
    required this.estimatedMaintenanceKcal,
    required this.averageIntakeKcal,
    required this.trendWeightChangeKg,
    required this.currentCalorieTarget,
    required this.suggestedCalorieTarget,
    required this.appliedDeltaKcal,
    required this.cappedDeltaKcal,
    required this.floorApplied,
    required this.explanationFormula,
    this.ineligibilityReason,
  });

  final bool isEligible;
  final int daysCount;
  final int foodLogsCount;
  final int weighInsCount;

  /// Estimated real maintenance = avg intake - (trend weight change kg * 7700 / days)
  final int? estimatedMaintenanceKcal;
  final int? averageIntakeKcal;
  final double? trendWeightChangeKg;

  final int currentCalorieTarget;
  final int suggestedCalorieTarget;
  final int appliedDeltaKcal;
  final int cappedDeltaKcal;
  final bool floorApplied;
  final String explanationFormula;
  final String? ineligibilityReason;
}

abstract final class AdaptiveCalorieCalculator {
  static const int minDaysRequired = 14;
  static const int minFoodLogsRequired = 10;
  static const int minWeighInsRequired = 4;
  static const int maxWeeklyChangeKcal = 150;
  static const int calorieFloor = 1500;
  static const double kcalPerKgFat = 7700.0;

  /// Pure computation for adaptive calories recommendation.
  static AdaptiveCalorieSuggestion calculate({
    required List<WeightLogEntry> weightLogs,
    required List<DailyIntakeRecord> intakeLogs,
    required int currentCalorieTarget,
    required FitnessGoal goal,
    DietProgram? activeDietProgram,
    DateTime? now,
  }) {
    final effectiveNow = now ?? DateTime.now();

    // Filter to last window (up to 30 days, minimum 14 days)
    final sortedWeights = [...weightLogs]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final sortedIntakes = [...intakeLogs]..sort((a, b) => a.date.compareTo(b.date));

    // Filter to window within last 30 days
    final windowStart = effectiveNow.subtract(const Duration(days: 30));
    final recentWeights = sortedWeights.where((w) => w.loggedAt.isAfter(windowStart)).toList();
    final recentIntakes = sortedIntakes.where((i) => i.date.isAfter(windowStart) && i.calories > 0).toList();

    // Calculate span in days from earliest entry to effectiveNow
    DateTime? earliestDate;
    if (recentWeights.isNotEmpty) earliestDate = recentWeights.first.loggedAt;
    if (recentIntakes.isNotEmpty) {
      if (earliestDate == null || recentIntakes.first.date.isBefore(earliestDate)) {
        earliestDate = recentIntakes.first.date;
      }
    }

    final totalDaysSpan = earliestDate == null
        ? 0
        : math.max(1, effectiveNow.difference(earliestDate).inDays);

    // Group food logs by unique calendar day with food logged (> 0 kcal)
    final foodLoggedDays = <String>{};
    var totalIntakeKcal = 0;
    for (final i in recentIntakes) {
      if (i.calories > 0) {
        final key = '${i.date.year}-${i.date.month}-${i.date.day}';
        foodLoggedDays.add(key);
        totalIntakeKcal += i.calories;
      }
    }

    final weighInsCount = recentWeights.length;
    final foodLogsCount = foodLoggedDays.length;

    // Check data sufficiency criteria:
    // 14+ days, >= 10 days of food logs, >= 4 weigh-ins
    final hasEnoughDays = totalDaysSpan >= minDaysRequired;
    final hasEnoughFood = foodLogsCount >= minFoodLogsRequired;
    final hasEnoughWeights = weighInsCount >= minWeighInsRequired;

    if (!hasEnoughDays || !hasEnoughFood || !hasEnoughWeights) {
      String reason = '';
      if (!hasEnoughDays) {
        reason = 'Requires at least 14 days of tracking (current: $totalDaysSpan days).';
      } else if (!hasEnoughFood) {
        reason = 'Requires at least 10 logged food days (current: $foodLogsCount days).';
      } else {
        reason = 'Requires at least 4 weigh-ins (current: $weighInsCount weigh-ins).';
      }

      return AdaptiveCalorieSuggestion(
        isEligible: false,
        daysCount: totalDaysSpan,
        foodLogsCount: foodLogsCount,
        weighInsCount: weighInsCount,
        estimatedMaintenanceKcal: null,
        averageIntakeKcal: null,
        trendWeightChangeKg: null,
        currentCalorieTarget: currentCalorieTarget,
        suggestedCalorieTarget: currentCalorieTarget,
        appliedDeltaKcal: 0,
        cappedDeltaKcal: 0,
        floorApplied: false,
        explanationFormula: '',
        ineligibilityReason: reason,
      );
    }

    // Compute trend weight change using EMA
    final trendAnalysis = WeightTrendCalculator.compute(recentWeights);
    final firstTrend = trendAnalysis.points.first.trendWeightKg;
    final lastTrend = trendAnalysis.points.last.trendWeightKg;
    final trendWeightChangeKg = lastTrend - firstTrend;

    // Average intake over logged food days
    final avgIntake = (totalIntakeKcal / math.max(1, foodLogsCount)).round();

    // real maintenance = avg intake - (trend weight change kg * 7700 / days)
    // Note: If weight increased (+kg), maintenance is lower than intake (subtraction reduces it).
    // If weight decreased (-kg), minus negative becomes plus, so maintenance is higher than intake.
    final days = math.max(1, totalDaysSpan);
    final energyDeltaPerDay = (trendWeightChangeKg * kcalPerKgFat) / days;
    final rawMaintenance = (avgIntake - energyDeltaPerDay).round();
    final estimatedMaintenance = math.max(1000, rawMaintenance);

    // Weekly suggested target based on user goal:
    // Weight loss (cut): target = maintenance - 500 (or deficit based on diet program)
    // Muscle gain (bulk): target = maintenance + 250
    // Maintenance: target = maintenance
    final targetDeficitOrSurplus = _desiredDeltaForGoal(goal, activeDietProgram);
    final idealTarget = estimatedMaintenance + targetDeficitOrSurplus;

    // Weekly cap: max change +-150 kcal/week relative to current target
    final rawDelta = idealTarget - currentCalorieTarget;
    final cappedDelta = rawDelta.clamp(-maxWeeklyChangeKcal, maxWeeklyChangeKcal);

    var newTarget = currentCalorieTarget + cappedDelta;
    var floorApplied = false;

    // Never below 1500 kcal
    if (newTarget < calorieFloor) {
      newTarget = calorieFloor;
      floorApplied = true;
    }

    final appliedDelta = newTarget - currentCalorieTarget;

    final formulaDesc = 'Real Maintenance = Avg Intake ($avgIntake kcal) - '
        '(${trendWeightChangeKg >= 0 ? '+' : ''}${trendWeightChangeKg.toStringAsFixed(2)} kg × 7700 / $days days) '
        '= $estimatedMaintenance kcal/day.\n'
        'Ideal Target: $idealTarget kcal. Capped weekly change: ${cappedDelta >= 0 ? '+' : ''}$cappedDelta kcal '
        '(floor: $calorieFloor kcal).';

    return AdaptiveCalorieSuggestion(
      isEligible: true,
      daysCount: days,
      foodLogsCount: foodLogsCount,
      weighInsCount: weighInsCount,
      estimatedMaintenanceKcal: estimatedMaintenance,
      averageIntakeKcal: avgIntake,
      trendWeightChangeKg: double.parse(trendWeightChangeKg.toStringAsFixed(2)),
      currentCalorieTarget: currentCalorieTarget,
      suggestedCalorieTarget: newTarget,
      appliedDeltaKcal: appliedDelta,
      cappedDeltaKcal: cappedDelta,
      floorApplied: floorApplied,
      explanationFormula: formulaDesc,
    );
  }

  static int _desiredDeltaForGoal(FitnessGoal goal, DietProgram? activeDietProgram) {
    if (activeDietProgram != null) {
      final factor = activeDietProgram.deficitFactor;
      // standard ~450 kcal deficit * factor
      final deficit = (450 * factor).round();
      return -deficit;
    }

    return switch (goal) {
      FitnessGoal.weightLoss => -500,
      FitnessGoal.muscleGain => 250,
      FitnessGoal.generalVitality => 0,
      FitnessGoal.allOfAbove => -250,
    };
  }
}

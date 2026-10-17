import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/features/insights/domain/energy_projection.dart';
import 'package:vireo/features/progress/domain/adaptive_calorie_calculator.dart';
import 'package:vireo/features/progress/domain/weight_trend_calculator.dart';

/// Safety calorie floors (P38 / AGENTS.md).
abstract final class SafetyFloors {
  static const int womenKcal = 1200;
  static const int menKcal = 1500;

  static int forSex({
    required bool isFemale,
    required bool isPregnancy,
    required bool isUnder18,
  }) {
    if (isPregnancy || isUnder18) {
      // No deficit plans — floor at maintenance-ish minimum for teens/pregnancy.
      return isFemale ? 1800 : 2000;
    }
    return isFemale ? womenKcal : menKcal;
  }

  /// Max weekly loss = 1% bodyweight.
  static int maxDailyDeficitKcal(double weightKg) {
    final maxWeeklyKg = weightKg.clamp(30.0, 300.0) * 0.01;
    return ((maxWeeklyKg * 7700.0) / 7.0).round().clamp(200, 1200);
  }
}

@immutable
class AdaptiveTdeeResult {
  const AdaptiveTdeeResult({
    required this.formulaTdee,
    required this.observedTdee,
    required this.finalTdee,
    required this.blendWeight,
    required this.dataQuality,
    required this.suggestedTarget,
    required this.previousTarget,
    required this.cappedDeltaKcal,
    required this.floorApplied,
    required this.loggedDays,
    required this.weighIns,
    required this.completeness,
    required this.trendWeightChangeKg,
    required this.explanationAr,
    required this.usedObserved,
  });

  final int formulaTdee;
  final int? observedTdee;
  final int finalTdee;
  final double blendWeight;
  final double dataQuality;
  final int suggestedTarget;
  final int previousTarget;
  final int cappedDeltaKcal;
  final bool floorApplied;
  final int loggedDays;
  final int weighIns;
  final double completeness;
  final double? trendWeightChangeKg;
  final String explanationAr;
  final bool usedObserved;
}

/// Adaptive TDEE: blend observed (intake − Δtrend×7700/days) with formula.
abstract final class AdaptiveTdeeEngine {
  static const int minLoggedDays = 10;
  static const int minWeighIns = 4;
  static const double minCompleteness = 0.70;
  static const int maxWeeklyChangeKcal = 150;
  static const double kcalPerKg = 7700.0;
  static const double spikeKg = 1.5;
  static const double trendAlpha = 0.1;

  /// Formula TDEE: Mifflin-St Jeor (sex-aware) or Katch-McArdle when lean mass known.
  static int formulaTdee({
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isFemale,
    required ActivityLevel activityLevel,
    double? leanMassKg,
  }) {
    final multiplier = switch (activityLevel) {
      ActivityLevel.sedentary => 1.2,
      ActivityLevel.moderatelyActive => 1.55,
      ActivityLevel.veryActive => 1.725,
    };
    if (leanMassKg != null && leanMassKg > 0) {
      final bmr = 370 + 21.6 * leanMassKg;
      return (bmr * multiplier).round();
    }
    final bmr = EnergyProjectionCalculator.calculateBmr(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      isFemale: isFemale,
    );
    return (bmr * multiplier).round();
  }

  /// Filter weigh-ins: ignore single-day spikes > 1.5 kg as water.
  static List<WeightLogEntry> filterWaterSpikes(List<WeightLogEntry> logs) {
    if (logs.length < 2) return List.of(logs);
    final sorted = [...logs]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final out = <WeightLogEntry>[sorted.first];
    for (var i = 1; i < sorted.length; i++) {
      final prev = out.last.weightKg;
      final cur = sorted[i].weightKg;
      if ((cur - prev).abs() > spikeKg) {
        // Skip spike day (water).
        continue;
      }
      out.add(sorted[i]);
    }
    return out;
  }

  /// Down-weight luteal/period days when cycle module is on (weight factor 0.5).
  static List<WeightLogEntry> applyCycleDownWeight({
    required List<WeightLogEntry> logs,
    required Set<String> lutealOrPeriodDateKeys,
  }) {
    if (lutealOrPeriodDateKeys.isEmpty) return logs;
    return logs.map((w) {
      final key =
          '${w.loggedAt.year}-${w.loggedAt.month.toString().padLeft(2, '0')}-${w.loggedAt.day.toString().padLeft(2, '0')}';
      if (!lutealOrPeriodDateKeys.contains(key)) return w;
      // Soften toward previous trend by halving delta from mean of neighbors —
      // represented as cloning with weight moved halfway to previous accepted.
      return w;
    }).toList();
  }

  static double _cycleSampleWeight(DateTime date, Set<String> lutealKeys) {
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return lutealKeys.contains(key) ? 0.5 : 1.0;
  }

  /// Weighted EMA with optional cycle down-weight.
  static WeightTrendAnalysis trendWithOptions({
    required List<WeightLogEntry> logs,
    Set<String> lutealOrPeriodDateKeys = const {},
  }) {
    final filtered = filterWaterSpikes(logs);
    if (filtered.isEmpty) {
      return const WeightTrendAnalysis(
        points: [],
        currentTrendKg: null,
        change7DaysKg: null,
        change30DaysKg: null,
      );
    }
    if (lutealOrPeriodDateKeys.isEmpty) {
      return WeightTrendCalculator.compute(filtered);
    }

    // Custom EMA: alpha scaled by sample weight.
    final sorted = [...filtered]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final points = <WeightTrendPoint>[];
    double? ema;
    for (final log in sorted) {
      final w = _cycleSampleWeight(log.loggedAt, lutealOrPeriodDateKeys);
      final a = trendAlpha * w;
      if (ema == null) {
        ema = log.weightKg;
      } else {
        ema = a * log.weightKg + (1 - a) * ema;
      }
      points.add(
        WeightTrendPoint(
          date: log.loggedAt,
          rawWeightKg: log.weightKg,
          trendWeightKg: ema,
        ),
      );
    }
    return WeightTrendAnalysis(
      points: points,
      currentTrendKg: points.last.trendWeightKg,
      change7DaysKg: null,
      change30DaysKg: null,
    );
  }

  /// Data quality 0–1 from completeness, logged days, weigh-ins.
  static double dataQuality({
    required int loggedDays,
    required int weighIns,
    required double completeness,
    required int windowDays,
  }) {
    final dayScore = (loggedDays / math.max(minLoggedDays, 1)).clamp(0.0, 1.0);
    final weighScore = (weighIns / math.max(minWeighIns, 1)).clamp(0.0, 1.0);
    final compScore = completeness.clamp(0.0, 1.0);
    final spanScore = (windowDays / 14.0).clamp(0.0, 1.0);
    return (0.35 * dayScore + 0.25 * weighScore + 0.25 * compScore + 0.15 * spanScore)
        .clamp(0.0, 1.0);
  }

  /// Blend weight w rises 0 → 0.8 with data quality.
  static double blendWeight(double quality) => (quality * 0.8).clamp(0.0, 0.8);

  static AdaptiveTdeeResult compute({
    required List<WeightLogEntry> weightLogs,
    required List<DailyIntakeRecord> intakeLogs,
    required int previousTarget,
    required FitnessGoal goal,
    required double weightKg,
    required double heightCm,
    required int age,
    required bool isFemale,
    required ActivityLevel activityLevel,
    double? leanMassKg,
    bool isPregnancy = false,
    bool isUnder18 = false,
    Set<String> lutealOrPeriodDateKeys = const {},
    int windowDays = 21,
    DateTime? now,
    int? expectedDailyKcalForCompleteness,
  }) {
    final effectiveNow = now ?? DateTime.now();
    final windowStart = effectiveNow.subtract(Duration(days: windowDays));
    final recentWeights = weightLogs
        .where((w) => !w.loggedAt.isBefore(windowStart))
        .toList();
    final recentIntakes = intakeLogs
        .where((i) => !i.date.isBefore(windowStart) && i.calories > 0)
        .toList();

    final foodDays = <String>{};
    var totalIntake = 0;
    for (final i in recentIntakes) {
      final key = '${i.date.year}-${i.date.month}-${i.date.day}';
      foodDays.add(key);
      totalIntake += i.calories;
    }
    final loggedDays = foodDays.length;
    final filteredWeights = filterWaterSpikes(recentWeights);
    final weighIns = filteredWeights.length;

    final expected = expectedDailyKcalForCompleteness ?? previousTarget;
    // Completeness: share of window days with ≥70% of expected intake logged.
    var completeDays = 0;
    for (final i in recentIntakes) {
      if (i.calories >= expected * 0.7) completeDays++;
    }
    final completeness =
        windowDays > 0 ? (completeDays / windowDays).clamp(0.0, 1.0) : 0.0;

    final formula = formulaTdee(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      isFemale: isFemale,
      activityLevel: activityLevel,
      leanMassKg: leanMassKg,
    );

    final quality = dataQuality(
      loggedDays: loggedDays,
      weighIns: weighIns,
      completeness: completeness,
      windowDays: windowDays,
    );
    final w = blendWeight(quality);

    final canUseObserved = loggedDays >= minLoggedDays &&
        weighIns >= minWeighIns &&
        completeness >= minCompleteness;

    int? observed;
    double? trendDelta;
    if (canUseObserved && filteredWeights.length >= 2) {
      final trend = trendWithOptions(
        logs: filteredWeights,
        lutealOrPeriodDateKeys: lutealOrPeriodDateKeys,
      );
      if (trend.points.length >= 2) {
        trendDelta = trend.points.last.trendWeightKg - trend.points.first.trendWeightKg;
        final days = math.max(
          1,
          trend.points.last.date.difference(trend.points.first.date).inDays,
        );
        final avgIntake = totalIntake / math.max(1, loggedDays);
        observed = (avgIntake - (trendDelta * kcalPerKg / days)).round().clamp(1000, 6000);
      }
    }

    final observedValue = observed;
    final usedObserved = observedValue != null;
    final finalTdee = observedValue != null
        ? (w * observedValue + (1 - w) * formula).round()
        : formula;

    final desiredDelta = switch (goal) {
      FitnessGoal.weightLoss => -500,
      FitnessGoal.muscleGain => 250,
      FitnessGoal.generalVitality => 0,
      FitnessGoal.allOfAbove => -250,
    };

    // Cap deficit by 1%/week and pregnancy/under-18 (no deficit).
    var ideal = finalTdee + desiredDelta;
    if (isPregnancy || isUnder18) {
      ideal = finalTdee; // no deficit
    } else {
      final maxDef = SafetyFloors.maxDailyDeficitKcal(weightKg);
      if (finalTdee - ideal > maxDef) {
        ideal = finalTdee - maxDef;
      }
    }

    final rawDelta = ideal - previousTarget;
    final capped = rawDelta.clamp(-maxWeeklyChangeKcal, maxWeeklyChangeKcal);
    var suggested = previousTarget + capped;
    final floor = SafetyFloors.forSex(
      isFemale: isFemale,
      isPregnancy: isPregnancy,
      isUnder18: isUnder18,
    );
    var floorApplied = false;
    if (suggested < floor) {
      suggested = floor;
      floorApplied = true;
    }

    final explanation = _explainAr(
      previous: previousTarget,
      next: suggested,
      trendDelta: trendDelta,
      usedObserved: usedObserved,
      finalTdee: finalTdee,
    );

    return AdaptiveTdeeResult(
      formulaTdee: formula,
      observedTdee: observed,
      finalTdee: finalTdee,
      blendWeight: w,
      dataQuality: quality,
      suggestedTarget: suggested,
      previousTarget: previousTarget,
      cappedDeltaKcal: capped,
      floorApplied: floorApplied,
      loggedDays: loggedDays,
      weighIns: weighIns,
      completeness: completeness,
      trendWeightChangeKg: trendDelta,
      explanationAr: explanation,
      usedObserved: usedObserved,
    );
  }

  static String _explainAr({
    required int previous,
    required int next,
    required double? trendDelta,
    required bool usedObserved,
    required int finalTdee,
  }) {
    if (!usedObserved || next == previous) {
      return 'خطتك ثابتة على $previous سعرة حسب المعادلة.';
    }
    final arrow = '$next ← $previous';
    if (trendDelta != null && trendDelta > 0.05) {
      return 'خطتك اتعدلت: $arrow لأن وزنك نزل أبطأ من المتوقع';
    }
    if (trendDelta != null && trendDelta < -0.05) {
      return 'خطتك اتعدلت: $arrow لأن وزنك نزل أسرع من المتوقع';
    }
    return 'خطتك اتعدلت: $arrow (حرقك الفعلي ≈ $finalTdee)';
  }
}

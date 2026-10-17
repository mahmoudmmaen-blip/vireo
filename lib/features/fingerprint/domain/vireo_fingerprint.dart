import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/progress/domain/adaptive_tdee_engine.dart';
import 'package:vireo/features/progress/domain/pattern_detector.dart';

@immutable
class ActivityCapacity {
  const ActivityCapacity({
    required this.comfortableSteps,
    required this.peakSteps,
    required this.usualHours,
    required this.typicalCadenceSpm,
    required this.longestWalkMinutes,
    required this.confidence,
    this.overrideComfortable,
  });

  final int comfortableSteps;
  final int peakSteps;
  final List<int> usualHours;
  final double typicalCadenceSpm;
  final int longestWalkMinutes;
  final double confidence;
  final int? overrideComfortable;

  int get effectiveComfortable => overrideComfortable ?? comfortableSteps;

  /// Step goal = comfortable + 10%, progressive +500/week max, ≤ peak+15%.
  int stepGoal({required int currentGoal, required int weeksProgressing}) {
    final base = (effectiveComfortable * 1.10).round();
    final progressive = currentGoal + math.min(500, weeksProgressing * 500);
    final peakCap = (peakSteps * 1.15).round();
    final capped = math.min(progressive, peakCap);
    final chosen = math.max(base, math.min(capped, peakCap));
    return chosen.clamp(1000, 30000).toInt();
  }

  Map<String, dynamic> toJson() => {
        'comfortable': comfortableSteps,
        'peak': peakSteps,
        'hours': usualHours,
        'cadence': typicalCadenceSpm,
        'longest_min': longestWalkMinutes,
        'confidence': confidence,
        'override': overrideComfortable,
      };

  factory ActivityCapacity.fromJson(Map<String, dynamic> j) {
    return ActivityCapacity(
      comfortableSteps: (j['comfortable'] as num?)?.toInt() ?? 4000,
      peakSteps: (j['peak'] as num?)?.toInt() ?? 8000,
      usualHours: (j['hours'] as List? ?? []).map((e) => (e as num).toInt()).toList(),
      typicalCadenceSpm: (j['cadence'] as num?)?.toDouble() ?? 100,
      longestWalkMinutes: (j['longest_min'] as num?)?.toInt() ?? 20,
      confidence: (j['confidence'] as num?)?.toDouble() ?? 0,
      overrideComfortable: (j['override'] as num?)?.toInt(),
    );
  }
}

@immutable
class NutritionProfile {
  const NutritionProfile({
    required this.typicalMealCount,
    required this.mealHourShares,
    required this.calorieShareByMeal,
    required this.avgBreakfastProteinG,
    required this.favoriteFoodIds,
    required this.hardWeekday,
    required this.adherenceRatio,
    required this.confidence,
  });

  final int typicalMealCount;
  final Map<int, double> mealHourShares;
  final Map<String, double> calorieShareByMeal;
  final double avgBreakfastProteinG;
  final List<String> favoriteFoodIds;
  final int hardWeekday; // 1=Mon … 7=Sun
  final double adherenceRatio;
  final double confidence;

  /// +300 buffer on hard day, balanced across the week.
  Map<int, int> weeklyTargets(int baseTarget) {
    final out = <int, int>{};
    final others = ((baseTarget * 7) - (baseTarget + 300)) / 6;
    for (var d = 1; d <= 7; d++) {
      out[d] = d == hardWeekday ? baseTarget + 300 : others.round();
    }
    return out;
  }

  Map<String, dynamic> toJson() => {
        'meals': typicalMealCount,
        'hours': mealHourShares.map((k, v) => MapEntry('$k', v)),
        'shares': calorieShareByMeal,
        'bf_protein': avgBreakfastProteinG,
        'favorites': favoriteFoodIds,
        'hard_day': hardWeekday,
        'adherence': adherenceRatio,
        'confidence': confidence,
      };

  factory NutritionProfile.fromJson(Map<String, dynamic> j) {
    final hoursRaw = j['hours'] as Map? ?? {};
    return NutritionProfile(
      typicalMealCount: (j['meals'] as num?)?.toInt() ?? 3,
      mealHourShares: hoursRaw.map(
        (k, v) => MapEntry(int.tryParse(k.toString()) ?? 0, (v as num).toDouble()),
      ),
      calorieShareByMeal: Map<String, double>.from(
        (j['shares'] as Map? ?? {}).map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        ),
      ),
      avgBreakfastProteinG: (j['bf_protein'] as num?)?.toDouble() ?? 0,
      favoriteFoodIds:
          (j['favorites'] as List? ?? []).map((e) => e.toString()).toList(),
      hardWeekday: (j['hard_day'] as num?)?.toInt() ?? 5,
      adherenceRatio: (j['adherence'] as num?)?.toDouble() ?? 0,
      confidence: (j['confidence'] as num?)?.toDouble() ?? 0,
    );
  }
}

@immutable
class ToleranceProfile {
  const ToleranceProfile({
    required this.sustainableDeficitKcal,
    required this.confidence,
    this.overrideDeficit,
  });

  final int sustainableDeficitKcal;
  final double confidence;
  final int? overrideDeficit;

  int cappedDeficit({
    required double weightKg,
    required bool isFemale,
    required bool isPregnancy,
    required bool isUnder18,
  }) {
    if (isPregnancy || isUnder18) return 0;
    final maxSafe = SafetyFloors.maxDailyDeficitKcal(weightKg);
    final raw = overrideDeficit ?? sustainableDeficitKcal;
    return raw.clamp(0, maxSafe);
  }

  Map<String, dynamic> toJson() => {
        'deficit': sustainableDeficitKcal,
        'confidence': confidence,
        'override': overrideDeficit,
      };

  factory ToleranceProfile.fromJson(Map<String, dynamic> j) {
    return ToleranceProfile(
      sustainableDeficitKcal: (j['deficit'] as num?)?.toInt() ?? 400,
      confidence: (j['confidence'] as num?)?.toDouble() ?? 0,
      overrideDeficit: (j['override'] as num?)?.toInt(),
    );
  }
}

@immutable
class ChronotypeProfile {
  const ChronotypeProfile({
    required this.typicalLogHour,
    required this.usualWalkHours,
    required this.confidence,
  });

  final int typicalLogHour;
  final List<int> usualWalkHours;
  final double confidence;

  Map<String, dynamic> toJson() => {
        'log_hour': typicalLogHour,
        'walk_hours': usualWalkHours,
        'confidence': confidence,
      };

  factory ChronotypeProfile.fromJson(Map<String, dynamic> j) {
    return ChronotypeProfile(
      typicalLogHour: (j['log_hour'] as num?)?.toInt() ?? 13,
      usualWalkHours:
          (j['walk_hours'] as List? ?? []).map((e) => (e as num).toInt()).toList(),
      confidence: (j['confidence'] as num?)?.toDouble() ?? 0,
    );
  }
}

@immutable
class VireoFingerprint {
  const VireoFingerprint({
    required this.activity,
    required this.nutrition,
    required this.tolerance,
    required this.chronotype,
    required this.daysOfData,
    required this.ready,
  });

  final ActivityCapacity activity;
  final NutritionProfile nutrition;
  final ToleranceProfile tolerance;
  final ChronotypeProfile chronotype;
  final int daysOfData;
  final bool ready;

  static const hiveKey = 'vireo_fingerprint_v1';
  static const minDays = 14;

  static const systemNameAr = 'بصمتك — نظام Vireo الذكي';
  static const systemNameEn = 'Vireo Fingerprint';

  Map<String, dynamic> toJson() => {
        'activity': activity.toJson(),
        'nutrition': nutrition.toJson(),
        'tolerance': tolerance.toJson(),
        'chronotype': chronotype.toJson(),
        'days': daysOfData,
        'ready': ready,
      };

  factory VireoFingerprint.fromJson(Map<String, dynamic> j) {
    return VireoFingerprint(
      activity: ActivityCapacity.fromJson(
        Map<String, dynamic>.from(j['activity'] as Map? ?? {}),
      ),
      nutrition: NutritionProfile.fromJson(
        Map<String, dynamic>.from(j['nutrition'] as Map? ?? {}),
      ),
      tolerance: ToleranceProfile.fromJson(
        Map<String, dynamic>.from(j['tolerance'] as Map? ?? {}),
      ),
      chronotype: ChronotypeProfile.fromJson(
        Map<String, dynamic>.from(j['chronotype'] as Map? ?? {}),
      ),
      daysOfData: (j['days'] as num?)?.toInt() ?? 0,
      ready: j['ready'] == true,
    );
  }

  static VireoFingerprint? load() {
    if (!HiveService.isInitialized) return null;
    final raw = HiveService.settingsBox.get(hiveKey);
    if (raw is! String || raw.isEmpty) return null;
    try {
      return VireoFingerprint.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.put(hiveKey, jsonEncode(toJson()));
  }

  static Future<void> reset() async {
    if (!HiveService.isInitialized) return;
    await HiveService.settingsBox.delete(hiveKey);
  }
}

/// Learn fingerprint from synthetic / real day samples.
abstract final class FingerprintLearner {
  static VireoFingerprint learn({
    required List<DayNutritionSample> days,
    required List<int> hourlyStepTotals, // length 24, aggregated
    required List<String> favoriteFoodIds,
    required List<({int deficit, bool nextDayRebound})> deficitHistory,
    List<int> mealLogHours = const [],
    double typicalCadenceSpm = 100,
    int longestWalkMinutes = 20,
  }) {
    final n = days.length;
    final conf = (n / VireoFingerprint.minDays).clamp(0.0, 1.0);
    final ready = n >= VireoFingerprint.minDays;

    final stepDays = days.map((d) => d.steps).where((s) => s > 0).toList()
      ..sort();
    final comfortable = stepDays.isEmpty
        ? 4000
        : _percentileBest70Median(stepDays);
    final peak = stepDays.isEmpty ? 8000 : _percentile(stepDays, 0.90);

    final hourScores = List<double>.filled(24, 0);
    for (var i = 0; i < math.min(24, hourlyStepTotals.length); i++) {
      hourScores[i] = hourlyStepTotals[i].toDouble();
    }
    final usualHours = _topHours(hourScores, 3);

    // Hard weekday = most surplus
    final surplusByDow = <int, List<int>>{};
    for (final d in days) {
      surplusByDow.putIfAbsent(d.date.weekday, () => []).add(d.intakeKcal - d.targetKcal);
    }
    var hardDay = 5;
    var hardAvg = -99999.0;
    surplusByDow.forEach((dow, list) {
      final avg = list.fold<double>(0, (s, e) => s + e) / list.length;
      if (avg > hardAvg) {
        hardAvg = avg;
        hardDay = dow;
      }
    });

    final adherence = days.isEmpty
        ? 0.0
        : days
                .where(
                  (d) =>
                      d.targetKcal > 0 &&
                      (d.intakeKcal - d.targetKcal).abs() <= d.targetKcal * 0.10,
                )
                .length /
            days.length;

    final mealCount = days.isEmpty
        ? 3
        : (days.map((d) => d.hasLog ? 3 : 0).fold<int>(0, (s, e) => s + e) /
                math.max(1, days.where((d) => d.hasLog).length))
            .round()
            .clamp(2, 5);

    // Tolerance: largest deficit without rebound next day
    var sustain = 400;
    for (final e in deficitHistory) {
      if (!e.nextDayRebound && e.deficit > sustain) {
        sustain = e.deficit;
      }
    }
    sustain = sustain.clamp(200, 1000);

    final logHour = mealLogHours.isEmpty
        ? 13
        : (mealLogHours.fold<int>(0, (s, e) => s + e) / mealLogHours.length)
            .round()
            .clamp(6, 23);

    return VireoFingerprint(
      activity: ActivityCapacity(
        comfortableSteps: comfortable,
        peakSteps: peak,
        usualHours: usualHours,
        typicalCadenceSpm: typicalCadenceSpm,
        longestWalkMinutes: longestWalkMinutes,
        confidence: conf,
      ),
      nutrition: NutritionProfile(
        typicalMealCount: mealCount,
        mealHourShares: {
          for (final h in mealLogHours) h: 1.0 / math.max(1, mealLogHours.length),
        },
        calorieShareByMeal: const {
          'breakfast': 0.25,
          'lunch': 0.40,
          'dinner': 0.35,
        },
        avgBreakfastProteinG: days.isEmpty
            ? 0
            : days.fold<double>(0, (s, d) => s + d.breakfastProteinG) /
                days.length,
        favoriteFoodIds: favoriteFoodIds.take(20).toList(),
        hardWeekday: hardDay,
        adherenceRatio: adherence,
        confidence: conf,
      ),
      tolerance: ToleranceProfile(
        sustainableDeficitKcal: sustain,
        confidence: conf,
      ),
      chronotype: ChronotypeProfile(
        typicalLogHour: logHour,
        usualWalkHours: usualHours,
        confidence: conf,
      ),
      daysOfData: n,
      ready: ready,
    );
  }

  /// Median of the best 70% of days.
  static int _percentileBest70Median(List<int> sortedAsc) {
    if (sortedAsc.isEmpty) return 4000;
    final cut = (sortedAsc.length * 0.30).floor();
    final best = sortedAsc.sublist(cut);
    return _percentile(best, 0.50);
  }

  static int _percentile(List<int> sortedAsc, double p) {
    if (sortedAsc.isEmpty) return 0;
    final idx = ((sortedAsc.length - 1) * p).round().clamp(0, sortedAsc.length - 1);
    return sortedAsc[idx];
  }

  static List<int> _topHours(List<double> scores, int n) {
    final indexed = List.generate(scores.length, (i) => MapEntry(i, scores[i]));
    indexed.sort((a, b) => b.value.compareTo(a.value));
    return indexed.take(n).map((e) => e.key).toList()..sort();
  }
}

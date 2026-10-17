import 'package:flutter/foundation.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';

/// Hourly step bucket from one source.
@immutable
class HourlyStepBucket {
  const HourlyStepBucket({
    required this.hourStart,
    required this.steps,
    required this.source,
    required this.coverageRatio,
  });

  final DateTime hourStart;
  final int steps;
  final StepSource source;

  /// 0–1 fraction of the hour covered by samples (1 = continuous).
  final double coverageRatio;
}

@immutable
class FusedStepsResult {
  const FusedStepsResult({
    required this.totalSteps,
    required this.source,
    required this.hourly,
  });

  final int totalSteps;
  final StepSource source;
  final List<HourlyStepBucket> hourly;
}

/// Fuse pedometer + Health Connect: de-dupe by hour, prefer fuller coverage,
/// never double-count.
abstract final class StepFusion {
  static FusedStepsResult fuseDay({
    required List<HourlyStepBucket> pedometerHours,
    required List<HourlyStepBucket> healthHours,
    int? pedometerDayTotal,
    int? healthDayTotal,
  }) {
    final byHour = <String, HourlyStepBucket>{};

    void consider(HourlyStepBucket b) {
      final key = _hourKey(b.hourStart);
      final existing = byHour[key];
      if (existing == null) {
        byHour[key] = b;
        return;
      }
      // Prefer higher coverage; tie-break by higher steps (more complete).
      if (b.coverageRatio > existing.coverageRatio + 0.05) {
        byHour[key] = b;
      } else if ((b.coverageRatio - existing.coverageRatio).abs() <= 0.05 &&
          b.steps > existing.steps) {
        byHour[key] = b;
      }
    }

    for (final h in pedometerHours) {
      consider(h);
    }
    for (final h in healthHours) {
      consider(h);
    }

    if (byHour.isEmpty) {
      // Day-level fallback: max without double count.
      final p = pedometerDayTotal ?? 0;
      final h = healthDayTotal ?? 0;
      if (p == 0 && h == 0) {
        return const FusedStepsResult(
          totalSteps: 0,
          source: StepSource.none,
          hourly: [],
        );
      }
      if (p >= h) {
        return FusedStepsResult(
          totalSteps: p,
          source: StepSource.pedometer,
          hourly: const [],
        );
      }
      return FusedStepsResult(
        totalSteps: h,
        source: StepSource.health,
        hourly: const [],
      );
    }

    final hourly = byHour.values.toList()
      ..sort((a, b) => a.hourStart.compareTo(b.hourStart));
    final total = hourly.fold<int>(0, (s, e) => s + e.steps);
    final pedoSum = hourly
        .where((e) => e.source == StepSource.pedometer)
        .fold<int>(0, (s, e) => s + e.steps);
    final healthSum = hourly
        .where((e) => e.source == StepSource.health)
        .fold<int>(0, (s, e) => s + e.steps);
    final source = pedoSum >= healthSum
        ? (pedoSum > 0 ? StepSource.pedometer : StepSource.health)
        : StepSource.health;

    return FusedStepsResult(
      totalSteps: total.clamp(0, 200000),
      source: source,
      hourly: List.unmodifiable(hourly),
    );
  }

  static String _hourKey(DateTime dt) =>
      '${dt.year}-${dt.month}-${dt.day}-${dt.hour}';
}

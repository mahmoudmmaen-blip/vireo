import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:vireo/data/models/progress_models.dart';

/// Exponential Moving Average smoothing with alpha = 0.1 for weight trend.
@immutable
class WeightTrendPoint {
  const WeightTrendPoint({
    required this.date,
    required this.rawWeightKg,
    required this.trendWeightKg,
  });

  final DateTime date;
  final double rawWeightKg;
  final double trendWeightKg;
}

@immutable
class WeightTrendAnalysis {
  const WeightTrendAnalysis({
    required this.points,
    required this.currentTrendKg,
    required this.change7DaysKg,
    required this.change30DaysKg,
  });

  final List<WeightTrendPoint> points;
  final double? currentTrendKg;
  final double? change7DaysKg;
  final double? change30DaysKg;

  bool get hasTrend => currentTrendKg != null && points.isNotEmpty;
}

abstract final class WeightTrendCalculator {
  /// Alpha parameter for Exponential Moving Average (EMA).
  static const double defaultAlpha = 0.1;

  /// Calculates EMA points from logs.
  /// Logs can be unordered; they will be sorted chronologically.
  static WeightTrendAnalysis compute(
    List<WeightLogEntry> rawLogs, {
    double alpha = defaultAlpha,
  }) {
    if (rawLogs.isEmpty) {
      return const WeightTrendAnalysis(
        points: [],
        currentTrendKg: null,
        change7DaysKg: null,
        change30DaysKg: null,
      );
    }

    final sorted = [...rawLogs]..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));

    final points = <WeightTrendPoint>[];
    double? ema;

    for (final log in sorted) {
      if (ema == null) {
        ema = log.weightKg;
      } else {
        ema = alpha * log.weightKg + (1 - alpha) * ema;
      }
      points.add(
        WeightTrendPoint(
          date: log.loggedAt,
          rawWeightKg: log.weightKg,
          trendWeightKg: ema,
        ),
      );
    }

    final currentTrend = points.last.trendWeightKg;
    final lastDate = points.last.date;

    // Change over 7 days: compare against trend point closest to (lastDate - 7 days)
    final change7 = _calculateChangeOverDays(points, lastDate, 7);
    // Change over 30 days: compare against trend point closest to (lastDate - 30 days)
    final change30 = _calculateChangeOverDays(points, lastDate, 30);

    return WeightTrendAnalysis(
      points: points,
      currentTrendKg: currentTrend,
      change7DaysKg: change7,
      change30DaysKg: change30,
    );
  }

  static double? _calculateChangeOverDays(
    List<WeightTrendPoint> points,
    DateTime anchorDate,
    int daysAgo,
  ) {
    if (points.length < 2) return null;
    final targetDate = anchorDate.subtract(Duration(days: daysAgo));

    // Must have at least one point on or before anchorDate - (daysAgo * 0.5) to be meaningful
    final earliest = points.first.date;
    if (anchorDate.difference(earliest).inDays < math.max(2, (daysAgo * 0.4).round())) {
      // Not enough time span to report meaningful 7-day or 30-day delta
      return null;
    }

    // Find point closest to targetDate
    WeightTrendPoint? bestPoint;
    Duration? bestDiff;

    for (final p in points) {
      final diff = p.date.difference(targetDate).abs();
      if (bestDiff == null || diff < bestDiff) {
        bestDiff = diff;
        bestPoint = p;
      }
    }

    if (bestPoint == null) return null;
    final delta = points.last.trendWeightKg - bestPoint.trendWeightKg;
    return double.parse(delta.toStringAsFixed(2));
  }
}

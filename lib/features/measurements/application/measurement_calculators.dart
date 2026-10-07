import 'dart:math' as math;

import 'package:vireo/features/measurements/domain/body_measurement.dart';
import 'package:vireo/features/measurements/domain/measurement_trend.dart';

abstract final class BodyFatCalculator {
  static const _cmPerInch = 2.54;

  /// US Navy body fat estimate. Returns null when inputs are insufficient.
  static double? calculateUsNavy({
    required double waistCm,
    required double heightCm,
    required bool isFemale,
    double? neckCm,
    double? hipCm,
  }) {
    if (waistCm <= 0 || heightCm <= 0) return null;

    final neck = neckCm ?? (heightCm * 0.19 + 9);
    final waistIn = waistCm / _cmPerInch;
    final neckIn = neck / _cmPerInch;
    final heightIn = heightCm / _cmPerInch;

    try {
      if (isFemale) {
        final hip = hipCm ?? waistCm * 1.15;
        final hipIn = hip / _cmPerInch;
        if (waistIn + hipIn <= neckIn) return null;
        final bf = 163.205 * math.log(waistIn + hipIn - neckIn) / math.ln10 -
            97.684 * math.log(heightIn) / math.ln10 -
            78.387;
        return bf.clamp(3.0, 60.0);
      }

      if (waistIn <= neckIn) return null;
      final bf = 86.010 * math.log(waistIn - neckIn) / math.ln10 -
          70.041 * math.log(heightIn) / math.ln10 +
          36.76;
      return bf.clamp(3.0, 60.0);
    } catch (_) {
      return null;
    }
  }

  static BodyMeasurement withAutoBodyFat(
    BodyMeasurement measurement, {
    required double heightCm,
    required bool isFemale,
    double? neckCm,
    double? hipCm,
  }) {
    if (measurement.bodyFatPercent != null || measurement.waistCm == null) {
      return measurement;
    }

    final bf = calculateUsNavy(
      waistCm: measurement.waistCm!,
      heightCm: heightCm,
      isFemale: isFemale,
      neckCm: neckCm,
      hipCm: hipCm ?? measurement.thighsCm,
    );

    if (bf == null) return measurement;
    return measurement.copyWith(bodyFatPercent: double.parse(bf.toStringAsFixed(1)));
  }
}

abstract final class MeasurementTrendCalculator {
  static MeasurementTrend fromWeights({
    required List<double> weightsKg,
    required bool deficitGoal,
  }) {
    if (weightsKg.length < 2) return MeasurementTrend.stable;

    final latest = weightsKg.first;
    final baseline = weightsKg.length >= 3 ? weightsKg[2] : weightsKg.last;
    final delta = latest - baseline;

    if (delta.abs() <= 0.5) return MeasurementTrend.stable;

    if (deficitGoal) {
      return delta < 0 ? MeasurementTrend.improving : MeasurementTrend.declining;
    }
    return delta > 0 ? MeasurementTrend.improving : MeasurementTrend.declining;
  }
}

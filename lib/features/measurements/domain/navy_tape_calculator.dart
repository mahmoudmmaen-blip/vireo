import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

enum BodyFatCategory {
  athletic,
  fit,
  average,
  high;

  String localizedKey() => switch (this) {
        BodyFatCategory.athletic => 'athletic',
        BodyFatCategory.fit => 'fit',
        BodyFatCategory.average => 'average',
        BodyFatCategory.high => 'high',
      };
}

@immutable
class NavyTapeResult {
  const NavyTapeResult({
    required this.bodyFatPercent,
    required this.fatMassKg,
    required this.leanMassKg,
    required this.bmi,
    required this.bmrKcal,
    required this.category,
    this.accuracyLabel = 'تقدير ±3–4%',
  });

  final double bodyFatPercent;
  final double fatMassKg;
  final double leanMassKg;
  final double bmi;
  final double bmrKcal;
  final BodyFatCategory category;
  final String accuracyLabel;

  BodyCompositionReport toReport({
    required double weightKg,
    DateTime? testDate,
  }) {
    return BodyCompositionReport(
      id: 'navy_${DateTime.now().millisecondsSinceEpoch}',
      testDate: testDate ?? DateTime.now(),
      deviceModel: 'US Navy Tape Method',
      source: BodyCompositionSource.navyTape,
      weightKg: weightKg,
      percentBodyFat: bodyFatPercent,
      bodyFatMassKg: fatMassKg,
      skeletalMuscleMassKg: leanMassKg,
      bmi: bmi,
      bmrKcal: bmrKcal,
      fieldConfidence: const {
        'percent_body_fat': 0.85,
        'body_fat_mass_kg': 0.85,
        'skeletal_muscle_mass_kg': 0.85,
        'bmi': 1.0,
        'bmr_kcal': 0.9,
      },
    );
  }
}

abstract final class NavyTapeMeasureCalculator {
  static const double cmPerInch = 2.54;

  /// Pure US Navy circumference formula calculation.
  ///
  /// Men:
  ///   BF% = 86.010 * log10(waist - neck) - 70.041 * log10(height) + 36.76
  ///
  /// Women:
  ///   BF% = 163.205 * log10(waist + hip - neck) - 97.684 * log10(height) - 78.387
  static NavyTapeResult? compute({
    required double waistCm,
    required double neckCm,
    required double heightCm,
    required double weightKg,
    required bool isFemale,
    double? hipCm,
    int age = 28,
  }) {
    if (waistCm <= 0 || neckCm <= 0 || heightCm <= 0 || weightKg <= 0) {
      return null;
    }

    final waistIn = waistCm / cmPerInch;
    final neckIn = neckCm / cmPerInch;
    final heightIn = heightCm / cmPerInch;

    double bf;
    try {
      if (isFemale) {
        final hip = hipCm ?? (waistCm * 1.15);
        if (hip <= 0) return null;
        final hipIn = hip / cmPerInch;
        final val = waistIn + hipIn - neckIn;
        if (val <= 0 || heightIn <= 0) return null;

        bf = 163.205 * (math.log(val) / math.ln10) -
            97.684 * (math.log(heightIn) / math.ln10) -
            78.387;
      } else {
        final val = waistIn - neckIn;
        if (val <= 0 || heightIn <= 0) return null;

        bf = 86.010 * (math.log(val) / math.ln10) -
            70.041 * (math.log(heightIn) / math.ln10) +
            36.76;
      }
    } catch (_) {
      return null;
    }

    final clampedBf = double.parse(bf.clamp(3.0, 60.0).toStringAsFixed(1));
    final fatMass = double.parse((weightKg * (clampedBf / 100.0)).toStringAsFixed(1));
    final leanMass = double.parse((weightKg - fatMass).clamp(20.0, 250.0).toStringAsFixed(1));
    final heightM = heightCm / 100.0;
    final bmi = double.parse((weightKg / (heightM * heightM)).toStringAsFixed(1));
    final bmr = double.parse((370.0 + 21.6 * leanMass).toStringAsFixed(0));

    final category = categorize(bodyFatPercent: clampedBf, isFemale: isFemale, age: age);

    return NavyTapeResult(
      bodyFatPercent: clampedBf,
      fatMassKg: fatMass,
      leanMassKg: leanMass,
      bmi: bmi,
      bmrKcal: bmr,
      category: category,
    );
  }

  static BodyFatCategory categorize({
    required double bodyFatPercent,
    required bool isFemale,
    int age = 28,
  }) {
    // Standard ACSM / ACE body fat categories adjusted for sex
    final ageOffset = age >= 40 ? 2.0 : 0.0;
    if (isFemale) {
      if (bodyFatPercent < 21.0 + ageOffset) return BodyFatCategory.athletic;
      if (bodyFatPercent < 25.0 + ageOffset) return BodyFatCategory.fit;
      if (bodyFatPercent < 32.0 + ageOffset) return BodyFatCategory.average;
      return BodyFatCategory.high;
    } else {
      if (bodyFatPercent < 14.0 + ageOffset) return BodyFatCategory.athletic;
      if (bodyFatPercent < 18.0 + ageOffset) return BodyFatCategory.fit;
      if (bodyFatPercent < 25.0 + ageOffset) return BodyFatCategory.average;
      return BodyFatCategory.high;
    }
  }
}

import 'package:flutter/foundation.dart';

/// "أكلنا من طبق واحد" → "نصيبي: ربع / تلت / نص" (P40 §1, family plate).
///
/// Used for shared dishes (koshari, mahshi, kabsa, molokhia): the scan sees
/// the WHOLE dish, the user only ate a share of it.
enum FamilyPlateShare {
  quarter(1, 4),
  third(1, 3),
  half(1, 2);

  const FamilyPlateShare(this.numerator, this.denominator);

  final int numerator;
  final int denominator;

  /// Fraction of the dish eaten, in (0, 1].
  double get fraction => numerator / denominator;

  /// Egyptian Arabic chip label ("ربع / تلت / نص").
  String get labelAr => switch (this) {
        FamilyPlateShare.quarter => 'ربع',
        FamilyPlateShare.third => 'تلت',
        FamilyPlateShare.half => 'نص',
      };

  /// Unicode fraction used next to the label (¼ / ⅓ / ½).
  String get glyph => switch (this) {
        FamilyPlateShare.quarter => '¼',
        FamilyPlateShare.third => '⅓',
        FamilyPlateShare.half => '½',
      };

  /// Finds the preset closest to [value]; null if [value] matches none
  /// within [tolerance].
  static FamilyPlateShare? fromFraction(double value, {double tolerance = 0.005}) {
    for (final s in FamilyPlateShare.values) {
      if ((s.fraction - value).abs() <= tolerance) return s;
    }
    return null;
  }
}

/// Clamps [share] into the valid range (0, 1]. NaN / non-positive → 1 (no scaling,
/// so a bad input never silently zeroes a meal).
@visibleForTesting
double normalizeShare(double share) {
  if (share.isNaN || share <= 0) return 1;
  if (share > 1) return 1;
  return share;
}

/// Calories the user actually ate from a shared dish.
///
/// [totalKcal] is the whole dish; [share] is the eaten fraction
/// (e.g. `FamilyPlateShare.third.fraction`). Negative / NaN totals → 0.
double scaleMealKcal({required double totalKcal, required double share}) {
  if (totalKcal.isNaN || totalKcal <= 0) return 0;
  return totalKcal * normalizeShare(share);
}

/// Grams the user actually ate from a shared dish (same rules as [scaleMealKcal]).
double scaleGrams({required double totalGrams, required double share}) {
  if (totalGrams.isNaN || totalGrams <= 0) return 0;
  return totalGrams * normalizeShare(share);
}

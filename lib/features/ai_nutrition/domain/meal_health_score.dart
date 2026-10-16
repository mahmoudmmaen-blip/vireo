import 'package:flutter/foundation.dart';

/// Aggregated nutrient snapshot of one meal (all lines summed).
///
/// Optional micronutrients (`fiberG`, `sugarG`, `sodiumMg`) are `null` when the
/// source data does not carry them. A `null` value is never penalised or
/// rewarded: the scorer simply skips that rule (no fake numbers).
@immutable
class MealNutrientSnapshot {
  const MealNutrientSnapshot({
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.fiberG,
    this.sugarG,
    this.sodiumMg,
    this.oilGrams = 0,
    this.vegGrams = 0,
    required this.totalFoodGrams,
    this.isFried = false,
  });

  final double kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double? fiberG;

  /// Added sugar in grams (null = unknown).
  final double? sugarG;

  /// Sodium in milligrams (null = unknown).
  final double? sodiumMg;

  /// Cooking / added oil (oil, ghee, butter) in grams.
  final double oilGrams;

  /// Vegetables (cooked or raw, excluding potatoes) in grams.
  final double vegGrams;

  /// Total weight of all food on the plate in grams.
  final double totalFoodGrams;

  /// True when any main item is deep/pan fried.
  final bool isFried;
}

/// Result: integer 1–10 plus a short reason in Egyptian Arabic and English.
@immutable
class MealHealthScore {
  const MealHealthScore({
    required this.score,
    required this.reasonAr,
    required this.reasonEn,
  });

  final int score;
  final String reasonAr;
  final String reasonEn;
}

/// Deterministic meal health scorer. Same input → same output, no randomness.
///
/// Rules (applied additively, then clamped to 1–10):
///
/// * Start at **7**.
/// * Protein density (g protein per 100 kcal): `>= 12` → +2, `>= 8` → +1,
///   `< 4` → −1.
/// * Fiber (g): `>= 8` → +2, `>= 5` → +1, `< 2` and kcal > 300 → −1.
///   (skipped when fiber is unknown)
/// * Sugar (g): `> 25` → −2, `> 15` → −1. (skipped when unknown)
/// * Sodium (mg): `> 1500` → −2, `> 800` → −1. (skipped when unknown)
/// * Oil / fried: oil share = oilGrams / totalFoodGrams.
///   `> 0.15` → −2; `> 0.08` or `isFried` → −1.
/// * Vegetable share = vegGrams / totalFoodGrams: `>= 0.4` → +2, `>= 0.25` → +1.
///
/// The reason text explains the dominant factor: if the net adjustment is
/// negative the most negative factor, if positive the most positive one,
/// otherwise the factor with the largest absolute effect (or a "balanced" line).
class MealHealthScorer {
  const MealHealthScorer._();

  static const int baseScore = 7;

  static MealHealthScore score(MealNutrientSnapshot m) {
    final factors = <_Factor>[];

    // Protein density
    if (m.kcal > 0) {
      final density = m.proteinG * 100 / m.kcal;
      if (density >= 12) {
        factors.add(_Factor.protein(2, positive: true));
      } else if (density >= 8) {
        factors.add(_Factor.protein(1, positive: true));
      } else if (density < 4) {
        factors.add(_Factor.protein(-1, positive: false));
      }
    }

    // Fiber
    final fiber = m.fiberG;
    if (fiber != null) {
      if (fiber >= 8) {
        factors.add(_Factor.fiber(2));
      } else if (fiber >= 5) {
        factors.add(_Factor.fiber(1));
      } else if (fiber < 2 && m.kcal > 300) {
        factors.add(_Factor.fiber(-1));
      }
    }

    // Added sugar
    final sugar = m.sugarG;
    if (sugar != null) {
      if (sugar > 25) {
        factors.add(_Factor.sugar(-2));
      } else if (sugar > 15) {
        factors.add(_Factor.sugar(-1));
      }
    }

    // Sodium
    final sodium = m.sodiumMg;
    if (sodium != null) {
      if (sodium > 1500) {
        factors.add(_Factor.sodium(-2));
      } else if (sodium > 800) {
        factors.add(_Factor.sodium(-1));
      }
    }

    // Oil / fried
    final total = m.totalFoodGrams;
    final oilShare = total > 0 ? m.oilGrams / total : 0.0;
    if (oilShare > 0.15) {
      factors.add(_Factor.oil(-2));
    } else if (oilShare > 0.08 || m.isFried) {
      factors.add(_Factor.oil(-1, fried: m.isFried && oilShare <= 0.08));
    }

    // Vegetables
    final vegShare = total > 0 ? m.vegGrams / total : 0.0;
    if (vegShare >= 0.4) {
      factors.add(_Factor.veg(2));
    } else if (vegShare >= 0.25) {
      factors.add(_Factor.veg(1));
    }

    final delta = factors.fold<int>(0, (s, f) => s + f.delta);
    final result = (baseScore + delta).clamp(1, 10);

    _Factor? dominant;
    if (factors.isNotEmpty) {
      // Stable: first factor wins ties (list order is fixed above).
      bool better(_Factor a, _Factor b) {
        if (delta < 0) return a.delta < b.delta;
        if (delta > 0) return a.delta > b.delta;
        return a.delta.abs() > b.delta.abs();
      }

      var d = factors.first;
      for (final f in factors.skip(1)) {
        if (better(f, d)) d = f;
      }
      dominant = d;
    }

    if (dominant == null) {
      return MealHealthScore(
        score: result,
        reasonAr: 'وجبة معتدلة ومتوازنة',
        reasonEn: 'A moderate, balanced meal',
      );
    }
    return MealHealthScore(
      score: result,
      reasonAr: dominant.reasonAr,
      reasonEn: dominant.reasonEn,
    );
  }
}

class _Factor {
  const _Factor(this.delta, this.reasonAr, this.reasonEn);

  final int delta;
  final String reasonAr;
  final String reasonEn;

  factory _Factor.protein(int delta, {required bool positive}) => positive
      ? _Factor(
          delta,
          'بروتين عالي بالنسبة للسعرات، ممتاز للشبع',
          'High protein for the calories, great for fullness',
        )
      : _Factor(
          delta,
          'البروتين قليل بالنسبة للسعرات، زوّد بروتين',
          'Low protein for the calories, add some protein',
        );

  factory _Factor.fiber(int delta) => delta > 0
      ? _Factor(
          delta,
          'ألياف كويسة بتساعد الهضم والشبع',
          'Good fiber for digestion and fullness',
        )
      : _Factor(
          delta,
          'الألياف قليلة، زوّد خضار أو بقوليات',
          'Low fiber, add veggies or legumes',
        );

  factory _Factor.sugar(int delta) => _Factor(
        delta,
        'السكر عالي في الوجبة، خفّفه شوية',
        'Sugar is high in this meal, ease it a bit',
      );

  factory _Factor.sodium(int delta) => _Factor(
        delta,
        'الصوديوم (الملح) عالي، قلل المخلل والصلصات',
        'Sodium (salt) is high, go easy on pickles and sauces',
      );

  factory _Factor.oil(int delta, {bool fried = false}) => fried
      ? _Factor(
          delta,
          'الوجبة فيها تحمير، الشوي أو الفرن أخف',
          'The meal is fried, grilling or baking is lighter',
        )
      : _Factor(
          delta,
          'نسبة الزيت أو الدهون المضافة عالية',
          'High share of added oil or fat',
        );

  factory _Factor.veg(int delta) => _Factor(
        delta,
        'خضار كتير في الطبق، اختيار شاطر',
        'Plenty of vegetables on the plate, great choice',
      );
}

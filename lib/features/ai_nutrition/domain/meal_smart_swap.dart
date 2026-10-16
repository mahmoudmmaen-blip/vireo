import 'package:flutter/foundation.dart';

/// One meal line used to find a swap (name + macros for the actual grams).
@immutable
class SwapCandidateLine {
  const SwapCandidateLine({
    required this.nameAr,
    required this.nameEn,
    required this.grams,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String nameAr;
  final String nameEn;
  final double grams;
  final double kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
}

/// A single, concrete swap suggestion with the savings it brings.
@immutable
class SmartSwapTip {
  const SmartSwapTip({
    required this.tipAr,
    required this.tipEn,
    required this.savedKcal,
    this.savedFatG,
  });

  final String tipAr;
  final String tipEn;
  final int savedKcal;
  final double? savedFatG;
}

/// Rule-based swap picker. Deterministic; the highest-saving matching rule wins
/// (ties resolved by rule order below). Returns null when no rule matches.
///
/// Rules (names matched case-insensitively in Arabic and English):
/// 1. Chicken with skin → remove the skin. Skin is estimated from the
///    reference portion of ~150 g chicken ≈ 100 kcal and 8 g fat of skin
///    (≈ 0.667 kcal/g and 0.0533 g fat/g), scaled by grams and capped by the
///    line's own kcal (40 %) and fat.
/// 2. Rice ≥ 200 g → halve the portion: saves kcal/2 and fat/2 of the line.
/// 3. Fried → grill/bake: ~30 % of the line's fat calories (fat g × 9 × 0.3).
/// 4. White bread → baladi/brown bread (fiber gain, no kcal claim → 0).
/// 5. Soda / juice → water: saves the line's full kcal.
class MealSmartSwap {
  const MealSmartSwap._();

  static SmartSwapTip? pick(List<SwapCandidateLine> lines) {
    SmartSwapTip? best;
    for (final line in lines) {
      for (final tip in _tipsFor(line)) {
        if (best == null || tip.savedKcal > best.savedKcal) best = tip;
      }
    }
    return best;
  }

  static List<SmartSwapTip> _tipsFor(SwapCandidateLine l) {
    final n = _norm('${l.nameAr} ${l.nameEn}');
    final tips = <SmartSwapTip>[];

    // 1) Chicken with skin
    final isChicken = _any(n, ['chicken', 'فراخ', 'دجاج']);
    final hasSkin = _any(n, ['with skin', 'skin-on', 'skin on', 'جلد']) &&
        !_any(n, ['skinless', 'without skin', 'no skin', 'بدون جلد', 'منزوع', 'من غير جلد']);
    if (isChicken && hasSkin && l.grams > 0) {
      var kcal = l.grams * (100 / 150);
      var fat = l.grams * (8 / 150);
      if (l.kcal > 0) kcal = kcal.clamp(0, l.kcal * 0.4).toDouble();
      if (l.fatG > 0) fat = fat.clamp(0, l.fatG).toDouble();
      final k = kcal.round();
      if (k > 0) {
        final f = _round1(fat);
        tips.add(SmartSwapTip(
          tipAr: 'شيل جلد الفراخ وهتوفر حوالي $k سعرة و${_fmt(f)} جم دهون',
          tipEn: 'Remove the chicken skin to save about $k kcal and ${_fmt(f)} g fat',
          savedKcal: k,
          savedFatG: f,
        ));
      }
    }

    // 2) Big rice portion
    final isRice = _word(n, ['rice', 'رز', 'ارز']) && !_any(n, ['pudding', 'بالبن', 'مهلبيه', 'مهلبية']);
    if (isRice && l.grams >= 200 && l.kcal > 0) {
      final k = (l.kcal / 2).round();
      final f = l.fatG > 0 ? _round1(l.fatG / 2) : null;
      tips.add(SmartSwapTip(
        tipAr: 'قلل الرز للنص (${(l.grams / 2).round()} جم) وهتوفر حوالي $k سعرة',
        tipEn: 'Halve the rice (${(l.grams / 2).round()} g) to save about $k kcal',
        savedKcal: k,
        savedFatG: f,
      ));
    }

    // 3) Fried → grilled / baked
    final isFried = _any(n, ['fried', 'مقلي', 'مقليه', 'مقلية']) &&
        !_any(n, ['air fried', 'air-fried', 'airfried', 'هوائي']);
    if (isFried && l.fatG > 0) {
      final fat = _round1(l.fatG * 0.3);
      final k = (l.fatG * 9 * 0.3).round();
      if (k >= 10) {
        tips.add(SmartSwapTip(
          tipAr: 'جرّب مشوي أو في الفرن بدل المقلي وهتوفر حوالي $k سعرة',
          tipEn: 'Grill or bake instead of frying to save about $k kcal',
          savedKcal: k,
          savedFatG: fat,
        ));
      }
    }

    // 4) White bread → baladi / brown
    if (_any(n, ['white bread', 'عيش ابيض', 'عيش فينو', 'خبز ابيض'])) {
      tips.add(const SmartSwapTip(
        tipAr: 'بدل العيش الأبيض جرّب العيش البلدي أو الأسمر، ألياف أكتر وشبع أطول',
        tipEn: 'Swap white bread for baladi or brown bread for more fiber and fullness',
        savedKcal: 0,
      ));
    }

    // 5) Soda / juice → water
    final isSugarDrink = _word(n, ['soda', 'cola', 'pepsi', 'صودا', 'كولا', 'بيبسي']) ||
        _any(n, ['juice', 'soft drink', 'عصير', 'مياه غازيه', 'مشروب غازي']);
    if (isSugarDrink && l.kcal >= 40) {
      final k = l.kcal.round();
      tips.add(SmartSwapTip(
        tipAr: 'استبدل المشروب بمياه أو مياه فوارة وهتوفر $k سعرة',
        tipEn: 'Swap the drink for water to save $k kcal',
        savedKcal: k,
        savedFatG: l.fatG > 0 ? _round1(l.fatG) : null,
      ));
    }

    return tips;
  }

  /// Lowercase + unify Arabic letter variants so matching is forgiving.
  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه');

  static bool _any(String haystack, List<String> needles) {
    for (final needle in needles) {
      if (haystack.contains(_norm(needle))) return true;
    }
    return false;
  }

  /// Whole-word match (allows common Arabic prefixes like ال / بال / و) so
  /// short tokens such as "رز" do not match inside "كرز" and "cola" does not
  /// match inside "chocolate".
  static bool _word(String haystack, List<String> words) {
    for (final w in words) {
      final re = RegExp(
        '(^|[^\\p{L}])(?:[وبلف]?ال|[وبلف])?${RegExp.escape(_norm(w))}(\$|[^\\p{L}])',
        unicode: true,
      );
      if (re.hasMatch(haystack)) return true;
    }
    return false;
  }

  static double _round1(double v) => (v * 10).round() / 10;

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toStringAsFixed(1);
}

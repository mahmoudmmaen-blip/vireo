import 'package:flutter/foundation.dart';

/// Supported household units in Vireo ("مقاييس البيت").
enum HouseholdUnitId {
  cup('cup', 'كوب', 'Cup', '🥛'),
  halfCup('half_cup', 'نص كوب', '1/2 Cup', '🥛'),
  tablespoon('tbsp', 'ملعقة كبيرة', 'Tablespoon', '🥄'),
  teaspoon('tsp', 'ملعقة صغيرة', 'Teaspoon', '🥄'),
  palm('palm', 'كف اليد', 'Palm', '✋'),
  fist('fist', 'قبضة اليد', 'Fist', '✊'),
  cuppedHand('cupped_hand', 'حفنة', 'Cupped hand', '🤲'),
  thumb('thumb', 'إبهام', 'Thumb', '👍'),
  baladiLoaf('baladi_loaf', 'رغيف بلدي', 'Baladi loaf', '🫓'),
  halfBaladiLoaf('half_baladi_loaf', 'نص رغيف', '1/2 Baladi loaf', '🫓'),
  kosharySmall('koshary_small', 'طبق كشري صغير', 'Small koshary', '🍲'),
  kosharyMedium('koshary_med', 'طبق كشري وسط', 'Medium koshary', '🍲'),
  kosharyLarge('koshary_large', 'طبق كشري كبير', 'Large koshary', '🍲'),
  piece('piece', 'قطعة / حبة', 'Piece', '🥚'),
  grams('grams', 'جم', 'g', '⚖️');

  const HouseholdUnitId(this.id, this.labelAr, this.labelEn, this.emoji);

  final String id;
  final String labelAr;
  final String labelEn;
  final String emoji;

  String label(bool isArabic) => isArabic ? labelAr : labelEn;

  static HouseholdUnitId fromId(String? raw) {
    if (raw == null) return HouseholdUnitId.grams;
    for (final u in HouseholdUnitId.values) {
      if (u.id == raw || u.name == raw) return u;
    }
    return HouseholdUnitId.grams;
  }
}

/// A specific household unit with its base gram equivalent.
@immutable
class HouseholdUnitPortion {
  const HouseholdUnitPortion({
    required this.unitId,
    required this.baseGrams,
    this.customLabelAr,
    this.customLabelEn,
  });

  final HouseholdUnitId unitId;
  final double baseGrams;
  final String? customLabelAr;
  final String? customLabelEn;

  factory HouseholdUnitPortion.fromJson(Map<String, dynamic> json) {
    final rawUnit = json['unit_id']?.toString() ?? json['unit']?.toString();
    final grams = (json['grams'] as num?)?.toDouble() ?? 100.0;
    return HouseholdUnitPortion(
      unitId: HouseholdUnitId.fromId(rawUnit),
      baseGrams: grams,
      customLabelAr: json['label_ar']?.toString(),
      customLabelEn: json['label_en']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'unit_id': unitId.id,
        'grams': baseGrams,
        if (customLabelAr != null) 'label_ar': customLabelAr,
        if (customLabelEn != null) 'label_en': customLabelEn,
      };

  String label(bool isArabic) {
    if (isArabic && customLabelAr != null) return customLabelAr!;
    if (!isArabic && customLabelEn != null) return customLabelEn!;
    return unitId.label(isArabic);
  }

  /// Scales base grams by cup size calibration factor (default cup = 240ml).
  double gramsWithCupCalibration(int cupSizeMl) {
    if (unitId == HouseholdUnitId.cup || unitId == HouseholdUnitId.halfCup) {
      final ratio = cupSizeMl / 240.0;
      return baseGrams * ratio;
    }
    return baseGrams;
  }
}

/// Household portion converter & catalog defaults.
abstract final class HouseholdMeasures {
  /// Default standard cup in ml
  static const int standardCupMl = 240;

  /// Quantity steps for the portion picker: ¼, ½, 1, 1½, 2, 2½, 3...
  static const List<double> quantitySteps = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    2.0,
    2.5,
    3.0,
    4.0,
    5.0,
  ];

  /// Format a multiplier into Arabic / English fractions
  static String formatQuantity(double qty, bool isArabic) {
    if (qty == 0.25) return isArabic ? '¼' : '1/4';
    if (qty == 0.5) return isArabic ? '½' : '1/2';
    if (qty == 0.75) return isArabic ? '¾' : '3/4';
    if (qty == 1.0) return isArabic ? '1' : '1';
    if (qty == 1.25) return isArabic ? '1 ¼' : '1 1/4';
    if (qty == 1.5) return isArabic ? '1 ½' : '1 1/2';
    if (qty == 2.0) return isArabic ? '2' : '2';
    if (qty == 2.5) return isArabic ? '2 ½' : '2 1/2';
    if (qty == 3.0) return isArabic ? '3' : '3';
    if (qty == qty.roundToDouble()) return '${qty.toInt()}';
    return qty.toStringAsFixed(1);
  }

  /// Infers default household units for a food based on its name/category.
  static List<HouseholdUnitPortion> getUnitsForFood({
    required String nameAr,
    required String nameEn,
    List<HouseholdUnitPortion>? explicitUnits,
  }) {
    if (explicitUnits != null && explicitUnits.isNotEmpty) {
      return explicitUnits;
    }

    final lower = '$nameEn $nameAr'.toLowerCase();

    // 1. Grains / Rice / Pasta / Cooked beans (كوب، نص كوب، قبضة، ملعقة)
    if (lower.contains('rice') || lower.contains('رز') || lower.contains('أرز')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.cup, baseGrams: 160),
        HouseholdUnitPortion(unitId: HouseholdUnitId.halfCup, baseGrams: 80),
        HouseholdUnitPortion(unitId: HouseholdUnitId.fist, baseGrams: 160),
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 25),
      ];
    }

    if (lower.contains('pasta') || lower.contains('مكرونة') || lower.contains('مكرونه')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.cup, baseGrams: 140),
        HouseholdUnitPortion(unitId: HouseholdUnitId.halfCup, baseGrams: 70),
        HouseholdUnitPortion(unitId: HouseholdUnitId.fist, baseGrams: 140),
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 25),
      ];
    }

    if (lower.contains('milk') || lower.contains('لبن') || lower.contains('حليب') || lower.contains('زبادي')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.cup, baseGrams: 245),
        HouseholdUnitPortion(unitId: HouseholdUnitId.halfCup, baseGrams: 122),
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 15),
      ];
    }

    if (lower.contains('bean') || lower.contains('فول') || lower.contains('عدس') || lower.contains('لوبيا') || lower.contains('حمص')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.cup, baseGrams: 170),
        HouseholdUnitPortion(unitId: HouseholdUnitId.halfCup, baseGrams: 85),
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 30),
      ];
    }

    // 2. Oils, fats, tahini, sugar, honey (ملعقة كبيرة، ملعقة صغيرة، إبهام)
    if (lower.contains('oil') || lower.contains('زيت') || lower.contains('سمن') || lower.contains('ghee') || lower.contains('butter') || lower.contains('زبد')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 13.5),
        HouseholdUnitPortion(unitId: HouseholdUnitId.teaspoon, baseGrams: 4.5),
        HouseholdUnitPortion(unitId: HouseholdUnitId.thumb, baseGrams: 14.0),
      ];
    }

    if (lower.contains('tahina') || lower.contains('tahini') || lower.contains('طحينة') || lower.contains('طحينه')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 15.0),
        HouseholdUnitPortion(unitId: HouseholdUnitId.teaspoon, baseGrams: 5.0),
      ];
    }

    if (lower.contains('sugar') || lower.contains('سكر')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 12.5),
        HouseholdUnitPortion(unitId: HouseholdUnitId.teaspoon, baseGrams: 4.0),
      ];
    }

    if (lower.contains('honey') || lower.contains('عسل')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 21.0),
        HouseholdUnitPortion(unitId: HouseholdUnitId.teaspoon, baseGrams: 7.0),
      ];
    }

    // 3. Meats / Chicken / Fish (كف اليد ≈ 100-120 جم cooked, قطعة)
    if (lower.contains('chicken') || lower.contains('فراخ') || lower.contains('دجاج')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.palm, baseGrams: 110, customLabelAr: 'كف اليد (صدر)', customLabelEn: 'Palm (breast)'),
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 150, customLabelAr: 'ورك كامل', customLabelEn: 'Whole thigh'),
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 180, customLabelAr: 'صدر كامل', customLabelEn: 'Whole breast'),
      ];
    }

    if (lower.contains('meat') || lower.contains('لحم') || lower.contains('لحمة') || lower.contains('كفتة') || lower.contains('kofta') || lower.contains('steak')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.palm, baseGrams: 110, customLabelAr: 'كف اليد (قطعة لحم)', customLabelEn: 'Palm (meat slice)'),
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 45, customLabelAr: 'صابع كفتة', customLabelEn: 'Kofta finger'),
      ];
    }

    if (lower.contains('fish') || lower.contains('سمك') || lower.contains('جمبري') || lower.contains('shrimp') || lower.contains('salmon') || lower.contains('تونا') || lower.contains('tuna')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.palm, baseGrams: 120, customLabelAr: 'كف اليد (فيليه/سمكة)', customLabelEn: 'Palm (fillet)'),
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 140, customLabelAr: 'علبة تونة مصفاة', customLabelEn: 'Drained tuna can'),
      ];
    }

    // 4. Nuts & Seeds (حفنة ≈ 28-30 جم)
    if (lower.contains('nut') || lower.contains('مكسرات') || lower.contains('لوز') || lower.contains('فول سوداني') || lower.contains('peanut') || lower.contains('لب') || lower.contains('بزر') || lower.contains('seeds')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.cuppedHand, baseGrams: 28),
        HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 15),
      ];
    }

    // 5. Bread (رغيف بلدي 90-100 جم، نص رغيف)
    if (lower.contains('bread') || lower.contains('عيش') || lower.contains('خبز')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.baladiLoaf, baseGrams: 90),
        HouseholdUnitPortion(unitId: HouseholdUnitId.halfBaladiLoaf, baseGrams: 45),
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 30, customLabelAr: 'شريحة توست', customLabelEn: 'Toast slice'),
      ];
    }

    // 6. Koshary (طبق صغير / وسط / كبير)
    if (lower.contains('koshary') || lower.contains('كشري')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.kosharySmall, baseGrams: 300),
        HouseholdUnitPortion(unitId: HouseholdUnitId.kosharyMedium, baseGrams: 450),
        HouseholdUnitPortion(unitId: HouseholdUnitId.kosharyLarge, baseGrams: 650),
      ];
    }

    // 7. Piece / Unit (egg 50g, ta'ameya 30g, date 8g)
    if (lower.contains('egg') || lower.contains('بيض')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 50, customLabelAr: 'بيضة واحدة', customLabelEn: '1 Egg'),
      ];
    }

    if (lower.contains('taameya') || lower.contains('طعمية') || lower.contains('falafel') || lower.contains('فلافل')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 30, customLabelAr: 'قرص طعمية', customLabelEn: '1 Falafel piece'),
      ];
    }

    if (lower.contains('date') || lower.contains('تمر') || lower.contains('بلح')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 8, customLabelAr: 'حبة تمر', customLabelEn: '1 Date'),
      ];
    }

    // 8. Fruit & Veggies (قبضة اليد ≈ 1 cup, كوب)
    if (lower.contains('apple') || lower.contains('تفاح') || lower.contains('banana') || lower.contains('موز') || lower.contains('orange') || lower.contains('برتقال') || lower.contains('fruit') || lower.contains('فاكهة')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.fist, baseGrams: 150, customLabelAr: 'قد قبضة إيدك (حبة وسط)', customLabelEn: 'Fist (medium fruit)'),
        HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 120),
      ];
    }

    if (lower.contains('salad') || lower.contains('سلطة') || lower.contains('خضار')) {
      return const [
        HouseholdUnitPortion(unitId: HouseholdUnitId.cup, baseGrams: 100, customLabelAr: 'كوب سلطة', customLabelEn: '1 Cup salad'),
        HouseholdUnitPortion(unitId: HouseholdUnitId.fist, baseGrams: 100),
      ];
    }

    // Generic fallback: Palm (100g), Cup (150g), Tbsp (20g)
    return const [
      HouseholdUnitPortion(unitId: HouseholdUnitId.palm, baseGrams: 100),
      HouseholdUnitPortion(unitId: HouseholdUnitId.cup, baseGrams: 150),
      HouseholdUnitPortion(unitId: HouseholdUnitId.tablespoon, baseGrams: 20),
      HouseholdUnitPortion(unitId: HouseholdUnitId.piece, baseGrams: 50),
    ];
  }

  /// Convert selected unit + quantity into final grams, taking cupSize into account.
  static double computeGrams({
    required HouseholdUnitPortion portion,
    required double quantity,
    int cupSizeMl = standardCupMl,
  }) {
    final calibratedBase = portion.gramsWithCupCalibration(cupSizeMl);
    return (calibratedBase * quantity).roundToDouble();
  }

  /// Create a readable description with household measures, e.g. "صدر فراخ مشوي (قد كف إيدك)"
  static String describeItem({
    required String nameAr,
    required String nameEn,
    required double grams,
    required bool isArabic,
    int cupSizeMl = standardCupMl,
  }) {
    final units = getUnitsForFood(nameAr: nameAr, nameEn: nameEn);
    if (units.isEmpty) {
      return '$nameAr (${grams.round()} ${isArabic ? 'جم' : 'g'})';
    }

    // Find the closest unit and quantity
    HouseholdUnitPortion? bestPortion;
    double bestQty = 1.0;
    double bestDiff = double.infinity;

    for (final u in units) {
      final baseG = u.gramsWithCupCalibration(cupSizeMl);
      for (final step in quantitySteps) {
        final calcG = baseG * step;
        final diff = (calcG - grams).abs();
        if (diff < bestDiff) {
          bestDiff = diff;
          bestPortion = u;
          bestQty = step;
        }
      }
    }

    final name = isArabic ? nameAr : (nameEn.isNotEmpty ? nameEn : nameAr);
    if (bestPortion != null && bestDiff <= grams * 0.25) {
      final unitName = bestPortion.label(isArabic);
      final qtyStr = formatQuantity(bestQty, isArabic);
      final measureStr = bestQty == 1.0 ? unitName : '$qtyStr $unitName';
      return '$name ($measureStr)';
    }

    return '$name (${grams.round()} ${isArabic ? 'جم' : 'g'})';
  }
}

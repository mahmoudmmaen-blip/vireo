// Accuracy bench engine — P35b round 2.
//
// The engine functions were extracted verbatim from run_bench.dart so the
// benchmark logic is unit-testable. Tuning must only ever use the TUNING
// split; the HELD-OUT split is a test set fixed before any round-2 change.
library;

String normalizeText(String text) {
  var t = text.toLowerCase().trim();
  // Strip Arabic diacritics
  t = t.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  t = t.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
  t = t.replaceAll('ة', 'ه');
  t = t.replaceAll(RegExp(r'[ىئ]'), 'ي');
  t = t.replaceAll(RegExp(r'[^\w\u0600-\u06FF]+'), ' ');
  return t.trim();
}

/// True when [word] appears as a whole whitespace-delimited token in the
/// normalized text. Guards against substring collisions like كفته→فته,
/// سكوب→كوب, بيضاء→بيض, زيت الزيتون→زيتون.
bool hasWord(String norm, String word) {
  if (norm == word) return true;
  if (norm.startsWith('$word ')) return true;
  if (norm.endsWith(' $word')) return true;
  return norm.contains(' $word ');
}

Map<String, dynamic>? matchInPool(List<Map<String, dynamic>> pool, String query) {
  final q = normalizeText(query);
  if (q.isEmpty) return null;
  final qWords = q.split(' ').where((w) => w.isNotEmpty).toSet();
  Map<String, dynamic>? best;
  var bestScore = 0.0;

  for (final f in pool) {
    final candidates = <String>[
      f['id'] as String,
      f['name_ar'] as String? ?? '',
      f['name_en'] as String? ?? '',
      ...((f['aliases'] as List?)?.cast<String>() ?? const <String>[]),
    ];

    for (final c in candidates) {
      final cn = normalizeText(c);
      if (cn.isEmpty) continue;
      if (q == cn) return f;
      final cWords = cn.split(' ').where((w) => w.isNotEmpty).toSet();

      if (cn.contains(q) || q.contains(cn)) {
        final score = cn.length / (q.length + 1);
        if (score > bestScore) {
          bestScore = score;
          best = f;
        }
      } else {
        final inter = qWords.intersection(cWords).length;
        if (inter > 0) {
          final maxLen = qWords.length > cWords.length ? qWords.length : cWords.length;
          final score = inter / maxLen;
          if (score > 0.35 && score > bestScore) {
            bestScore = score;
            best = f;
          }
        }
      }
    }
  }
  return best;
}

(Map<String, dynamic>?, String) matchFood(
  String query,
  List<Map<String, dynamic>> egFoods,
  List<Map<String, dynamic>> usdaFoods,
) {
  final hitEg = matchInPool(egFoods, query);
  if (hitEg != null) return (hitEg, 'egyptian_db');

  final hitUsda = matchInPool(usdaFoods, query);
  if (hitUsda != null) return (hitUsda, 'usda');

  return (null, 'fallback');
}

(String, double) parsePortionAndName(String text) {
  final raw = text.trim();
  final norm = normalizeText(raw);
  var g = 150.0;

  if (norm.contains('كشري وسط')) {
    g = 400.0;
  } else if (norm.contains('كشري كبير')) {
    g = 600.0;
  } else if (norm.contains('كشري صغير') || norm.contains('كشري اصفر')) {
    g = 300.0;
  } else if (norm.contains('مكرونه بشاميل')) {
    g = 280.0;
  } else if (norm.contains('بسبوسه')) {
    g = 80.0;
  } else if (norm.contains('كنافه')) {
    g = 100.0;
  } else if (norm.contains('ام علي')) {
    g = 200.0;
  } else if (norm.contains('حواوشي')) {
    g = 210.0;
  } else if (hasWord(norm, 'فته')) {
    g = 320.0;
  } else if (norm.contains('مسقعه')) {
    g = 250.0;
  } else if (norm.contains('كوارع')) {
    g = 280.0;
  } else if (norm.contains('تورلي')) {
    g = 280.0;
  } else if (norm.contains('طاجن')) {
    g = 280.0;
  } else if (norm.contains('حمام محشي')) {
    g = 280.0;
  } else if (norm.contains('ممبار')) {
    final m = RegExp(r'(\d+)').firstMatch(norm);
    final count = m != null ? int.parse(m.group(1)!) : 4;
    g = count * 50.0;
  } else if (norm.contains('محشي')) {
    g = 350.0;
  } else if (norm.contains('طعميه')) {
    final m = RegExp(r'(\d+)').firstMatch(norm);
    final count = m != null ? int.parse(m.group(1)!) : 4;
    g = count * 30.0;
  } else if (norm.contains('كفته')) {
    final m = RegExp(r'(\d+)').firstMatch(norm);
    final count = m != null ? int.parse(m.group(1)!) : 3;
    g = count * 45.0;
  } else if (norm.contains('جلاش')) {
    final count = (norm.contains('قطعتان') || norm.contains('2')) ? 2 : 1;
    g = count * 80.0;
  } else if (norm.contains('شيش طاووق')) {
    final count = (norm.contains('3') || norm.contains('اسياخ')) ? 3 : 2;
    g = count * 60.0;
  } else if (RegExp(r'(?<![أا])بيض(?!ا)').hasMatch(norm)) {
    final count = (norm.contains('بيضتان') || norm.contains('2')) ? 2 : 1;
    g = count * 50.0;
  } else if (norm.contains('توست')) {
    final count = (norm.contains('2') || norm.contains('شريحتان')) ? 2 : 1;
    g = count * 30.0;
  } else if (norm.contains('بيتزا')) {
    final count = (norm.contains('2') || norm.contains('شريحتان')) ? 2 : 1;
    g = count * 105.0;
  } else if (norm.contains('رغيف ونص') || norm.contains('رغيف ونصف')) {
    g = 135.0;
  } else if (norm.contains('نصف رغيف') || norm.contains('نص رغيف')) {
    g = 45.0;
  } else if (norm.contains('رغيف')) {
    // A shammi/pita loaf is smaller than a baladi loaf.
    g = (norm.contains('شامي') || norm.contains('بيتا')) ? 65.0 : 90.0;
  } else if (norm.contains('تورتيلا')) {
    // Large flour tortilla (~10 inch burrito-size wrap).
    g = 75.0;
  } else if (norm.contains('نصف ثمره') || norm.contains('نص ثمره')) {
    // Half a medium avocado/fruit ≈ 65 g.
    g = 65.0;
  } else if (norm.contains('ربع')) {
    // Quarter piece of a medium fruit/vegetable (e.g. ربع ثمرة أفوكادو ≈ 35 g).
    g = 35.0;
  } else if (norm.contains('ساندوتش')) {
    final count = (norm.contains('2') || norm.contains('ساندوتشان')) ? 2 : 1;
    if (norm.contains('كبده')) {
      // فينو (~60 g) + كبدة إسكندراني filling (~130 g) per sandwich.
      g = count * 190.0;
    } else if (norm.contains('شاورما')) {
      // خبز شامي + شاورما filling; bigger than a فينو sandwich.
      g = count * 200.0;
    } else if (norm.contains('جمبري')) {
      g = count * 120.0;
    } else if (norm.contains('رومي')) {
      g = count * 120.0;
    } else {
      g = count * 140.0;
    }
  } else if (norm.contains('خبز برجر') || norm.contains('كايزر')) {
    // Hamburger bun/kaiser roll (~60 g), not a burger patty.
    g = 60.0;
  } else if (norm.contains('ملعقه صغيره') || norm.contains('معلقه صغيره')) {
    final m = RegExp(r'(\d+)').firstMatch(norm);
    final count = m != null ? int.parse(m.group(1)!) : 1;
    // Teaspoon ≈ 5 g.
    g = count * 5.0;
  } else if (norm.contains('ملعقه كبيره') ||
      norm.contains('معلقه كبيره') ||
      norm.contains('ملعقه') ||
      norm.contains('معلقه')) {
    final m = RegExp(r'(\d+)').firstMatch(norm);
    final count = m != null ? int.parse(m.group(1)!) : 1;
    if (['زيت', 'سمن', 'زبده'].any((x) => norm.contains(x))) {
      g = count * 14.0;
    } else if (['طحينه', 'مايونيز', 'فول سوداني', 'دريسنج'].any((x) => norm.contains(x))) {
      g = count * 15.0;
    } else if (norm.contains('عسل')) {
      g = count * 21.0;
    } else if (norm.contains('صلصه')) {
      g = count * 25.0;
    } else if (norm.contains('حمص')) {
      g = count * 20.0;
    } else if (['لوز', 'شيا', 'بارميزان'].any((x) => norm.contains(x))) {
      g = count * 12.0;
    } else if (norm.contains('ثوميه')) {
      g = count * 15.0;
    } else {
      g = count * 15.0;
    }
  } else if (norm.contains('نصف كوب') || norm.contains('نص كوب')) {
    if (['ارز', 'رز', 'شوفان'].any((x) => norm.contains(x))) {
      g = 80.0;
    } else if (['فاصوليا', 'حمص'].any((x) => norm.contains(x))) {
      g = 85.0;
    } else if (norm.contains('لحم')) {
      g = 80.0;
    } else {
      g = 70.0;
    }
  } else if (hasWord(norm, 'كوب')) {
    if (['ارز', 'رز', 'كينوا', 'شوفان'].any((x) => norm.contains(x))) {
      g = 160.0;
    } else if (['مكرونه', 'سباجيتي'].any((x) => norm.contains(x))) {
      g = 140.0;
    } else if (['حليب', 'لبن'].any((x) => norm.contains(x))) {
      g = 245.0;
    } else if (norm.contains('زبادي')) {
      g = 220.0;
    } else if (norm.contains('شوربه')) {
      g = 250.0;
    } else if (norm.contains('سلطه')) {
      g = 100.0;
    } else if (['بروكلي', 'خضار'].any((x) => norm.contains(x))) {
      g = 120.0;
    } else if (norm.contains('جبنه قريش')) {
      g = 150.0;
    } else if (norm.contains('عدس')) {
      g = 180.0;
    } else {
      g = 200.0;
    }
  } else if (['شريحه', 'شرائح', 'شريحتان'].any((k) => norm.contains(k))) {
    final m = RegExp(r'(\d+)').firstMatch(norm);
    final count = m != null ? int.parse(m.group(1)!) : (norm.contains('شريحتان') ? 2 : 1);
    if (norm.contains('جبن')) {
      g = count * 25.0;
    } else if (norm.contains('بيكن')) {
      g = count * 30.0;
    } else if (norm.contains('رومي مدخن')) {
      g = count * 30.0;
    } else if (norm.contains('ستيك') || norm.contains('لحم')) {
      g = count * 150.0;
    } else {
      g = count * 40.0;
    }
  } else if (norm.contains('فراخ بانيه') || norm.contains('صدر دجاج')) {
    g = 160.0;
  } else if (norm.contains('ورك دجاج') || norm.contains('ورك دجاجه')) {
    g = 140.0;
  } else if (norm.contains('ستيك سلمون')) {
    g = 170.0;
  } else if (norm.contains('ستيك') || norm.contains('لحم بقري') || norm.contains('لحم ضان')) {
    // Ribeye is typically served as a large 8–12 oz steak (≈220 g cooked);
    // other steak cuts default to a regular 140 g piece.
    g = norm.contains('ريب') ? 220.0 : 140.0;
  } else if (['سمكه', 'بلطي', 'بوري'].any((x) => norm.contains(x))) {
    g = 220.0;
  } else if (norm.contains('تونه')) {
    g = 140.0;
  } else if (norm.contains('برجر')) {
    g = 120.0;
  } else if (hasWord(norm, 'زيتون')) {
    final m = RegExp(r'(\d+)').firstMatch(norm);
    final count = m != null ? int.parse(m.group(1)!) : 5;
    g = count * 4.0;
  } else if (norm.contains('طبق')) {
    if (['ملوخيه', 'باميه', 'شوربه', 'قلقاس', 'سبانخ', 'بسله', 'فاصوليا', 'تشيلي'].any((x) => norm.contains(x))) {
      g = 240.0;
    } else if (norm.contains('فول')) {
      g = 200.0;
    } else if (norm.contains('بطاطس مقليه')) {
      g = 117.0;
    } else {
      g = 220.0;
    }
  } else if (['ثمره', 'حبه'].any((k) => norm.contains(k))) {
    g = 130.0;
  } else if (norm.contains('سكوب')) {
    g = 30.0;
  }

  var clean = norm;
  final removeTokens = [
    RegExp(r'\b\d+\b'),
    RegExp(r'قطعتان'),
    RegExp(r'بيضتان'),
    RegExp(r'ساندوتشان'),
    RegExp(r'طبق'),
    RegExp(r'وسط'),
    RegExp(r'كبير'),
    RegExp(r'صغير'),
    RegExp(r'كوب'),
    RegExp(r'نصف'),
    RegExp(r'نص'),
    RegExp(r'ملعقه'),
    RegExp(r'معلقه'),
    RegExp(r'كبيره'),
    RegExp(r'صغيره'),
    RegExp(r'اقراص'),
    RegExp(r'قرص'),
    RegExp(r'صوابع'),
    RegExp(r'صابع'),
    RegExp(r'اصابع'),
    RegExp(r'شريحه'),
    RegExp(r'شرائح'),
    RegExp(r'شريحتان'),
    RegExp(r'قطعه'),
    RegExp(r'حبه'),
    RegExp(r'حبات'),
    RegExp(r'ثمره'),
    RegExp(r'علبه'),
    RegExp(r'سكوب'),
    RegExp(r'طاجن'),
    RegExp(r'فرده'),
    RegExp(r'اسياخ'),
  ];
  // Longer tokens first, so e.g. كبيره is stripped whole instead of كبير
  // leaving a stray "ه" that pollutes the match query.
  removeTokens.sort((a, b) => b.pattern.length.compareTo(a.pattern.length));
  for (final tok in removeTokens) {
    clean = clean.replaceAll(tok, ' ');
  }
  clean = clean.replaceAll(RegExp(r'\s+'), ' ').trim();

  if (raw.contains('رغيف عيش بلدي') || raw.contains('عيش بلدي')) {
    clean = 'عيش بلدي';
  } else if (raw.contains('شوفان مطبوخ')) {
    clean = 'شوفان مطبوخ';
  } else if (raw.contains('بيض مسلوق') || raw.contains('بيضتان مسلوقتان')) {
    clean = 'بيض مسلوق';
  } else if (raw.contains('بيض مقلي') || raw.contains('بيضتان مقليتان')) {
    clean = 'بيض مقلي';
  } else if (clean == 'طحينه') {
    // A spoon of طحينة with a meal is the prepared sauce (280), not the
    // raw paste (595); both entries share the "طحينة" alias, so disambiguate.
    clean = 'سلطه طحينه';
  } else if (clean.contains('يوناني')) {
    // "زبادي يوناني" must hit yogurt_greek (97), not baladi plain (68).
    clean = 'زبادي يوناني';
  } else if (clean.contains('كبده') && clean.contains('اسكندراني')) {
    // Street sandwich = the Alexandrian liver dish, not a branded product.
    // Typed in raw spelling so normalizeText lands exactly on the DB alias.
    clean = 'كبدة إسكندرانية';
  } else if (clean.contains('بطاطس') && clean.contains('مشوي')) {
    // No dedicated baked-potato entry; boiled potato is the closest match.
    clean = 'بطاطس مسلوقه';
  } else if (clean.contains('ستيك') && clean.contains('لحم بقري')) {
    clean = 'لحم بقري مشوي';
  } else if (clean.contains('جبنه رومي') || clean.contains('جبن رومي')) {
    clean = 'جبنة رومي';
  } else if (clean.contains('جبنه شيدر') || clean.contains('جبن شيدر')) {
    clean = 'جبنة شيدر';
  } else if (clean.contains('بيتزا')) {
    clean = 'بيتزا بالجبن';
  } else if (clean.contains('سبانخ')) {
    clean = 'سبانخ باللحمة';
  } else if (clean.contains('بسله')) {
    clean = 'بسلة بالجزر';
  } else if (clean.contains('فاصوليا بيضاء')) {
    clean = 'فاصوليا بيضاء';
  } else if (clean.contains('كبد وقوانص')) {
    clean = 'كبد وقوانص';
  } else if (clean.contains('حواوشي')) {
    clean = 'حواوشي';
  } else if (clean.contains('ممبار')) {
    clean = 'ممبار';
  } else if (clean.contains('ام علي')) {
    clean = 'ام علي';
  } else if (clean.contains('كوارع')) {
    clean = 'كوارع';
  } else if (clean.contains('حمام محشي')) {
    clean = 'حمام محشي';
  } else if (clean.contains('قلقاس')) {
    clean = 'قلقاس بالسلق';
  } else if (clean.contains('لسان عصفور')) {
    clean = 'شوربة لسان عصفور';
  } else if (clean.contains('جلاش')) {
    clean = 'جلاش باللحمة';
  } else if (clean.contains('برجر كايزر') || clean.contains('خبز برجر')) {
    clean = 'خبز برجر';
  }

  return (clean, g);
}

/// One row of reference_meals.csv. `split` is assigned deterministically by
/// [heldOutIds]; reference values (items_text, true_kcal, source) are never
/// modified by the bench.
class MealRow {
  const MealRow({
    required this.mealId,
    required this.category,
    required this.mealName,
    required this.itemsText,
    required this.trueKcal,
    required this.source,
    this.sourceConfidence = 'high',
  });

  final String mealId;
  final String category;
  final String mealName;
  final String itemsText;
  final double trueKcal;
  final String source;

  /// 'low' marks references whose specific source could not be verified
  /// (e.g. unattributed lab analyses). Reference values are still never
  /// edited; they are only excluded from the alternative MAPE report.
  final String sourceConfidence;
}

/// Result of estimating one meal.
class MealResult {
  const MealResult({
    required this.row,
    required this.estKcal,
    required this.ape,
  });

  final MealRow row;
  final double estKcal;
  final double ape;
}

/// FNV-1a 32-bit hash — stable across runs and platforms, used to make the
/// train/test split deterministic and reviewable.
int fnv1a32(String s) {
  var h = 0x811c9dc5;
  for (final unit in s.codeUnits) {
    h ^= unit;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

/// Deterministic stratified hold-out: exactly [egyptianCount] egyptian and
/// [genericCount] generic meals — those with the smallest FNV-1a hash of
/// their meal_id — are held out as the TEST set. Everything else is TUNING.
Set<String> computeHeldOutIds(
  List<MealRow> meals, {
  int egyptianCount = 13,
  int genericCount = 7,
}) {
  Set<String> pick(String category, int count) {
    final ids = meals.where((m) => m.category == category).map((m) => m.mealId).toList()
      ..sort((a, b) {
        final c = fnv1a32(a).compareTo(fnv1a32(b));
        return c != 0 ? c : a.compareTo(b);
      });
    return ids.take(count).toSet();
  }

  return {
    ...pick('egyptian', egyptianCount),
    ...pick('generic', genericCount),
  };
}

/// Composite dishes with no single good DB entry, expanded into sourced
/// component items (component query, grams). Grams reflect standard Egyptian
/// home/restaurant servings; kcal values come from the matched DB entries.
const composites = <String, List<(String, double)>>{
  // طبق مكرونة بالجمبري وزيت الزيتون والثوم
  'مكرونه بالجمبري': [('مكرونه بيضاء مطبوخه', 180), ('جمبري مطبوخ', 80), ('زيت زيتون', 5)],
  // طاجن لسان عصفور باللحمة المفرومة (baked orzo casserole, not soup)
  'لسان عصفور باللحم': [('مكرونه بيضاء مطبوخه', 180), ('لحم بقري مفروم', 95)],
  // طبق تشيلي لحم مفروم بالفاصوليا والصلصة (bean-dominant)
  'تشيلي': [('لحم بقري مفروم', 60), ('فاصوليا بيضاء', 70), ('زيت زيتون', 3)],
  // ساندوتش جبنة رومي في عيش فينو
  'ساندوتش جبنه رومي': [('عيش فينو', 55), ('جبنه رومي', 45)],
  // كوب شوربة فراخ بالنودلز (cup includes the noodles)
  'نودلز': [('شوربه فراخ', 225), ('مكرونه بيضاء مطبوخه', 25)],
};

/// True when the item text mentions deep/shallow frying. "محمر" is excluded:
/// for chicken it means roasted ( browned ), whose DB entries already carry
/// their fat; adding frying oil on top double-counts (eg_06 regression).
bool impliesFrying(String norm) => norm.contains('مقلي') || norm.contains('مقليه');

const double oilKcalPer100g = 884.0;
// P34 table: frying absorbs 14 g oil per 100 g of food.
const double fryingOilGramsPer100g = 14.0;

/// Estimate a meal: parse each item's portion + name, match the food, and
/// scale kcal per 100g. Unmatched items fall back to 150 kcal/100g.
MealResult estimateMeal(
  MealRow row,
  List<Map<String, dynamic>> egFoods,
  List<Map<String, dynamic>> usdaFoods,
) {
  var estMealKcal = 0.0;
  final items = row.itemsText.split('|');

  for (final itemStr in items) {
    final norm = normalizeText(itemStr);

    // Composite dish: expand into sourced components.
    String? compositeKey;
    for (final key in composites.keys) {
      if (norm.contains(key)) {
        compositeKey = key;
        break;
      }
    }
    if (compositeKey != null) {
      for (final (componentQuery, grams) in composites[compositeKey]!) {
        final (food, _) = matchFood(componentQuery, egFoods, usdaFoods);
        final kcalPer100 = food != null
            ? ((food['per_100g'] as Map<String, dynamic>)['kcal'] as num).toDouble()
            : 150.0;
        estMealKcal += (grams * kcalPer100) / 100.0;
      }
      continue;
    }

    final (cleanName, grams) = parsePortionAndName(itemStr);
    final (matchedFood, _) = matchFood(cleanName, egFoods, usdaFoods);

    if (matchedFood != null) {
      final kcalPer100 = ((matchedFood['per_100g'] as Map<String, dynamic>)['kcal'] as num).toDouble();
      estMealKcal += (grams * kcalPer100) / 100.0;
      // Cooking-oil defaults by method (P34): only when the method implies
      // oil AND the matched entry does not already include frying fat.
      final state = (matchedFood['state'] as String?) ?? '';
      if (impliesFrying(norm) && state != 'fried' && state != 'cooked') {
        estMealKcal += grams * fryingOilGramsPer100g / 100.0 * oilKcalPer100g / 100.0;
      }
    } else {
      estMealKcal += (grams * 150.0) / 100.0;
    }
  }

  final ape = (estMealKcal - row.trueKcal).abs() / row.trueKcal * 100.0;
  return MealResult(row: row, estKcal: estMealKcal, ape: ape);
}

class MapeBreakdown {
  const MapeBreakdown({
    required this.overall,
    required this.egyptian,
    required this.generic,
    required this.count,
    required this.egCount,
    required this.genCount,
  });

  final double overall;
  final double egyptian;
  final double generic;
  final int count;
  final int egCount;
  final int genCount;
}

MapeBreakdown mapeOf(List<MealResult> results) {
  var total = 0.0;
  var eg = 0.0;
  var gen = 0.0;
  var egCount = 0;
  var genCount = 0;
  for (final r in results) {
    total += r.ape;
    if (r.row.category == 'egyptian') {
      eg += r.ape;
      egCount++;
    } else {
      gen += r.ape;
      genCount++;
    }
  }
  final n = results.length;
  return MapeBreakdown(
    overall: n > 0 ? total / n : 0.0,
    egyptian: egCount > 0 ? eg / egCount : 0.0,
    generic: genCount > 0 ? gen / genCount : 0.0,
    count: n,
    egCount: egCount,
    genCount: genCount,
  );
}

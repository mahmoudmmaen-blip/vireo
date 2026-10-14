// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

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

Map<String, dynamic>? matchInPool(List<Map<String, dynamic>> pool, String query) {
  final q = normalizeText(query);
  if (q.isEmpty) return null;
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

      if (cn.contains(q) || q.contains(cn)) {
        final score = cn.length / (q.length + 1);
        if (score > bestScore) {
          bestScore = score;
          best = f;
        }
      } else {
        final qWords = q.split(' ').where((w) => w.isNotEmpty).toSet();
        final cWords = cn.split(' ').where((w) => w.isNotEmpty).toSet();
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
  } else if (norm.contains('فته')) {
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
  } else if (norm.contains('ممبار')) {
    final m = RegExp(r'(\d+)').firstMatch(norm);
    final count = m != null ? int.parse(m.group(1)!) : 4;
    g = count * 50.0;
  } else if (norm.contains('جلاش')) {
    final count = (norm.contains('قطعتان') || norm.contains('2')) ? 2 : 1;
    g = count * 80.0;
  } else if (norm.contains('شيش طاووق')) {
    final count = (norm.contains('3') || norm.contains('اسياخ')) ? 3 : 2;
    g = count * 60.0;
  } else if (RegExp(r'(?<![أا])بيض').hasMatch(norm)) {
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
    g = 90.0;
  } else if (norm.contains('ساندوتش')) {
    final count = (norm.contains('2') || norm.contains('ساندوتشان')) ? 2 : 1;
    if (norm.contains('كبده')) {
      g = count * 100.0;
    } else if (norm.contains('جمبري')) {
      g = count * 120.0;
    } else if (norm.contains('رومي')) {
      g = count * 120.0;
    } else {
      g = count * 140.0;
    }
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
  } else if (norm.contains('ملعقه صغيره') || norm.contains('معلقه صغيره')) {
    g = 5.0;
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
  } else if (norm.contains('كوب')) {
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
    g = 140.0;
  } else if (['سمكه', 'بلطي', 'بوري'].any((x) => norm.contains(x))) {
    g = 220.0;
  } else if (norm.contains('تونه')) {
    g = 140.0;
  } else if (norm.contains('برجر')) {
    g = 120.0;
  } else if (norm.contains('زيتون')) {
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

void main() async {
  final egFile = File('assets/food_db/foods.json');
  final usdaFile = File('assets/food_db/usda_foods.json');
  final csvFile = File('tool/accuracy_bench/reference_meals.csv');

  if (!egFile.existsSync() || !usdaFile.existsSync() || !csvFile.existsSync()) {
    print('Required files missing.');
    exit(1);
  }

  final egData = jsonDecode(await egFile.readAsString()) as Map<String, dynamic>;
  final egFoods = (egData['foods'] as List).cast<Map<String, dynamic>>();

  final usdaData = jsonDecode(await usdaFile.readAsString()) as Map<String, dynamic>;
  final usdaFoods = (usdaData['foods'] as List).cast<Map<String, dynamic>>();

  final lines = await csvFile.readAsLines();
  if (lines.isEmpty) return;

  var totalApe = 0.0;
  var egApe = 0.0;
  var egCount = 0;
  var genApe = 0.0;
  var genCount = 0;
  var rowCount = 0;

  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    final cols = line.split(',');
    if (cols.length < 5) continue;

    final cat = cols[1].trim();
    final itemsText = cols[3].trim();
    final trueKcal = double.tryParse(cols[4].trim()) ?? 0.0;
    if (trueKcal <= 0) continue;

    var estMealKcal = 0.0;
    final items = itemsText.split('|');

    for (final itemStr in items) {
      final (cleanName, grams) = parsePortionAndName(itemStr);
      final (matchedFood, _) = matchFood(cleanName, egFoods, usdaFoods);

      if (matchedFood != null) {
        final kcalPer100 = ((matchedFood['per_100g'] as Map<String, dynamic>)['kcal'] as num).toDouble();
        estMealKcal += (grams * kcalPer100) / 100.0;
      } else {
        estMealKcal += (grams * 150.0) / 100.0;
      }
    }

    final ape = (estMealKcal - trueKcal).abs() / trueKcal * 100.0;
    totalApe += ape;
    rowCount++;

    if (cat == 'egyptian') {
      egApe += ape;
      egCount++;
    } else {
      genApe += ape;
      genCount++;
    }
  }

  final overallMape = rowCount > 0 ? totalApe / rowCount : 0.0;
  final egMape = egCount > 0 ? egApe / egCount : 0.0;
  final genMape = genCount > 0 ? genApe / genCount : 0.0;

  print('======================================================================');
  print('  VIREO CALORIE ACCURACY BENCHMARK (INDEPENDENT REFERENCE - DART)');
  print('======================================================================');
  print('Total Meals: $rowCount (Egyptian: $egCount, Generic: $genCount)');
  print('OVERALL MAPE: ${overallMape.toStringAsFixed(2)}%');
  print('Egyptian Meals MAPE: ${egMape.toStringAsFixed(2)}%');
  print('Generic Meals MAPE:  ${genMape.toStringAsFixed(2)}%');
  print('======================================================================');
}

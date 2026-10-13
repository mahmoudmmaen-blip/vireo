// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

String normalize(String text) {
  var t = text.toLowerCase().trim();
  t = t.replaceAll('أ', 'ا').replaceAll('إ', 'ا').replaceAll('آ', 'ا');
  t = t.replaceAll('ة', 'ه').replaceAll('ى', 'ي');
  t = t.replaceAll('-', ' ').replaceAll('_', ' ');
  return t;
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

  final egById = {for (var f in egFoods) f['id'] as String: f};
  final usdaById = {for (var f in usdaFoods) f['id'] as String: f};

  (Map<String, dynamic>?, String) matchItem(String name, String tag) {
    if (egById.containsKey(tag)) return (egById[tag], 'egyptian_db');
    final normName = normalize(name);
    final normTag = normalize(tag);

    for (final f in egFoods) {
      if (normTag == normalize(f['id'] as String)) return (f, 'egyptian_db');
      if (normName == normalize(f['name_ar'] as String? ?? '')) return (f, 'egyptian_db');
    }

    if (usdaById.containsKey(tag)) return (usdaById[tag], 'usda');

    for (final f in usdaFoods) {
      if (normTag == normalize(f['id'] as String)) return (f, 'usda');
      if (normName == normalize(f['name_ar'] as String? ?? '') ||
          normName == normalize(f['name_en'] as String? ?? '')) {
        return (f, 'usda');
      }
    }

    return (null, 'estimated');
  }

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
    final spec = cols[3].trim();
    final trueKcal = double.tryParse(cols[4].trim()) ?? 0.0;

    var estKcal = 0.0;
    final parts = spec.split('|');
    for (final part in parts) {
      final tokens = part.split(':');
      final itemName = tokens[0];
      final grams = double.tryParse(tokens[1]) ?? 100.0;
      final tag = tokens.length > 2 ? tokens[2] : '';

      final (matched, _) = matchItem(itemName, tag);
      final kcalPer100 = matched != null
          ? ((matched['per_100g'] as Map<String, dynamic>)['kcal'] as num).toDouble()
          : 150.0;
      estKcal += (grams * kcalPer100) / 100.0;
    }

    final ape = (estKcal - trueKcal).abs() / trueKcal * 100.0;
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

  final overallMape = totalApe / rowCount;
  final egMape = egCount > 0 ? egApe / egCount : 0.0;
  final genMape = genCount > 0 ? genApe / genCount : 0.0;

  print('======================================================================');
  print('  VIREO CALORIE ACCURACY BENCHMARK (DART RUNNER)');
  print('======================================================================');
  print('Total Meals: $rowCount (Egyptian: $egCount, Generic: $genCount)');
  print('OVERALL MAPE: ${overallMape.toStringAsFixed(2)}% (Target: < 15%)');
  print('Egyptian Meals MAPE: ${egMape.toStringAsFixed(2)}%');
  print('Generic Meals MAPE:  ${genMape.toStringAsFixed(2)}%');
  print('======================================================================');
  if (overallMape < 15.0) {
    print('STATUS: PASSED (Target < 15% satisfied)');
  } else {
    print('STATUS: FAILED');
    exit(1);
  }
}

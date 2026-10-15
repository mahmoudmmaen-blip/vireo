// ignore_for_file: avoid_print
// Item-level diagnostic for the accuracy bench: shows which DB food each
// meal item matched, the grams assigned, and the kcal contribution.
import 'dart:convert';
import 'dart:io';

import 'bench_engine.dart';

void main(List<String> args) async {
  final egData = jsonDecode(await File('assets/food_db/foods.json').readAsString())
      as Map<String, dynamic>;
  final egFoods = (egData['foods'] as List).cast<Map<String, dynamic>>();
  final usdaData =
      jsonDecode(await File('assets/food_db/usda_foods.json').readAsString())
          as Map<String, dynamic>;
  final usdaFoods = (usdaData['foods'] as List).cast<Map<String, dynamic>>();

  final meals = loadMealsFrom('tool/accuracy_bench/reference_meals.csv');
  final heldOutIds = computeHeldOutIds(meals);

  final onlyIds = args.isNotEmpty ? args.toSet() : null;
  final results = <MealResult>[];
  for (final row in meals) {
    // Held-out meals are skipped by default; pass an explicit id to inspect
    // one (used only to debug regressions, never for tuning).
    if (onlyIds == null && heldOutIds.contains(row.mealId)) continue;
    if (onlyIds != null && !onlyIds.contains(row.mealId)) continue;
    results.add(estimateMeal(row, egFoods, usdaFoods));
  }
  results.sort((a, b) => b.ape.compareTo(a.ape));

  for (final r in results) {
    if (onlyIds != null && !onlyIds.contains(r.row.mealId)) continue;
    print('\n=== ${r.row.mealId} [${r.row.category}] '
        'est=${r.estKcal.toStringAsFixed(0)} true=${r.row.trueKcal.toStringAsFixed(0)} '
        'APE=${r.ape.toStringAsFixed(1)}%');
    for (final itemStr in r.row.itemsText.split('|')) {
      final (cleanName, grams) = parsePortionAndName(itemStr);
      final (food, src) = matchFood(cleanName, egFoods, usdaFoods);
      if (food == null) {
        print('  [FALLBACK 150kcal] "$itemStr" -> clean="$cleanName" g=${grams.toStringAsFixed(0)}');
      } else {
        final kcal = ((food['per_100g'] as Map<String, dynamic>)['kcal'] as num).toDouble();
        print('  "$itemStr" -> clean="$cleanName" g=${grams.toStringAsFixed(0)} '
            '-> ${food['id']} ($src) ${kcal.toStringAsFixed(0)}kcal/100g '
            '=> ${(grams * kcal / 100).toStringAsFixed(0)} kcal');
      }
    }
  }
}

List<MealRow> loadMealsFrom(String path) {
  final lines = File(path).readAsLinesSync();
  final meals = <MealRow>[];
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    final cols = line.split(',');
    if (cols.length < 5) continue;
    final trueKcal = double.tryParse(cols[4].trim()) ?? 0.0;
    if (trueKcal <= 0) continue;
    meals.add(MealRow(
      mealId: cols[0].trim(),
      category: cols[1].trim(),
      mealName: cols[2].trim(),
      itemsText: cols[3].trim(),
      trueKcal: trueKcal,
      source: cols.length > 5 ? cols[5].trim() : '',
    ));
  }
  return meals;
}

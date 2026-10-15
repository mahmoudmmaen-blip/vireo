// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'bench_engine.dart';

/// Parses reference_meals.csv into MealRows. Reference values are read-only.
List<MealRow> loadMeals(String csvPath) {
  final lines = File(csvPath).readAsLinesSync();
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
      sourceConfidence: cols.length > 6 ? cols[6].trim() : 'high',
    ));
  }
  return meals;
}

void printBreakdown(String label, MapeBreakdown m) {
  print('$label: ${m.count} meals (Egyptian: ${m.egCount}, Generic: ${m.genCount})');
  print('  Overall MAPE:      ${m.overall.toStringAsFixed(2)}%');
  print('  Egyptian MAPE:     ${m.egyptian.toStringAsFixed(2)}%');
  print('  Generic MAPE:      ${m.generic.toStringAsFixed(2)}%');
}

void main(List<String> args) async {
  final egFile = File('assets/food_db/foods.json');
  final usdaFile = File('assets/food_db/usda_foods.json');
  final csvFile = File('tool/accuracy_bench/reference_meals.csv');

  if (!egFile.existsSync() || !usdaFile.existsSync() || !csvFile.existsSync()) {
    print('Required files missing.');
    exit(1);
  }

  final dumpPath = args.length > 1 && args[0] == '--dump' ? args[1] : null;

  final egData = jsonDecode(await egFile.readAsString()) as Map<String, dynamic>;
  final egFoods = (egData['foods'] as List).cast<Map<String, dynamic>>();

  final usdaData = jsonDecode(await usdaFile.readAsString()) as Map<String, dynamic>;
  final usdaFoods = (usdaData['foods'] as List).cast<Map<String, dynamic>>();

  final meals = loadMeals(csvFile.path);
  final heldOutIds = computeHeldOutIds(meals);

  final tuning = <MealResult>[];
  final heldOut = <MealResult>[];
  for (final row in meals) {
    final result = estimateMeal(row, egFoods, usdaFoods);
    if (heldOutIds.contains(row.mealId)) {
      heldOut.add(result);
    } else {
      tuning.add(result);
    }
  }

  if (dumpPath != null) {
    final buf = StringBuffer('meal_id,split,category,est_kcal,true_kcal,ape_pct\n');
    for (final r in [...tuning, ...heldOut]..sort((a, b) => b.ape.compareTo(a.ape))) {
      final split = heldOutIds.contains(r.row.mealId) ? 'test' : 'tuning';
      buf.writeln(
        '${r.row.mealId},$split,${r.row.category},${r.estKcal.toStringAsFixed(0)},${r.row.trueKcal.toStringAsFixed(0)},${r.ape.toStringAsFixed(2)}',
      );
    }
    File(dumpPath).writeAsStringSync(buf.toString());
    print('Per-meal results written to $dumpPath');
  }

  print('======================================================================');
  print('  VIREO CALORIE ACCURACY BENCHMARK (INDEPENDENT REFERENCE - DART)');
  print('  Hold-out split: ${heldOut.length} TEST / ${tuning.length} TUNING (deterministic,');
  print('  stratified by category via FNV-1a hash of meal_id — fixed before tuning)');
  print('======================================================================');

  final tuningMape = mapeOf(tuning);
  final heldOutMape = mapeOf(heldOut);
  final allMape = mapeOf([...tuning, ...heldOut]);

  printBreakdown('TUNING SET  ', tuningMape);
  printBreakdown('HELD-OUT SET', heldOutMape);
  printBreakdown('ALL MEALS   ', allMape);

  final verifiedOnly = [...tuning, ...heldOut].where((r) => r.row.sourceConfidence != 'low').toList();
  final verifiedMape = mapeOf(verifiedOnly);
  print('----------------------------------------------------------------');
  print('Excluding ${([...tuning, ...heldOut].length - verifiedOnly.length)} meals with source_confidence=low '
      '(unverifiable references):');
  printBreakdown('VERIFIED ONLY', verifiedMape);

  print('----------------------------------------------------------------');
  print('HELD-OUT meal ids (TEST set — never used for tuning):');
  final sortedIds = heldOutIds.toList()..sort();
  for (final id in sortedIds) {
    print('  $id');
  }
  print('----------------------------------------------------------------');
  print('Worst 15 TUNING meals by APE:');
  final worst = [...tuning]..sort((a, b) => b.ape.compareTo(a.ape));
  for (final r in worst.take(15)) {
    print(
      '  ${r.row.mealId} [${r.row.category}] est=${r.estKcal.toStringAsFixed(0)} true=${r.row.trueKcal.toStringAsFixed(0)} APE=${r.ape.toStringAsFixed(1)}% :: ${r.row.itemsText}',
    );
  }
  print('======================================================================');
}

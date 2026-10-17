// ignore_for_file: avoid_print
/// Generates assets/content/local_food_swaps.json (≥100 DB-backed swaps).
///
/// Run: dart run tool/content/swaps_gen.dart
import 'dart:convert';
import 'dart:io';

import 'content_db_math.dart';

void main() {
  final root = projectRootFromScript();
  final eg = loadEgyptianFoodDb(root);
  final usda = loadUsdaFoodDb(root);
  final all = {...eg, ...usda};

  final swaps = <Map<String, dynamic>>[];
  final seen = <String>{};

  void addSwap({
    required String id,
    required DbFood from,
    required double fromG,
    required DbFood to,
    required double toG,
    String fromMethod = 'other',
    String toMethod = 'other',
    required String tipAr,
    required String tipEn,
  }) {
    if (seen.contains(id)) return;
    final kFrom = kcalForFood(from, fromG, cookingMethod: fromMethod).round();
    final kTo = kcalForFood(to, toG, cookingMethod: toMethod).round();
    final saved = kFrom - kTo;
    if (saved < 15) return;
    seen.add(id);
    swaps.add({
      'id': id,
      'from_food_id': from.id,
      'from_grams': fromG,
      'to_food_id': to.id,
      'to_grams': toG,
      'saved_kcal': saved,
      'tip_ar': tipAr.replaceAll('{saved}', '$saved'),
      'tip_en': tipEn.replaceAll('{saved}', '$saved'),
    });
  }

  // Portion downgrades (Egyptian foods).
  for (final food in eg.values) {
    if (food.portions.length < 2) continue;
    final sorted = [...food.portions]..sort((a, b) => b.grams.compareTo(a.grams));
    for (var i = 0; i < sorted.length - 1; i++) {
      final large = sorted[i];
      final small = sorted[i + 1];
      addSwap(
        id: 'portion_${food.id}_${i}_${i + 1}',
        from: food,
        fromG: large.grams,
        to: food,
        toG: small.grams,
        tipAr: 'بدل ${large.nameAr} ${food.nameAr} جرّب ${small.nameAr} — توفر حوالي {saved} سعرة',
        tipEn: 'Swap ${large.nameEn} ${food.nameEn} for ${small.nameEn} — save about {saved} kcal',
      );
    }
  }

  // Cooking method swaps at 200 g.
  for (final food in eg.values) {
    if (food.isAlreadyFried) continue;
    const g = 200.0;
    addSwap(
      id: 'fried_to_grill_${food.id}',
      from: food,
      fromG: g,
      to: food,
      toG: g,
      fromMethod: 'fried',
      toMethod: 'grilled',
      tipAr: 'بدل ${food.nameAr} المقلي مشوي — توفر حوالي {saved} سعرة (زيت أقل)',
      tipEn: 'Grill ${food.nameEn} instead of frying — save about {saved} kcal',
    );
    addSwap(
      id: 'fried_to_air_${food.id}',
      from: food,
      fromG: g,
      to: food,
      toG: g,
      fromMethod: 'fried',
      toMethod: 'air_fried',
      tipAr: 'جرّب ${food.nameAr} في القلاية الهوائية — توفر حوالي {saved} سعرة',
      tipEn: 'Try air-fried ${food.nameEn} — save about {saved} kcal',
    );
  }

  // Explicit Egyptian / Gulf pairs (same cuisine, DB ids).
  const pairs = [
    ('taameya_falafel', 120.0, 'taameya_baked_airfryer', 120.0, 'other', 'other'),
    ('koshary_egyptian', 650.0, 'koshary_egyptian', 450.0, 'other', 'other'),
    ('koshary_egyptian', 450.0, 'koshary_egyptian', 300.0, 'other', 'other'),
    ('foul_medames', 300.0, 'foul_medames', 200.0, 'other', 'other'),
    ('foul_sandwich', 250.0, 'foul_medames', 200.0, 'other', 'other'),
    ('shawarma_chicken_egyptian', 350.0, 'shawarma_chicken_egyptian', 250.0, 'other', 'other'),
    ('shawarma_meat_egyptian', 350.0, 'shawarma_meat_egyptian', 250.0, 'other', 'other'),
    ('kabsa_chicken_rice', 400.0, 'kabsa_chicken_rice', 300.0, 'other', 'other'),
    ('machboos_rice', 400.0, 'machboos_rice', 300.0, 'other', 'other'),
    ('molokhia_with_chicken', 350.0, 'molokhia_with_chicken', 250.0, 'other', 'other'),
    ('mahshi_waraq_enab', 300.0, 'mahshi_waraq_enab', 200.0, 'other', 'other'),
    ('hawawshi_baladi', 280.0, 'hawawshi_baladi', 180.0, 'other', 'other'),
    ('basbousa', 120.0, 'basbousa', 80.0, 'other', 'other'),
    ('kunafa', 150.0, 'kunafa', 100.0, 'other', 'other'),
    ('om_ali', 250.0, 'om_ali', 180.0, 'other', 'other'),
    ('white_rice_cooked', 250.0, 'white_rice_cooked', 150.0, 'other', 'other'),
    ('white_rice_cooked', 200.0, 'white_rice_cooked', 100.0, 'other', 'other'),
    ('cola', 330.0, 'water_mineral', 330.0, 'other', 'other'),
    ('cola', 500.0, 'water_mineral', 500.0, 'other', 'other'),
  ];

  for (final p in pairs) {
    final from = all[p.$1];
    final to = all[p.$3];
    if (from == null || to == null) continue;
    addSwap(
      id: 'pair_${p.$1}_${p.$3}_${p.$2.round()}',
      from: from,
      fromG: p.$2,
      to: to,
      toG: p.$4,
      fromMethod: p.$5,
      toMethod: p.$6,
      tipAr: 'بدل ${from.nameAr} بـ${to.nameAr} — توفر حوالي {saved} سعرة',
      tipEn: 'Swap ${from.nameEn} for ${to.nameEn} — save about {saved} kcal',
    );
  }

  // Half-portion swaps for high-kcal Egyptian dishes (200 g baseline).
  for (final food in eg.values) {
    if (food.kcalPer100 < 180) continue;
    const g = 250.0;
    addSwap(
      id: 'half_${food.id}',
      from: food,
      fromG: g,
      to: food,
      toG: g / 2,
      tipAr: 'نص حصة ${food.nameAr} بدل كامل — توفر حوالي {saved} سعرة',
      tipEn: 'Half a portion of ${food.nameEn} — save about {saved} kcal',
    );
  }

  swaps.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));

  if (swaps.length < 100) {
    stderr.writeln('ERROR: only ${swaps.length} swaps (need ≥100)');
    exit(1);
  }

  final outDir = Directory('$root/assets/content');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  final outFile = File('${outDir.path}/local_food_swaps.json');
  outFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert({
    'generated_at': DateTime.now().toUtc().toIso8601String(),
    'swaps': swaps,
  }));

  print('Wrote ${swaps.length} swaps → ${outFile.path}');
}

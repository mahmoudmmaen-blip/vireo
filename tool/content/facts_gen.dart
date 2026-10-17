// ignore_for_file: avoid_print
/// Generates assets/content/food_facts.json from the Egyptian food DB + walking math.
///
/// Run: dart run tool/content/facts_gen.dart
import 'dart:convert';
import 'dart:io';

import 'content_db_math.dart';

void main() {
  final root = projectRootFromScript();
  final db = loadEgyptianFoodDb(root);
  final facts = <Map<String, dynamic>>[];
  final seenIds = <String>{};

  void addFact({
    required String id,
    required DbFood food,
    required double grams,
    required String portionLabelAr,
    required String portionLabelEn,
    required String bodyExtraAr,
    required String bodyExtraEn,
    String? cookingMethod,
  }) {
    if (seenIds.contains(id)) return;
    final kcal = kcalForFood(
      food,
      grams,
      cookingMethod: cookingMethod ?? 'other',
    ).round();
    if (kcal < 120) return;
    final walk = walkMinutesForKcal(kcal.toDouble());
    final durAr = formatDurationAr(walk);
    seenIds.add(id);
    facts.add({
      'id': id,
      'food_id': food.id,
      'grams': grams,
      'kcal': kcal,
      'walk_minutes': walk,
      'title_ar': '$portionLabelAr ${food.nameAr} ≈ $durAr مشي',
      'title_en': '$portionLabelEn ${food.nameEn} ≈ $durAr walking',
      'body_ar':
          'حوالي $kcal سعرة حسب قاعدة بيانات ڤيريو — تعادل مشي $durAr (وزن مرجعي ٧٠ كجم، ~4.5 كم/س). $bodyExtraAr',
      'body_en':
          'About $kcal kcal from the Vireo food DB — equivalent to $durAr of walking (70 kg reference, ~4.5 km/h). $bodyExtraEn',
    });
  }

  // 1) Every common portion with meaningful energy.
  for (final food in db.values) {
    for (var i = 0; i < food.portions.length; i++) {
      final p = food.portions[i];
      addFact(
        id: 'walk_${food.id}_p$i',
        food: food,
        grams: p.grams,
        portionLabelAr: p.nameAr.isNotEmpty ? p.nameAr : 'حصة',
        portionLabelEn: p.nameEn.isNotEmpty ? p.nameEn : 'serving',
        bodyExtraAr: 'مش شرط تلغي الأكل — بس خليك واعي لحجم الحصة.',
        bodyExtraEn: 'No need to skip it — just stay aware of the portion.',
      );
    }
  }

  // 2) Large vs medium bowl savings (myth: "it's just one plate").
  for (final food in db.values) {
    if (food.portions.length < 2) continue;
    final sorted = [...food.portions]..sort((a, b) => b.grams.compareTo(a.grams));
    final large = sorted.first;
    final small = sorted.last;
    if (large.grams <= small.grams * 1.15) continue;
    final kLarge = kcalForFood(food, large.grams).round();
    final kSmall = kcalForFood(food, small.grams).round();
    final saved = kLarge - kSmall;
    if (saved < 80) continue;
    final walkSaved = walkMinutesForKcal(saved.toDouble());
    addFact(
      id: 'compare_${food.id}_large_vs_small',
      food: food,
      grams: large.grams,
      portionLabelAr: '${large.nameAr} vs ${small.nameAr}',
      portionLabelEn: '${large.nameEn} vs ${small.nameEn}',
      bodyExtraAr:
          'الفرق ≈ $saved سعرة — يعني حوالي ${formatDurationAr(walkSaved)} مشي زيادة لو اخترت ${large.nameAr}.',
      bodyExtraEn:
          'Difference ≈ $saved kcal — about ${formatDurationAr(walkSaved)} extra walking if you pick the ${large.nameEn}.',
    );
  }

  // 3) Fried vs air-fry / grilled (same grams, DB + oil table).
  const methodPairs = [
    ('fried', 'air_fried', 'مقلي', 'قلاية هوائية أو فرن', 'fried', 'air-fried'),
    ('fried', 'grilled', 'مقلي', 'مشوي', 'fried', 'grilled'),
  ];
  for (final food in db.values) {
    if (food.isAlreadyFried) continue;
    for (final pair in methodPairs) {
      const grams = 200.0;
      final kFried = kcalForFood(food, grams, cookingMethod: pair.$1).round();
      final kAlt = kcalForFood(food, grams, cookingMethod: pair.$2).round();
      final saved = kFried - kAlt;
      if (saved < 40) continue;
      addFact(
        id: 'cook_${food.id}_${pair.$1}_vs_${pair.$2}',
        food: food,
        grams: grams,
        portionLabelAr: '200 جم ${food.nameAr} ${pair.$3}',
        portionLabelEn: '200 g ${food.nameEn} ${pair.$5}',
        bodyExtraAr:
            'لو ${pair.$4} بدل ${pair.$3} توفر حوالي $saved سعرة (زيت الطبخ من جدول ڤيريو + بيانات الصنف).',
        bodyExtraEn:
            'Switching to ${pair.$6} saves about $saved kcal (cooking oil table + food DB).',
        cookingMethod: pair.$1,
      );
    }
  }

  // 4) Taameya: DB entry vs air-fry entry (explicit IDs).
  final friedTaameya = db['taameya_falafel'];
  final bakedTaameya = db['taameya_baked_airfryer'];
  if (friedTaameya != null && bakedTaameya != null) {
    const g = 120.0;
    final kF = kcalForFood(friedTaameya, g).round();
    final kB = kcalForFood(bakedTaameya, g).round();
    final saved = kF - kB;
    if (saved > 0) {
      addFact(
        id: 'taameya_fried_vs_airfry_db',
        food: friedTaameya,
        grams: g,
        portionLabelAr: '3 أقراص طعمية مقلية',
        portionLabelEn: '3 fried taameya pieces',
        bodyExtraAr:
            'نفس الحجم في القلاية الهوائية ≈ $kB سعرة — توفر حوالي $saved سعرة (${formatDurationAr(walkMinutesForKcal(saved.toDouble()))} مشي).',
        bodyExtraEn:
            'Same amount air-fried ≈ $kB kcal — saves about $saved kcal (${formatDurationAr(walkMinutesForKcal(saved.toDouble()))} walking).',
      );
    }
  }

  facts.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));

  if (facts.length < 60) {
    stderr.writeln('ERROR: only ${facts.length} facts (need ≥60)');
    exit(1);
  }

  final outDir = Directory('$root/assets/content');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  final outFile = File('${outDir.path}/food_facts.json');
  outFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert({
    'generated_at': DateTime.now().toUtc().toIso8601String(),
    'reference_weight_kg': 70,
    'walking_speed_kmh': 4.5,
    'facts': facts,
  }));

  print('Wrote ${facts.length} food facts → ${outFile.path}');
}

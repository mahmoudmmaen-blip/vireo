// Shared food-DB math for content generators (facts + swaps).
// Mirrors lib/features/nutrition oil absorption + macro scaling.

import 'dart:convert';
import 'dart:io';

class DbFood {
  DbFood({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.kcalPer100,
    required this.state,
    required this.portions,
  });

  final String id;
  final String nameAr;
  final String nameEn;
  final double kcalPer100;
  final String state;
  final List<({String nameAr, String nameEn, double grams})> portions;

  bool get isAlreadyFried => state == 'fried';
}

Map<String, DbFood> loadEgyptianFoodDb(String projectRoot) {
  final path = '$projectRoot/assets/food_db/foods.json';
  final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  final list = raw['foods'] as List? ?? [];
  final map = <String, DbFood>{};
  for (final item in list.whereType<Map>()) {
    final id = item['id']?.toString() ?? '';
    if (id.isEmpty) continue;
    final per100 = (item['per_100g'] as Map?) ?? {};
    final portionsRaw = item['common_portions'] as List? ?? [];
    final portions = <({String nameAr, String nameEn, double grams})>[];
    for (final p in portionsRaw.whereType<Map>()) {
      final g = (p['grams'] as num?)?.toDouble() ?? 0;
      if (g > 0) {
        portions.add((
          nameAr: p['name_ar']?.toString() ?? '',
          nameEn: p['name_en']?.toString() ?? '',
          grams: g,
        ));
      }
    }
    map[id] = DbFood(
      id: id,
      nameAr: item['name_ar']?.toString() ?? '',
      nameEn: item['name_en']?.toString() ?? '',
      kcalPer100: (per100['kcal'] as num?)?.toDouble() ?? 0,
      state: item['state']?.toString() ?? 'raw',
      portions: portions,
    );
  }
  return map;
}

Map<String, DbFood> loadUsdaFoodDb(String projectRoot) {
  final path = '$projectRoot/assets/food_db/usda_foods.json';
  final raw = jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
  final list = raw['foods'] as List? ?? [];
  final map = <String, DbFood>{};
  for (final item in list.whereType<Map>()) {
    final id = item['id']?.toString() ?? '';
    if (id.isEmpty) continue;
    final per100 = (item['per_100g'] as Map?) ?? {};
    map[id] = DbFood(
      id: id,
      nameAr: item['name_ar']?.toString() ?? '',
      nameEn: item['name_en']?.toString() ?? '',
      kcalPer100: (per100['kcal'] as num?)?.toDouble() ?? 0,
      state: item['state']?.toString() ?? 'raw',
      portions: const [],
    );
  }
  return map;
}

double oilAbsorptionGPer100(String methodKey) => switch (methodKey) {
      'fried' => 14.0,
      'sauteed' => 5.0,
      'mahshi' => 8.0,
      'baked' || 'oven' => 3.0,
      'grilled' => 2.0,
      'air_fried' => 1.5,
      _ => 0.0,
    };

/// kcal for [grams] of [food], optionally adding cooking oil (unless already fried in DB).
double kcalForFood(
  DbFood food,
  double grams, {
  String cookingMethod = 'other',
  double oilKcalPer100 = 884,
}) {
  if (grams <= 0) return 0;
  var kcal = food.kcalPer100 * (grams / 100.0);
  final oilG = oilAbsorptionGPer100(cookingMethod);
  if (oilG > 0 && !food.isAlreadyFried) {
    kcal += oilKcalPer100 * (oilG * (grams / 100.0) / 100.0);
  }
  return kcal;
}

/// ACSM-style walking equivalence (same as ContentWalkingMath / WalkingCalculations).
int walkMinutesForKcal(double kcal, {double weightKg = 70}) {
  if (kcal <= 0) return 0;
  final km = kcal / (0.57 * weightKg);
  final minutes = (km / 4.5 * 60).round();
  return minutes.clamp(1, 24 * 60);
}

String formatDurationAr(int totalMinutes) {
  if (totalMinutes < 60) return '$totalMinutes دقيقة';
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  if (m == 0) return h == 1 ? 'ساعة' : '$h ساعات';
  if (h == 1) return 'ساعة و $m دقيقة';
  return '$h ساعات و $m دقيقة';
}

String projectRootFromScript() {
  final script = Platform.script.toFilePath();
  final idx = script.lastIndexOf(r'tool\content');
  if (idx >= 0) return script.substring(0, idx).replaceAll(r'\', '/');
  final idx2 = script.lastIndexOf('tool/content');
  if (idx2 >= 0) return script.substring(0, idx2);
  return Directory.current.path;
}

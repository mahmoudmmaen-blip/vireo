import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';

/// Local food composition DB (USDA-sourced) loaded from assets.
class FoodDbRepository {
  FoodDbRepository._();
  static final FoodDbRepository instance = FoodDbRepository._();

  List<FoodItem>? _foods;
  Map<String, FoodItem>? _byId;

  Future<List<FoodItem>> load() async {
    if (_foods != null) return _foods!;
    final raw = await rootBundle.loadString('assets/food_db/foods.json');
    final decoded = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    final list = (decoded['foods'] as List? ?? [])
        .whereType<Map>()
        .map((e) => FoodItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    _foods = list;
    _byId = {for (final f in list) f.id: f};
    return list;
  }

  FoodItem? byId(String id) => _byId?[id];

  Future<FoodItem?> match({
    String? foodIdGuess,
    required String nameEn,
    required String nameAr,
  }) async {
    await load();
    if (foodIdGuess != null && foodIdGuess.isNotEmpty) {
      final hit = _byId?[foodIdGuess];
      if (hit != null) return hit;
    }

    final needle = _norm('$nameEn $nameAr');
    FoodItem? best;
    var bestScore = 0.0;

    for (final food in _foods!) {
      final candidates = [
        food.id,
        food.nameEn,
        food.nameAr,
        ...food.aliases,
      ].map(_norm);

      for (final c in candidates) {
        if (c.isEmpty) continue;
        if (c == needle || needle.contains(c) || c.contains(needle)) {
          final score = c.length / (needle.length + 1);
          if (score > bestScore) {
            bestScore = score;
            best = food;
          }
        } else {
          final score = _fuzzy(needle, c);
          if (score > 0.72 && score > bestScore) {
            bestScore = score;
            best = food;
          }
        }
      }
    }
    return best;
  }

  Future<List<FoodItem>> search(String query, {int limit = 20}) async {
    await load();
    final q = _norm(query);
    if (q.isEmpty) return _foods!.take(limit).toList();
    final scored = <({FoodItem food, double score})>[];
    for (final food in _foods!) {
      final hay = _norm(
        '${food.id} ${food.nameEn} ${food.nameAr} ${food.aliases.join(' ')}',
      );
      if (!hay.contains(q) && _fuzzy(q, hay) < 0.5) continue;
      scored.add((food: food, score: hay.contains(q) ? 1.0 : _fuzzy(q, hay)));
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(limit).map((e) => e.food).toList();
  }

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\u0600-\u06FF]+'), ' ')
      .trim();

  static double _fuzzy(String a, String b) {
    if (a.isEmpty || b.isEmpty) return 0;
    final shorter = a.length < b.length ? a : b;
    final longer = a.length < b.length ? b : a;
    if (longer.contains(shorter)) return shorter.length / longer.length;
    var hits = 0;
    final parts = shorter.split(' ').where((e) => e.length > 2);
    for (final p in parts) {
      if (longer.contains(p)) hits++;
    }
    final n = parts.length;
    return n == 0 ? 0 : hits / n;
  }
}

/// Scale macros for [grams], optionally adding absorbed frying oil.
ResolvedMealLine resolveLine({
  required ScannedFoodItem scanned,
  FoodItem? food,
  FoodMacros100g? estimatedPer100g,
  CookingMethod? methodOverride,
  double? gramsOverride,
  FoodItem? oilFood,
}) {
  final method = methodOverride ?? scanned.cookingMethod;
  final grams = (gramsOverride ?? scanned.estimatedGrams).clamp(1, 2000);
  final base = food?.per100g ?? estimatedPer100g;
  final isEstimated = food == null;

  double kcal = 0, protein = 0, carbs = 0, fat = 0;
  if (base != null) {
    final f = grams / 100.0;
    kcal = base.kcal * f;
    protein = base.protein * f;
    carbs = base.carbs * f;
    fat = base.fat * f;
  }

  // Fried foods that are not already fried in the DB absorb ~8 g oil / 100 g food.
  if (method == CookingMethod.fried && food?.isAlreadyFried != true) {
    final oilG = 8.0 * (grams / 100.0);
    final oil = oilFood?.per100g ??
        const FoodMacros100g(
          kcal: 884,
          protein: 0,
          carbs: 0,
          fat: 100,
          fiber: 0,
        );
    final of = oilG / 100.0;
    kcal += oil.kcal * of;
    fat += oil.fat * of;
  }

  return ResolvedMealLine(
    nameAr: food?.nameAr ?? scanned.nameAr,
    nameEn: food?.nameEn ?? scanned.nameEn,
    grams: grams.toDouble(),
    cookingMethod: method,
    confidence: scanned.confidence,
    kcal: kcal,
    protein: protein,
    carbs: carbs,
    fat: fat,
    food: food,
    isEstimated: isEstimated,
    portions: food?.commonPortions ?? const [],
  );
}

ResolvedMealLine rescaleLine(ResolvedMealLine line, double newGrams) {
  if (line.grams <= 0) return line;
  final r = newGrams / line.grams;
  return line.copyWith(
    grams: newGrams,
    kcal: line.kcal * r,
    protein: line.protein * r,
    carbs: line.carbs * r,
    fat: line.fat * r,
  );
}

ResolvedMealLine recomputeWithMethod(
  ResolvedMealLine line,
  CookingMethod method, {
  FoodItem? oilFood,
}) {
  if (line.food == null && line.isEstimated) {
    return line.copyWith(cookingMethod: method);
  }
  final scanned = ScannedFoodItem(
    nameAr: line.nameAr,
    nameEn: line.nameEn,
    foodIdGuess: line.food?.id,
    estimatedGrams: line.grams,
    cookingMethod: method,
    confidence: line.confidence,
  );
  return resolveLine(
    scanned: scanned,
    food: line.food,
    estimatedPer100g: line.food == null && line.grams > 0
        ? FoodMacros100g(
            kcal: line.kcal / line.grams * 100,
            protein: line.protein / line.grams * 100,
            carbs: line.carbs / line.grams * 100,
            fat: line.fat / line.grams * 100,
            fiber: 0,
          )
        : null,
    methodOverride: method,
    oilFood: oilFood,
  );
}

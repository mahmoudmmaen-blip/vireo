import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';
import 'package:vireo/features/nutrition/data/meal_resolution_service.dart'
    show encodeFavorites;

const _favoritesKey = 'meal_favorites_v1';
const _recentKey = 'meal_recent_v1';

class SavedMealSnippet {
  const SavedMealSnippet({
    required this.id,
    required this.labelAr,
    required this.labelEn,
    required this.kcal,
    required this.linesJson,
    required this.savedAt,
  });

  final String id;
  final String labelAr;
  final String labelEn;
  final int kcal;
  final List<Map<String, dynamic>> linesJson;
  final DateTime savedAt;

  factory SavedMealSnippet.fromJson(Map<String, dynamic> json) {
    return SavedMealSnippet(
      id: json['id']?.toString() ?? '',
      labelAr: json['label_ar']?.toString() ?? '',
      labelEn: json['label_en']?.toString() ?? '',
      kcal: (json['kcal'] as num?)?.toInt() ?? 0,
      linesJson: (json['lines'] as List? ?? [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      savedAt: DateTime.tryParse(json['saved_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label_ar': labelAr,
        'label_en': labelEn,
        'kcal': kcal,
        'lines': linesJson,
        'saved_at': savedAt.toIso8601String(),
      };

  factory SavedMealSnippet.fromLines(List<ResolvedMealLine> lines) {
    final labelAr =
        lines.map((l) => l.nameAr).where((n) => n.isNotEmpty).join(' + ');
    final labelEn =
        lines.map((l) => l.nameEn).where((n) => n.isNotEmpty).join(' + ');
    final kcal = lines.fold<double>(0, (s, l) => s + l.kcal).round();
    final encoded = jsonDecode(encodeFavorites(lines)) as List;
    return SavedMealSnippet(
      id: 'meal_${DateTime.now().millisecondsSinceEpoch}',
      labelAr: labelAr.isEmpty ? 'وجبة' : labelAr,
      labelEn: labelEn.isEmpty ? 'Meal' : labelEn,
      kcal: kcal,
      linesJson: encoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      savedAt: DateTime.now(),
    );
  }

  Future<MealScanDraft> toDraft() async {
    final db = FoodDbRepository.instance;
    await db.load();
    final oil = db.byId('sunflower_oil') ?? db.byId('olive_oil');
    final lines = <ResolvedMealLine>[];
    for (final raw in linesJson) {
      final foodId = raw['food_id']?.toString();
      final food = foodId == null || foodId.isEmpty ? null : db.byId(foodId);
      final grams = (raw['grams'] as num?)?.toDouble() ?? 100;
      final method = CookingMethod.fromString(raw['cooking_method']?.toString());
      final safeGrams = grams <= 0 ? 100.0 : grams;
      lines.add(
        resolveLine(
          scanned: ScannedFoodItem(
            nameAr: raw['name_ar']?.toString() ?? '',
            nameEn: raw['name_en']?.toString() ?? '',
            foodIdGuess: foodId,
            estimatedGrams: safeGrams,
            cookingMethod: method,
            confidence: 1,
          ),
          food: food,
          gramsOverride: safeGrams,
          oilFood: oil,
          estimatedPer100g: food == null
              ? FoodMacros100g(
                  kcal: ((raw['kcal'] as num?)?.toDouble() ?? 0) *
                      100 /
                      safeGrams,
                  protein: ((raw['protein'] as num?)?.toDouble() ?? 0) *
                      100 /
                      safeGrams,
                  carbs: ((raw['carbs'] as num?)?.toDouble() ?? 0) *
                      100 /
                      safeGrams,
                  fat: ((raw['fat'] as num?)?.toDouble() ?? 0) *
                      100 /
                      safeGrams,
                  fiber: 0,
                )
              : null,
        ),
      );
    }
    return MealScanDraft(
      lines: lines,
      imageBytes: Uint8List(0),
    );
  }
}

class MealFavoritesNotifier extends Notifier<List<SavedMealSnippet>> {
  @override
  List<SavedMealSnippet> build() => _load(_favoritesKey);

  Future<void> add(List<ResolvedMealLine> lines) async {
    final snippet = SavedMealSnippet.fromLines(lines);
    final next = [
      snippet,
      ...state.where(
        (e) => e.labelEn != snippet.labelEn || e.kcal != snippet.kcal,
      ),
    ].take(30).toList();
    state = next;
    await _persist(_favoritesKey, next);
  }

  Future<void> remove(String id) async {
    final next = state.where((e) => e.id != id).toList();
    state = next;
    await _persist(_favoritesKey, next);
  }
}

class MealRecentNotifier extends Notifier<List<SavedMealSnippet>> {
  @override
  List<SavedMealSnippet> build() => _load(_recentKey);

  Future<void> push(List<ResolvedMealLine> lines) async {
    final snippet = SavedMealSnippet.fromLines(lines);
    final next = [
      snippet,
      ...state.where(
        (e) =>
            e.labelEn != snippet.labelEn || (e.kcal - snippet.kcal).abs() > 5,
      ),
    ].take(20).toList();
    state = next;
    await _persist(_recentKey, next);
  }
}

List<SavedMealSnippet> _load(String key) {
  if (!HiveService.isInitialized) return const [];
  final raw = HiveService.cacheBox.get(key);
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((e) => SavedMealSnippet.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

Future<void> _persist(String key, List<SavedMealSnippet> items) async {
  if (!HiveService.isInitialized) return;
  await HiveService.cacheBox.put(key, items.map((e) => e.toJson()).toList());
}

final mealFavoritesProvider =
    NotifierProvider<MealFavoritesNotifier, List<SavedMealSnippet>>(
  MealFavoritesNotifier.new,
);

final mealRecentProvider =
    NotifierProvider<MealRecentNotifier, List<SavedMealSnippet>>(
  MealRecentNotifier.new,
);

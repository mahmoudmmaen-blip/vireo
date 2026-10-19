import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/nutrition/providers/food_log_stats.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';
import 'package:vireo/features/nutrition/providers/repeat_meal_service.dart';

SavedMealSnippet _snip(
  String id,
  DateTime at,
  List<String> foodIds,
) {
  return SavedMealSnippet(
    id: id,
    labelAr: id,
    labelEn: id,
    kcal: 400,
    linesJson: foodIds
        .map((fid) => <String, dynamic>{'food_id': fid, 'grams': 100})
        .toList(),
    savedAt: at,
  );
}

void main() {
  final now = DateTime(2026, 10, 19, 12);

  group('FoodLogStats.recentFoodIds', () {
    test('orders by newest meal and dedupes', () {
      final older = _snip('a', DateTime(2026, 10, 17), ['ful', 'bread']);
      final newer = _snip('b', DateTime(2026, 10, 18), ['ful', 'eggs']);
      final ids = FoodLogStats.recentFoodIds(
        history: [
          SlotMealRecord(
            day: '2026-10-17',
            slot: MealType.breakfast,
            snippet: older,
          ),
          SlotMealRecord(
            day: '2026-10-18',
            slot: MealType.breakfast,
            snippet: newer,
          ),
        ],
        recents: const [],
      );
      expect(ids, ['ful', 'eggs', 'bread']);
    });
  });

  group('FoodLogStats.frequentFoodIds', () {
    test('ranks by count within window', () {
      final a = _snip('a', DateTime(2026, 10, 10), ['ful', 'bread']);
      final b = _snip('b', DateTime(2026, 10, 12), ['ful']);
      final c = _snip('c', DateTime(2026, 10, 14), ['ful', 'eggs']);
      final ranked = FoodLogStats.frequentFoodIds(
        history: [
          SlotMealRecord(day: '2026-10-10', slot: MealType.breakfast, snippet: a),
          SlotMealRecord(day: '2026-10-12', slot: MealType.breakfast, snippet: b),
          SlotMealRecord(day: '2026-10-14', slot: MealType.breakfast, snippet: c),
        ],
        recents: const [],
        now: now,
      );
      expect(ranked.first.id, 'ful');
      expect(ranked.first.count, 3);
      expect(ranked.map((e) => e.id).toList(), containsAll(['bread', 'eggs']));
    });

    test('ignores meals outside the window', () {
      final old = _snip('old', DateTime(2026, 8, 1), ['ancient']);
      final ranked = FoodLogStats.frequentFoodIds(
        history: [
          SlotMealRecord(
            day: '2026-08-01',
            slot: MealType.lunch,
            snippet: old,
          ),
        ],
        recents: const [],
        now: now,
        windowDays: 30,
      );
      expect(ranked, isEmpty);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/utils/meal_diversity.dart';

void main() {
  group('MealDiversity §8 history window', () {
    test('defaultHistoryDays is 14 per spec', () {
      expect(MealDiversity.defaultHistoryDays, 14);
    });

    test('recentRecipeIds excludes entries older than window', () {
      final reference = DateTime(2026, 8, 22);
      final history = [
        (
          recipeId: 'old-recipe',
          servedAt: reference.subtract(const Duration(days: 20)),
        ),
        (
          recipeId: 'recent-recipe',
          servedAt: reference.subtract(const Duration(days: 5)),
        ),
      ];

      final blocked = MealDiversity.recentRecipeIds(
        history: history,
        reference: reference,
        withinDays: MealDiversity.defaultHistoryDays,
      );

      expect(blocked, {'recent-recipe'});
      expect(blocked, isNot(contains('old-recipe')));
    });
  });

  group('MealDiversity §8 pickAlternative', () {
    test('returns first candidate not in blocked set', () {
      expect(
        MealDiversity.pickAlternative(
          candidates: ['a', 'b', 'c'],
          blockedIds: {'a', 'b'},
        ),
        'c',
      );
    });

    test('returns null when all candidates blocked', () {
      expect(
        MealDiversity.pickAlternative(
          candidates: ['a', 'b'],
          blockedIds: {'a', 'b'},
        ),
        isNull,
      );
    });
  });
}

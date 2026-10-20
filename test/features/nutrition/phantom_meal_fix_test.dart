import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/nutrition/data/phantom_meal_cleanup.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/daily_nutrition_totals_provider.dart';

void main() {
  group('P56 phantom meal', () {
    test('fresh install: day log empty and eaten kcal is 0', () {
      // No overrides — must match real cold-start defaults.
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final confirmed = container.read(confirmedMealsProvider);
      final totals = container.read(dailyNutritionTotalsProvider);
      final today = container.read(todayNutritionProvider('ar'));

      expect(confirmed, isEmpty);
      expect(totals.calories, 0);
      expect(today.eatenKcal, 0);
      expect(today.items, isEmpty);
    });

    test('cleanup flags demo catalog titles and demo ids only', () {
      expect(
        PhantomMealCleanup.isSeedOrDemoEntry({
          'id': 'demo-b1',
          'logged_at': '2026-01-01T08:00:00.000',
          'result': {'food_name': 'Anything', 'calories': 320},
        }),
        isTrue,
      );
      expect(
        PhantomMealCleanup.isSeedOrDemoEntry({
          'id': 'ai_meal_123',
          'logged_at': '2026-01-01T08:00:00.000',
          'result': {
            'food_name': 'Egg & Cheese Omelette',
            'calories': 320,
          },
        }),
        isTrue,
      );
      expect(
        PhantomMealCleanup.isSeedOrDemoEntry({
          'id': 'ai_meal_999',
          'logged_at': '2026-01-01T12:00:00.000',
          'result': {
            'food_name': 'كشري بلدي',
            'calories': 650,
          },
        }),
        isFalse,
      );
    });
  });
}

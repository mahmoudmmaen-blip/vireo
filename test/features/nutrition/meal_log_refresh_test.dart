import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/nutrition/providers/daily_nutrition_totals_provider.dart';

void main() {
  test('saving a meal updates daily totals and today nutrition eaten', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final beforeTotals = container.read(dailyNutritionTotalsProvider);
    final beforeToday = container.read(todayNutritionProvider('en'));
    expect(beforeTotals.calories, 0);
    expect(beforeToday.eatenKcal, 0);

    await container.read(aiMealLogProvider.notifier).save(
          const FoodAnalysisResult(
            foodName: 'Eggs + bread',
            calories: 420,
            protein: 28,
            carbs: 30,
            fats: 18,
            portionEstimate: '1 plate',
            isHighCalorie: false,
            smartSwaps: [],
          ),
        );

    final afterTotals = container.read(dailyNutritionTotalsProvider);
    final afterToday = container.read(todayNutritionProvider('en'));
    expect(afterTotals.calories, 420);
    expect(afterTotals.protein, 28);
    expect(afterToday.eatenKcal, 420);
    expect(afterToday.items.where((i) => i.isAi), isNotEmpty);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/home_widget_sync.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';
import 'package:vireo/features/nutrition/providers/repeat_meal_service.dart';

/// One-tap re-log of a saved meal snippet (no review screen).
abstract final class MealRelogService {
  /// Persists [snippet] into today's log for [slot].
  /// Returns total kcal logged, or null if the draft could not be built.
  static Future<int?> quickConfirm({
    required WidgetRef ref,
    required SavedMealSnippet snippet,
    required MealType slot,
    BuildContext? context,
  }) async {
    final draft = await snippet.toDraft();
    if (draft.lines.isEmpty) return null;

    final result = draft.toAnalysisResult();
    await ref.read(aiMealLogProvider.notifier).save(result);
    await ref.read(mealRecentProvider.notifier).push(draft.lines);
    await ref.read(mealSlotHistoryProvider.notifier).record(slot, draft.lines);
    ref.read(confirmedMealsProvider.notifier).update((s) => {...s, slot});
    ref.invalidate(todayNutritionProvider);

    if (context != null && context.mounted) {
      await syncHomeScreenWidget(ref, context: context, force: true);
    }

    return draft.lines.fold<double>(0, (sum, line) => sum + line.kcal).round();
  }
}

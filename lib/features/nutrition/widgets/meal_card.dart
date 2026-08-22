import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/data/repositories/meal_plan_repository.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';

class MealCard extends ConsumerWidget {
  const MealCard({
    super.key,
    required this.entry,
    this.onSwapped,
  });

  final MealPlanEntry entry;
  final VoidCallback? onSwapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final recipe = entry.recipe;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_iconFor(entry.mealType), color: colors.ember),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.localizedTitle(locale),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.nutritionPrepMinutes(recipe.prepTimeMinutes),
                        style: TextStyle(color: colors.textMute, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _GoalTagChip(tag: recipe.goalTag, l10n: l10n),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _swapMeal(context, ref, l10n),
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: Text(l10n.nutritionSwapMeal),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _swapMeal(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    if (SupabaseService.isInitialized) {
      final updated =
          await ref.read(mealPlanRepositoryProvider).swapMeal(entry);
      if (!context.mounted) return;
      if (updated != null) {
        ref.invalidate(todayMealsProvider);
        onSwapped?.call();
        return;
      }
    }

    final alternatives = ref.read(mealPlanRepositoryProvider).demoAlternativesFor(
          entry.mealType,
          excludeRecipeId: entry.recipe.id,
        );
    if (!context.mounted) return;

    if (alternatives.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nutritionSwapMealEmpty)),
      );
      return;
    }

    final picked = await showModalBottomSheet<Recipe>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => _SwapMealSheet(
        alternatives: alternatives,
        l10n: l10n,
        locale: Localizations.localeOf(context).languageCode,
      ),
    );
    if (picked == null || !context.mounted) return;

    ref.read(demoMealOverridesProvider.notifier).update(
          (state) => {...state, entry.mealType: picked},
        );
    onSwapped?.call();
  }

  IconData _iconFor(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast_outlined;
      case MealType.lunch:
        return Icons.lunch_dining_outlined;
      case MealType.dinner:
        return Icons.dinner_dining_outlined;
      case MealType.snack:
        return Icons.cookie_outlined;
    }
  }
}

class _SwapMealSheet extends StatelessWidget {
  const _SwapMealSheet({
    required this.alternatives,
    required this.l10n,
    required this.locale,
  });

  final List<Recipe> alternatives;
  final AppLocalizations l10n;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.nutritionSwapMeal,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.nutritionSwapMealSubtitle,
              style: TextStyle(color: context.vireoColors.textMute),
            ),
            const SizedBox(height: 16),
            ...alternatives.map(
              (recipe) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.restaurant_outlined),
                title: Text(recipe.localizedTitle(locale)),
                subtitle: Text(l10n.nutritionPrepMinutes(recipe.prepTimeMinutes)),
                onTap: () => Navigator.of(context).pop(recipe),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalTagChip extends StatelessWidget {
  const _GoalTagChip({required this.tag, required this.l10n});

  final RecipeGoalTag tag;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final label = switch (tag) {
      RecipeGoalTag.highProtein => l10n.nutritionTagHighProtein,
      RecipeGoalTag.quickEasy => l10n.nutritionTagQuickEasy,
      RecipeGoalTag.lightEnergy => l10n.nutritionTagLightEnergy,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.ember.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: colors.ember, fontSize: 11),
      ),
    );
  }
}

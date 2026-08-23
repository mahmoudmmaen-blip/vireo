import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/data/repositories/meal_plan_repository.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/widgets/meal_builder_panel.dart';
import 'package:vireo/features/nutrition/widgets/meal_swap_sheet.dart';

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
    final confirmed = ref.watch(confirmedMealsProvider).contains(entry.mealType);
    final builder = ref.watch(mealBuilderProvider(entry.mealType));
    final macros = builder.macros;
    final showBuilderMacros = macros.calories > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: VireoDecorations.premiumCard(colors, glow: confirmed),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: VireoDecorations.mealThumbnail(colors),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_iconFor(entry.mealType), color: colors.text),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.localizedTitle(locale),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _GoalTagChip(tag: recipe.goalTag, l10n: l10n),
                          if (confirmed) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colors.success.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(VireoDecorations.chipRadius),
                              ),
                              child: Text(
                                l10n.nutritionMealConfirmed,
                                style: TextStyle(color: colors.success, fontSize: 11),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '⏱️ ${l10n.nutritionPrepMinutes(recipe.prepTimeMinutes)}',
                        style: TextStyle(color: colors.textMute, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showBuilderMacros || recipe.calories > 0) ...[
              const SizedBox(height: 12),
              Text(
                l10n.nutritionMacroBar,
                style: TextStyle(color: colors.textMute, fontSize: 11),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _MacroChip(
                    label: '${showBuilderMacros ? macros.calories : recipe.calories}',
                    colors: colors,
                  ),
                  _MacroChip(
                    label: '${showBuilderMacros ? macros.proteinG : recipe.proteinG}g',
                    colors: colors,
                  ),
                  _MacroChip(
                    label: '${showBuilderMacros ? macros.carbsG : recipe.carbsG}g',
                    colors: colors,
                  ),
                  _MacroChip(
                    label: '${showBuilderMacros ? macros.fatG : recipe.fatG}g',
                    colors: colors,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
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

    final picked = await MealSwapSheet.show(
      context,
      alternatives: alternatives,
      locale: Localizations.localeOf(context).languageCode,
    );
    if (picked == null || !context.mounted) return;

    ref.read(demoMealOverridesProvider.notifier).update(
          (state) => {...state, entry.mealType: picked},
        );
    onSwapped?.call();
  }

  IconData _iconFor(MealType type) {
    return switch (type) {
      MealType.breakfast => Icons.free_breakfast_outlined,
      MealType.lunch => Icons.lunch_dining_outlined,
      MealType.dinner => Icons.dinner_dining_outlined,
      MealType.snack => Icons.cookie_outlined,
    };
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label, required this.colors});

  final String label;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 6),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.line),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: colors.textMute),
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
    final (label, color) = switch (tag) {
      RecipeGoalTag.highProtein => (l10n.nutritionTagHighProtein, colors.ember),
      RecipeGoalTag.quickEasy => (l10n.nutritionTagQuickEasy, colors.gold),
      RecipeGoalTag.lightEnergy => (l10n.nutritionTagLightEnergy, colors.success),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(VireoDecorations.chipRadius),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}

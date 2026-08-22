import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';

class RecipeSuggestionCard extends StatelessWidget {
  const RecipeSuggestionCard({
    super.key,
    required this.recipe,
    required this.locale,
    this.onTap,
  });

  final Recipe recipe;
  final String locale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final tagLabel = switch (recipe.goalTag) {
      RecipeGoalTag.highProtein => l10n.nutritionTagHighProtein,
      RecipeGoalTag.quickEasy => l10n.nutritionTagQuickEasy,
      RecipeGoalTag.lightEnergy => l10n.nutritionTagLightEnergy,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.localizedTitle(locale),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: colors.textMute),
                const SizedBox(width: 4),
                Text(
                  l10n.nutritionPrepMinutes(recipe.prepTimeMinutes),
                  style: TextStyle(color: colors.textMute),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tagLabel,
                    style: TextStyle(color: colors.gold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

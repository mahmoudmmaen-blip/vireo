import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';

/// Horizontal chips for favorites + recent meals (one-tap re-log).
class MealQuickRelogRow extends ConsumerWidget {
  const MealQuickRelogRow({super.key});

  Future<void> _open(BuildContext context, SavedMealSnippet snippet) async {
    final draft = await snippet.toDraft();
    if (!context.mounted) return;
    await MealReviewScreen.open(context, draft);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final favorites = ref.watch(mealFavoritesProvider);
    final recent = ref.watch(mealRecentProvider);
    if (favorites.isEmpty && recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (favorites.isNotEmpty) ...[
          Text(
            l10n.mealFavoritesTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: favorites.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final s = favorites[i];
                final label = locale == 'ar' ? s.labelAr : s.labelEn;
                return ActionChip(
                  avatar: Icon(Icons.star, size: 16, color: colors.ember),
                  label: Text('$label · ${s.kcal}'),
                  onPressed: () => _open(context, s),
                );
              },
            ),
          ),
          const SizedBox(height: VSpace.md),
        ],
        if (recent.isNotEmpty) ...[
          Text(
            l10n.mealRecentTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recent.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final s = recent[i];
                final label = locale == 'ar' ? s.labelAr : s.labelEn;
                return ActionChip(
                  label: Text('$label · ${s.kcal}'),
                  onPressed: () => _open(context, s),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/home/widgets/saved_meals_sheets.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';
import 'package:vireo/features/nutrition/providers/repeat_meal_service.dart';

/// One-tap repeat row: "زي امبارح" (same slot yesterday) + "وجباتي" (favorites).
class MealQuickRelogRow extends ConsumerWidget {
  const MealQuickRelogRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final recent = ref.watch(mealRecentProvider);
    final favorites = ref.watch(mealFavoritesProvider);
    final slot = RepeatMealService.slotForTime(DateTime.now());
    final yesterday = ref.watch(yesterdaySameSlotProvider(slot));

    // Same slot yesterday if we know it, otherwise the latest recent meal.
    final repeat = yesterday ?? (recent.isNotEmpty ? recent.first : null);

    if (repeat == null && favorites.isEmpty && recent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, size: 16, color: colors.ember),
              const SizedBox(width: 6),
              Text(
                'سريع: زي امبارح أو وجباتي',
                style: TextStyle(
                  color: colors.textMute,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (repeat != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ActionChip(
                      avatar: const Icon(Icons.replay_rounded, size: 16),
                      label: Text(
                        '${yesterday != null ? 'زي امبارح' : 'آخر وجبة'} (${repeat.labelAr} · ${repeat.kcal} سعرة)',
                      ),
                      backgroundColor: colors.surfaceRaised,
                      side: BorderSide(color: colors.line),
                      onPressed: () async {
                        final draft = await repeat.toDraft();
                        if (context.mounted) {
                          await MealReviewScreen.open(
                            context,
                            draft,
                            slot: slot,
                          );
                        }
                      },
                    ),
                  ),
                ...favorites.take(3).map(
                  (fav) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ActionChip(
                      avatar: Icon(Icons.star_rounded, size: 16, color: colors.gold),
                      label: Text('وجباتي: ${fav.labelAr} (${fav.kcal} سعرة)'),
                      backgroundColor: colors.surfaceRaised,
                      side: BorderSide(color: colors.line),
                      onPressed: () async {
                        final draft = await fav.toDraft();
                        if (context.mounted) {
                          await MealReviewScreen.open(context, draft);
                        }
                      },
                    ),
                  ),
                ),
                if (favorites.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ActionChip(
                      avatar: Icon(Icons.star_outline_rounded, size: 16, color: colors.gold),
                      label: Text(l10n.mealFavoritesTitle),
                      backgroundColor: colors.surfaceRaised,
                      side: BorderSide(color: colors.line),
                      onPressed: () => showFavoriteMealsSheet(context, slot: slot),
                    ),
                  ),
                if (recent.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ActionChip(
                      avatar: Icon(Icons.history_rounded, size: 16, color: colors.ember),
                      label: Text(l10n.mealRecentTitle),
                      backgroundColor: colors.surfaceRaised,
                      side: BorderSide(color: colors.line),
                      onPressed: () => showRecentMealsSheet(context, slot: slot),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

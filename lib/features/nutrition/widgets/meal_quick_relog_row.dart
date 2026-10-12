import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';

class MealQuickRelogRow extends ConsumerWidget {
  const MealQuickRelogRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final recent = ref.watch(mealRecentProvider);
    final favorites = ref.watch(mealFavoritesProvider);

    if (recent.isEmpty && favorites.isEmpty) {
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
                'سريع: كرر وجبة سابقة أو مفضلة',
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
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (recent.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ActionChip(
                      avatar: const Icon(Icons.repeat_rounded, size: 16),
                      label: Text('كرر وجبة امبارح (${recent.first.labelAr} · ${recent.first.kcal} سعرة)'),
                      backgroundColor: colors.surfaceRaised,
                      side: BorderSide(color: colors.line),
                      onPressed: () async {
                        final draft = await recent.first.toDraft();
                        if (context.mounted) {
                          await MealReviewScreen.open(context, draft);
                        }
                      },
                    ),
                  ),
                ...favorites.take(3).map(
                  (fav) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ActionChip(
                      avatar: const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      label: Text('${fav.labelAr} (${fav.kcal} سعرة)'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

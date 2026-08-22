import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/data/repositories/meal_plan_repository.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/home/providers/daily_program_provider.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';

/// Summary card for today's workout and upcoming meal.
class DailyProgramCard extends ConsumerWidget {
  const DailyProgramCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final workoutAsync = ref.watch(todayWorkoutProvider);
    final mealsAsync = ref.watch(effectiveTodayMealsProvider);
    final nextMealType = ref.watch(nextMealTypeProvider);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.today_outlined, color: colors.ember, size: 22),
                const SizedBox(width: 10),
                Text(
                  l10n.homeDailyProgramTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            workoutAsync.when(
              loading: () => _RowSkeleton(label: l10n.homeTodayWorkout),
              error: (_, __) => _ProgramRow(
                icon: Icons.fitness_center_outlined,
                label: l10n.homeTodayWorkout,
                value: l10n.authErrorGeneric,
                colors: colors,
              ),
              data: (session) {
                final lead = session.exercises.isNotEmpty
                    ? session.exercises.first
                    : null;
                final title = lead == null
                    ? l10n.workoutTitle
                    : lead.localizedName(locale);
                return _ProgramRow(
                  icon: Icons.fitness_center_outlined,
                  label: l10n.homeTodayWorkout,
                  value: title,
                  detail: l10n.homeWorkoutExerciseCount(session.exercises.length),
                  colors: colors,
                );
              },
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: colors.line),
            const SizedBox(height: 14),
            mealsAsync.when(
              loading: () => _RowSkeleton(label: l10n.homeNextMeal),
              error: (_, __) => _ProgramRow(
                icon: Icons.restaurant_outlined,
                label: l10n.homeNextMeal,
                value: l10n.authErrorGeneric,
                colors: colors,
              ),
              data: (meals) {
                MealPlanEntry? entry;
                for (final meal in meals) {
                  if (meal.mealType == nextMealType) {
                    entry = meal;
                    break;
                  }
                }
                entry ??= meals.isNotEmpty ? meals.first : null;

                return _ProgramRow(
                  icon: Icons.restaurant_outlined,
                  label: l10n.homeNextMeal,
                  value: entry?.recipe.localizedTitle(locale) ?? l10n.nutritionNoRecipesFound,
                  detail: _mealTypeLabel(l10n, entry?.mealType ?? nextMealType),
                  colors: colors,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _mealTypeLabel(AppLocalizations l10n, MealType type) {
    return switch (type) {
      MealType.breakfast => l10n.nutritionTabBreakfast,
      MealType.lunch => l10n.nutritionTabLunch,
      MealType.dinner => l10n.nutritionTabDinner,
      MealType.snack => l10n.nutritionTabSnack,
    };
  }
}

class _ProgramRow extends StatelessWidget {
  const _ProgramRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.detail,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? detail;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.ember.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colors.ember, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (detail != null) ...[
                const SizedBox(height: 2),
                Text(
                  detail!,
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 12),
        Text(label),
      ],
    );
  }
}

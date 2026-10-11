import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/nutrition/providers/daily_nutrition_totals_provider.dart';

class DailyCalorieGoalCard extends ConsumerWidget {
  const DailyCalorieGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final target = ref.watch(calorieGoalProvider);
    final totals = ref.watch(dailyNutritionTotalsProvider);
    final inbody = ref.watch(latestBodyCompositionProvider);
    final consumed = totals.calories;
    final progress = target.calories > 0
        ? (consumed / target.calories).clamp(0.0, 1.0)
        : 0.0;
    final carbsMax = ref.watch(activeDietTargetsProvider)?.carbsMaxG;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.nutritionDailyCalorieGoal,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: l10n.nutritionEditCalorieGoal,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _showEditDialog(context, ref, target.calories),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.nutritionCalorieTargetSummary(
                target.calories,
                target.proteinG,
                target.carbsG,
                target.fatG,
              ),
              style: TextStyle(color: colors.textMute, fontSize: 13),
            ),
            if (inbody?.leanMassKg != null) ...[
              const SizedBox(height: 4),
              Text(
                l10n.inbodyFromDateLabel(
                  DateFormat.yMMMd().format(inbody!.testDate),
                ),
                style: TextStyle(color: colors.ember, fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: colors.line,
                color: colors.ember,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.nutritionCalorieProgress(consumed, target.calories),
              style: TextStyle(color: colors.textMute, fontSize: 12),
            ),
            if (carbsMax != null && carbsMax > 0) ...[
              const SizedBox(height: 14),
              Text(
                l10n.dietCarbsLimitLabel,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (totals.carbs / carbsMax).clamp(0.0, 1.5).clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: colors.line,
                  color: totals.carbs > carbsMax ? colors.danger : VMacro.carbs,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.dietCarbsLimitProgress(
                  totals.carbs.round(),
                  carbsMax,
                ),
                style: TextStyle(
                  color: totals.carbs > carbsMax ? colors.danger : colors.textMute,
                  fontSize: 12,
                  fontWeight: totals.carbs > carbsMax
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: current.toString());
    final result = await showDialog<int?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.nutritionEditCalorieGoal),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: l10n.nutritionCalorieHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: Text(l10n.deleteAccountCancel),
          ),
          TextButton(
            onPressed: () {
              final v = int.tryParse(controller.text.trim());
              Navigator.pop(ctx, v);
            },
            child: Text(l10n.progressSaveWeight),
          ),
        ],
      ),
    );
    if (result != null && context.mounted) {
      await setManualCalorieGoal(result);
      ref.invalidate(calorieGoalProvider);
    }
  }
}

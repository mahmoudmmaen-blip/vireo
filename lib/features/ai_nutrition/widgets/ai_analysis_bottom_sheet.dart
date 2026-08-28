import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/features/ai_nutrition/domain/food_analysis_result.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_budget_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showAiAnalysisBottomSheet(
  BuildContext context,
  FoodAnalysisResult result,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _AiAnalysisSheetBody(result: result),
  );
}

class _AiAnalysisSheetBody extends ConsumerWidget {
  const _AiAnalysisSheetBody({required this.result});

  final FoodAnalysisResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final remaining = ref.watch(remainingCaloriesForAiScanProvider);
    final highCalorie = result.isHighCalorie ||
        result.calories > 600 ||
        result.calories > remaining;
    final calorieColor = highCalorie ? colors.gold : colors.success;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.foodName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: calorieColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: calorieColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    l10n.aiScanCaloriesChip(result.calories),
                    style: TextStyle(
                      color: calorieColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            if (result.portionEstimate.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                result.portionEstimate,
                style: TextStyle(color: colors.textMute, fontSize: 13),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _MacroTile(
                    label: l10n.aiScanMacroProtein,
                    value: result.protein,
                    color: const Color(0xFF5BA4F5),
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MacroTile(
                    label: l10n.aiScanMacroCarbs,
                    value: result.carbs,
                    color: const Color(0xFFFF9F43),
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MacroTile(
                    label: l10n.aiScanMacroFats,
                    value: result.fats,
                    color: const Color(0xFFFF6B6B),
                    colors: colors,
                  ),
                ),
              ],
            ),
            if (highCalorie && result.warningMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.gold.withValues(alpha: 0.35)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: colors.gold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        result.warningMessage!,
                        style: TextStyle(color: colors.text, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (result.smartSwaps.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l10n.aiScanSmartSwaps,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...result.smartSwaps.map(
                (swap) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, size: 18, color: colors.ember),
                      const SizedBox(width: 8),
                      Expanded(child: Text(swap)),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                await ref.read(aiMealLogProvider.notifier).save(result);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.aiScanSavedSnack)),
                );
              },
              child: Text(l10n.aiScanSaveToLog),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({
    required this.label,
    required this.value,
    required this.color,
    required this.colors,
  });

  final String label;
  final double value;
  final Color color;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: colors.textMute, fontSize: 11),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(0)}g',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

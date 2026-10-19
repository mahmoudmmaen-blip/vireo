import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/estimated_kcal_label.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/home/mascot/domain/mascot_state.dart';
import 'package:vireo/features/home/mascot/providers/mascot_settings_provider.dart';
import 'package:vireo/features/home/mascot/widgets/calorie_mascot_wave.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/progress/screens/weekly_charts_screen.dart';

/// Home calories card (P49): remaining kcal hero + mascot wave as progress.
class CaloriesTodayMascotCard extends ConsumerWidget {
  const CaloriesTodayMascotCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');
    final nutrition = ref.watch(todayNutritionProvider(locale));
    final settings = ref.watch(mascotSettingsProvider);
    final isFemale = ref.watch(isFemaleUserProvider);
    final activeDiet = ref.watch(activeDietProgramProvider);
    final goalMeta = ref.watch(calorieGoalProvider);

    final title = isArabic ? 'سعراتك النهارده' : "Today's calories";
    final targetSource = activeDiet != null
        ? (isArabic
            ? 'الهدف من: ${activeDiet.name.ar}'
            : 'Target from: ${activeDiet.name.en}')
        : (isArabic ? 'الهدف من إعداداتك' : 'Target from your settings');

    final goalKcal =
        nutrition.goalKcal > 0 ? nutrition.goalKcal : goalMeta.calories;
    final remaining = nutrition.remainingKcal;
    final remainingAbs = remaining.abs();
    final isOver = nutrition.isOver;

    final proteinRatio = nutrition.proteinTarget > 0
        ? (nutrition.proteinG / nutrition.proteinTarget).clamp(0.0, 1.0)
        : 0.0;
    final carbsRatio = nutrition.carbsTarget > 0
        ? (nutrition.carbsG / nutrition.carbsTarget).clamp(0.0, 1.0)
        : 0.0;
    final fatRatio = nutrition.fatTarget > 0
        ? (nutrition.fatG / nutrition.fatTarget).clamp(0.0, 1.0)
        : 0.0;

    void openWeeklyCharts() => WeeklyChartsScreen.open(context);
    void quickLog() => AiScanScreen.open(context, ref);

    final caption = isArabic
        ? mascotCaptionAr(
            remainingKcal: remaining.clamp(0, 99999),
            isOver: isOver,
            isFemale: isFemale,
          )
        : mascotCaptionEn(
            remainingKcal: remaining.clamp(0, 99999),
            isOver: isOver,
          );

    final heroColor = isOver
        ? colors.danger
        : remaining > 200
            ? colors.success
            : colors.ember;

    return VireoCard(
      onTap: () => ref.read(shellTabIndexProvider.notifier).goNutrition(),
      // P50: orange is accent-only — no full-card ember glow.
      padding:
          const EdgeInsets.fromLTRB(VSpace.md, VSpace.md, VSpace.md, VSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              // P53: one tap to weekly steps/calories/weight charts.
              TextButton(
                onPressed: openWeeklyCharts,
                style: TextButton.styleFrom(
                  foregroundColor: colors.ember,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(48, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isArabic ? 'التفاصيل' : 'Details',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            targetSource,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: colors.textMute, fontSize: 11.5),
          ),
          const SizedBox(height: VSpace.sm),

          // P49: remaining (فاضل) is the hero; wave (or classic ring) is progress.
          if (settings.useClassicRing)
            Center(
              child: GestureDetector(
                onTap: openWeeklyCharts,
                onLongPress: quickLog,
                child: RingProgress(
                  progress: goalKcal > 0
                      ? nutrition.eatenKcal / goalKcal
                      : 0,
                  color: colors.ember,
                  size: 96,
                  stroke: 10,
                ),
              ),
            )
          else
            Center(
              child: CalorieMascotWave(
                consumedKcal: nutrition.eatenKcal,
                targetKcal: goalKcal,
                companion: settings.companion,
                size: 120,
                showMacroLayers: false,
                proteinRatio: proteinRatio * 0.34,
                carbsRatio: carbsRatio * 0.33,
                fatRatio: fatRatio * 0.33,
                isFemale: isFemale,
                showCaption: false,
                onTap: openWeeklyCharts,
                onLongPress: quickLog,
              ),
            ),
          const SizedBox(height: VSpace.sm),

          Text(
            isOver
                ? (isArabic ? 'زيادة' : 'Over')
                : (isArabic ? 'فاضل' : 'Left'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.textMute,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '≈ ${formatCount(remainingAbs)}',
            textAlign: TextAlign.center,
            style: VType.number(
              size: 40,
              weight: FontWeight.w900,
              color: heroColor,
            ),
          ),
          Text(
            isArabic ? 'سعرة' : 'kcal',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.textMute,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isArabic
                ? 'أكلت ≈ ${formatCount(nutrition.eatenKcal)} من ${formatCount(goalKcal)} سعرة'
                : 'Eaten ≈ ${formatCount(nutrition.eatenKcal)} of ${formatCount(goalKcal)} kcal',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.textMute,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: VSpace.xs),
          Text(
            caption,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textMute,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: VSpace.sm),
          Row(
            children: [
              _MacroGoalChip(
                label: l10n.uxProtein,
                valueG: nutrition.proteinG,
                goalG: nutrition.proteinTarget.toDouble(),
                color: VMacro.protein,
                isArabic: isArabic,
              ),
              const SizedBox(width: 8),
              _MacroGoalChip(
                label: l10n.uxCarbs,
                valueG: nutrition.carbsG,
                goalG: nutrition.carbsTarget.toDouble(),
                color: VMacro.carbs,
                isArabic: isArabic,
              ),
              const SizedBox(width: 8),
              _MacroGoalChip(
                label: l10n.uxFat,
                valueG: nutrition.fatG,
                goalG: nutrition.fatTarget.toDouble(),
                color: VMacro.fat,
                isArabic: isArabic,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroGoalChip extends StatelessWidget {
  const _MacroGoalChip({
    required this.label,
    required this.valueG,
    required this.goalG,
    required this.color,
    required this.isArabic,
  });

  final String label;
  final double valueG;
  final double goalG;
  final Color color;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final ratio = goalG > 0 ? (valueG / goalG).clamp(0.0, 1.0) : 0.0;
    final unit = isArabic ? 'جم' : 'g';

    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMute,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${valueG.round()}',
              textAlign: TextAlign.center,
              style: VType.number(
                size: 20,
                weight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              '/ ${goalG.round()} $unit',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMute,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 3,
                backgroundColor: color.withValues(alpha: 0.15),
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

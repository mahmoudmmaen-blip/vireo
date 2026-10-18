import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/estimated_kcal_label.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/home/mascot/domain/mascot_state.dart';
import 'package:vireo/features/home/mascot/providers/mascot_settings_provider.dart';
import 'package:vireo/features/home/mascot/widgets/calorie_mascot_wave.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/insights/screens/score_insights_screen.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';

/// Home card #4: "سعراتك النهارده" — mascot wave + remaining + P/C/F.
///
/// Does NOT duplicate Daily Score remaining-macro rectangles; Daily Score
/// stays focused on score / tips / next-meal.
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

    final proteinRatio = nutrition.proteinTarget > 0
        ? (nutrition.proteinG / nutrition.proteinTarget).clamp(0.0, 1.0)
        : 0.0;
    final carbsRatio = nutrition.carbsTarget > 0
        ? (nutrition.carbsG / nutrition.carbsTarget).clamp(0.0, 1.0)
        : 0.0;
    final fatRatio = nutrition.fatTarget > 0
        ? (nutrition.fatG / nutrition.fatTarget).clamp(0.0, 1.0)
        : 0.0;

    void openInsights() => ScoreInsightsScreen.open(context);
    void quickLog() => AiScanScreen.open(context, ref);

    final caption = isArabic
        ? mascotCaptionAr(
            remainingKcal: nutrition.remainingKcal.clamp(0, 99999),
            isOver: nutrition.isOver,
            isFemale: isFemale,
          )
        : mascotCaptionEn(
            remainingKcal: nutrition.remainingKcal.clamp(0, 99999),
            isOver: nutrition.isOver,
          );

    return VireoCard(
      onTap: () => ref.read(shellTabIndexProvider.notifier).goNutrition(),
      glow: colors.ember,
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
              Icon(Icons.chevron_right_rounded,
                  color: colors.textMute, size: 20),
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
          Text(
            formatCount(nutrition.eatenKcal),
            textAlign: TextAlign.center,
            style: VType.number(
              size: 32,
              weight: FontWeight.w800,
              color: colors.ember,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isArabic
                ? 'من أصل ${formatCount(goalKcal)} سعرة'
                : 'of ${formatCount(goalKcal)} kcal',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textMute, fontSize: 14),
          ),
          const SizedBox(height: VSpace.sm),
          Center(child: _RemainingBadge(remaining: nutrition.remainingKcal)),
          const SizedBox(height: VSpace.sm),
          Row(
            children: [
              _MacroPill(
                label: l10n.uxProtein,
                value: nutrition.proteinG,
                color: VMacro.protein,
              ),
              const SizedBox(width: 8),
              _MacroPill(
                label: l10n.uxCarbs,
                value: nutrition.carbsG,
                color: VMacro.carbs,
              ),
              const SizedBox(width: 8),
              _MacroPill(
                label: l10n.uxFat,
                value: nutrition.fatG,
                color: VMacro.fat,
              ),
            ],
          ),
          if (!settings.useClassicRing) ...[
            const SizedBox(height: VSpace.sm),
            Center(
              child: CalorieMascotWave(
                consumedKcal: nutrition.eatenKcal,
                targetKcal: goalKcal,
                companion: settings.companion,
                size: 72,
                showMacroLayers: settings.showMacroLayers,
                proteinRatio: proteinRatio * 0.34,
                carbsRatio: carbsRatio * 0.33,
                fatRatio: fatRatio * 0.33,
                isFemale: isFemale,
                showCaption: false,
                onTap: openInsights,
                onLongPress: quickLog,
              ),
            ),
          ],
          if (!settings.useClassicRing) ...[
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
          ],
        ],
      ),
    );
  }
}

class _RemainingBadge extends StatelessWidget {
  const _RemainingBadge({required this.remaining});

  final int remaining;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final color = remaining > 200
        ? colors.success
        : remaining >= 50
            ? colors.ember
            : colors.danger;
    final label = remaining < 0
        ? (isArabic ? 'زيادة ${formatCount(remaining.abs())}' : '${formatCount(remaining.abs())} over')
        : (isArabic ? 'فاضل ${formatCount(remaining)}' : '${formatCount(remaining)} left');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  const _MacroPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '$label ${value.round()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

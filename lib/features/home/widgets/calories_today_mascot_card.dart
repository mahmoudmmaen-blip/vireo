import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (settings.useClassicRing)
                RingProgress(
                  progress: nutrition.progress,
                  size: 108,
                  stroke: 10,
                  color: nutrition.isOver ? colors.gold : colors.ember,
                  secondaryColor: colors.gold,
                  trackColor: colors.line.withValues(alpha: 0.55),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${nutrition.remainingKcal.abs()}',
                        style: VType.number(
                          size: 20,
                          weight: FontWeight.w800,
                          color: colors.text,
                        ),
                      ),
                      Text(
                        nutrition.isOver
                            ? (isArabic ? 'زيادة' : 'over')
                            : (isArabic ? 'فاضلة' : 'left'),
                        style: TextStyle(
                          color: colors.textMute,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                CalorieMascotWave(
                  consumedKcal: nutrition.eatenKcal,
                  targetKcal: goalKcal,
                  companion: settings.companion,
                  size: 112,
                  showMacroLayers: settings.showMacroLayers,
                  proteinRatio: proteinRatio * 0.34,
                  carbsRatio: carbsRatio * 0.33,
                  fatRatio: fatRatio * 0.33,
                  isFemale: isFemale,
                  showCaption: false,
                  onTap: openInsights,
                  onLongPress: quickLog,
                ),
              const SizedBox(width: VSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? '${nutrition.remainingKcal.abs()} سعرة ${nutrition.isOver ? 'زيادة' : 'فاضلة'}'
                          : '${nutrition.remainingKcal.abs()} kcal ${nutrition.isOver ? 'over' : 'left'}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: nutrition.isOver ? colors.gold : colors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic
                          ? 'أكلت ${nutrition.eatenKcal} من $goalKcal'
                          : 'Ate ${nutrition.eatenKcal} of $goalKcal',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.textMute, fontSize: 12),
                    ),
                    const SizedBox(height: VSpace.sm),
                    _MiniMacro(
                      label: l10n.uxProtein,
                      value: nutrition.proteinG,
                      target: nutrition.proteinTarget.toDouble(),
                      color: VMacro.protein,
                    ),
                    const SizedBox(height: 6),
                    _MiniMacro(
                      label: l10n.uxCarbs,
                      value: nutrition.carbsG,
                      target: nutrition.carbsTarget.toDouble(),
                      color: VMacro.carbs,
                    ),
                    const SizedBox(height: 6),
                    _MiniMacro(
                      label: l10n.uxFat,
                      value: nutrition.fatG,
                      target: nutrition.fatTarget.toDouble(),
                      color: VMacro.fat,
                    ),
                  ],
                ),
              ),
            ],
          ),
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

class _MiniMacro extends StatelessWidget {
  const _MiniMacro({
    required this.label,
    required this.value,
    required this.target,
    required this.color,
  });

  final String label;
  final double value;
  final double target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final progress = target > 0 ? (value / target).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: colors.textMute,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '${value.round()}/${target.round()}',
              style: TextStyle(
                color: colors.text,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: colors.line.withValues(alpha: 0.5),
            color: color,
          ),
        ),
      ],
    );
  }
}

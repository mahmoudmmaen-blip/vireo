import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';
import 'package:vireo/features/home/providers/home_dashboard_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/insights/screens/score_insights_screen.dart';
import 'package:vireo/features/insights/widgets/next_meal_suggestion_card.dart';
import 'package:vireo/features/water/providers/water_daily_goal_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';

/// Redesigned Daily Score Hero Card (Section 3):
/// - Big 120dp score ring with large bold type, "/100", and state label
/// - 2×2 grid of "what you still need today" rectangles (protein, carbs, fat, calories)
/// - Optional fifth chip: water remaining cups
/// - Smart insight line at the bottom
/// - Tap opens ScoreInsightsScreen
class DailyScoreHeroCard extends ConsumerWidget {
  const DailyScoreHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdown = ref.watch(dailyScoreProvider);
    final streak = ref.watch(dailyScoreStreakProvider);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');

    final nutrition = ref.watch(todayNutritionProvider(locale));
    final waterMl = ref.watch(waterTrackerProvider);
    final waterGoalMl = ref.watch(waterDailyGoalMlProvider);
    final remainingWaterGlasses = ((waterGoalMl - waterMl) / 250).ceil().clamp(0, 20);

    // Remaining targets
    final remProtein = (nutrition.proteinTarget - nutrition.proteinG).round();
    final remCarbs = (nutrition.carbsTarget - nutrition.carbsG).round();
    final remFat = (nutrition.fatTarget - nutrition.fatG).round();
    final remKcal = (nutrition.goalKcal - nutrition.eatenKcal);

    // Smart insight line
    final dash = ref.watch(homeDashboardProvider);
    final remSteps = (dash.stepsGoal - dash.stepsToday).clamp(0, 50000);
    final smartInsight = (breakdown.totalScore < 75 && remSteps > 0 && remProtein > 0)
        ? (isArabic
            ? 'لو مشيت $remSteps خطوة كمان وأكلت $remProtein جم بروتين هتوصل 75/100 🎯'
            : 'Walk $remSteps more steps and eat $remProtein g protein to hit 75/100 🎯')
        : (isArabic
            ? 'أداءك قوي اليوم! استمر في المحافظة على التوازن والنشاط 💪'
            : 'Strong performance today! Keep up the momentum 💪');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => ScoreInsightsScreen.open(context),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: breakdown.scoreColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Row: Big 120dp Score Ring on Left/Start, Score Tier & Streak
                Row(
                  children: [
                    // Big 116dp Ring
                    SizedBox(
                      width: 116,
                      height: 116,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 116,
                            height: 116,
                            child: CircularProgressIndicator(
                              value: (breakdown.totalScore / 100.0).clamp(0.0, 1.0),
                              strokeWidth: 9.0,
                              backgroundColor: colors.line,
                              valueColor: AlwaysStoppedAnimation<Color>(breakdown.scoreColor),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${breakdown.totalScore}',
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      height: 1.0,
                                      fontFeatures: [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '/100',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.textMute,
                                      fontWeight: FontWeight.w800,
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),

                    // Right Side: Title, Tier, Streak badge, Chevron
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  isArabic ? 'سكور اليوم' : 'Daily Score',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: colors.textMute),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: breakdown.scoreColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              breakdown.scoreTierLabel,
                              style: TextStyle(
                                color: breakdown.scoreColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          if (streak > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('🔥', style: TextStyle(fontSize: 13)),
                                const SizedBox(width: 4),
                                Text(
                                  isArabic ? '$streak أيام متتالية' : '$streak day streak',
                                  style: TextStyle(
                                    color: colors.ember,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // 2×2 Grid of "What you still need today" rectangles
                Row(
                  children: [
                    Expanded(
                      child: _RemainingTargetRect(
                        label: isArabic ? 'بروتين' : 'Protein',
                        remainingVal: remProtein,
                        unit: 'جم',
                        actual: nutrition.proteinG,
                        target: nutrition.proteinTarget.toDouble(),
                        color: VMacro.protein,
                        isArabic: isArabic,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RemainingTargetRect(
                        label: isArabic ? 'كارب' : 'Carbs',
                        remainingVal: remCarbs,
                        unit: 'جم',
                        actual: nutrition.carbsG,
                        target: nutrition.carbsTarget.toDouble(),
                        color: VMacro.carbs,
                        isArabic: isArabic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _RemainingTargetRect(
                        label: isArabic ? 'دهون' : 'Fat',
                        remainingVal: remFat,
                        unit: 'جم',
                        actual: nutrition.fatG,
                        target: nutrition.fatTarget.toDouble(),
                        color: VMacro.fat,
                        isArabic: isArabic,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RemainingTargetRect(
                        label: isArabic ? 'سعرات' : 'Calories',
                        remainingVal: remKcal,
                        unit: '',
                        actual: nutrition.eatenKcal.toDouble(),
                        target: nutrition.goalKcal.toDouble(),
                        color: colors.ember,
                        isArabic: isArabic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Optional fifth chip: Water remaining
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: VMacro.water.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: VMacro.water.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.water_drop_rounded, size: 16, color: VMacro.water),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          remainingWaterGlasses <= 0
                              ? (isArabic ? 'الماء: تمام ✓ حققت هدف الترطيب' : 'Water: Hydration goal met ✓')
                              : (isArabic ? 'مية: باقي $remainingWaterGlasses أكواب' : 'Water: $remainingWaterGlasses cups left'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                NextMealSuggestionCard(
                  remainingKcal: remKcal,
                  remainingProtein: remProtein.toDouble(),
                  remainingCarbs: remCarbs.toDouble(),
                  remainingFat: remFat.toDouble(),
                ),
                const SizedBox(height: 12),

                // One smart insight line at the bottom
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded, size: 16, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          smartInsight,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: colors.text,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RemainingTargetRect extends StatelessWidget {
  const _RemainingTargetRect({
    required this.label,
    required this.remainingVal,
    required this.unit,
    required this.actual,
    required this.target,
    required this.color,
    required this.isArabic,
  });

  final String label;
  final int remainingVal;
  final String unit;
  final double actual;
  final double target;
  final Color color;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isReached = remainingVal == 0;
    final isExceeded = remainingVal < 0;

    String statusText;
    Color statusColor;

    if (isReached) {
      statusText = isArabic ? 'تمام ✓' : 'Done ✓';
      statusColor = const Color(0xFF10B981);
    } else if (isExceeded) {
      statusText = isArabic ? 'زيادة ${remainingVal.abs()} $unit'.trim() : '+${remainingVal.abs()} $unit'.trim();
      statusColor = const Color(0xFFF59E0B);
    } else {
      statusText = isArabic ? 'باقي $remainingVal $unit'.trim() : '$remainingVal $unit left'.trim();
      statusColor = colors.text;
    }

    final frac = target > 0 ? (actual / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.textMute,
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: statusColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: frac,
              minHeight: 4,
              backgroundColor: colors.line.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(
                isExceeded ? const Color(0xFFF59E0B) : (isReached ? const Color(0xFF10B981) : color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


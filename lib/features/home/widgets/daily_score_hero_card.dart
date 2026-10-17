import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';
import 'package:vireo/features/home/providers/home_dashboard_provider.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/insights/screens/score_insights_screen.dart';
import 'package:vireo/features/insights/widgets/next_meal_suggestion_card.dart';

/// Daily Score Hero Card (P36):
/// - Big score ring with "/100" and state label
/// - Next-meal suggestion + smart insight
/// - Remaining P/C/F live on سعراتك النهارده (mascot card) — not duplicated here
/// - Tap opens ScoreInsightsScreen
class DailyScoreHeroCard extends ConsumerWidget {
  const DailyScoreHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdown = ref.watch(dailyScoreProvider);
    final streak = ref.watch(dailyScoreStreakProvider);
    final streakDetails = ref.watch(dailyScoreStreakDetailsProvider);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');
    final ringColor = breakdown.displayColor(colors.ember);

    final nutrition = ref.watch(todayNutritionProvider(locale));

    // Remaining targets (for next-meal suggestion only)
    final remProtein = (nutrition.proteinTarget - nutrition.proteinG).round();
    final remCarbs = (nutrition.carbsTarget - nutrition.carbsG).round();
    final remFat = (nutrition.fatTarget - nutrition.fatG).round();
    final remKcal = (nutrition.goalKcal - nutrition.eatenKcal);

    // Smart insight line
    final dash = ref.watch(homeDashboardProvider);
    final remSteps = (dash.stepsGoal - dash.stepsToday).clamp(0, 50000);
    final smartInsight = breakdown.showsNeutralStart
        ? (isArabic
            ? breakdown.nextActionTip
            : 'Your day is just starting — log your first meal to get moving 🍳')
        : (breakdown.totalScore < 75 && remSteps > 0 && remProtein > 0)
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
                color: ringColor.withValues(alpha: 0.35),
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
                              valueColor: AlwaysStoppedAnimation<Color>(ringColor),
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
                              color: ringColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              breakdown.showsNeutralStart && !isArabic
                                  ? 'Your day is just starting ☀️'
                                  : breakdown.displayLabel,
                              style: TextStyle(
                                color: ringColor,
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
                            if (streakDetails.usedRestDay)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  isArabic
                                      ? 'يوم راحة اتحسب معاك 🌿'
                                      : 'A rest day was counted for you 🌿',
                                  style: TextStyle(
                                    color: colors.textMute,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // P36: remaining P/C/F/kcal live on سعراتك النهارده (mascot card).
                // Daily Score focuses on score, tips, and next-meal suggestion.
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


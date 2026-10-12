import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/home/providers/daily_score_provider.dart';

/// Hero card on Home displaying the 0-100 Daily Score ("سكور اليوم"),
/// animated circular progress ring, and streak badge.
class DailyScoreHeroCard extends ConsumerWidget {
  const DailyScoreHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdown = ref.watch(dailyScoreProvider);
    final streak = ref.watch(dailyScoreStreakProvider);
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showBreakdownSheet(context, breakdown, streak, isArabic),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: breakdown.scoreColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Animated Ring
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: breakdown.totalScore / 100.0,
                        strokeWidth: 6.5,
                        backgroundColor: colors.line,
                        valueColor: AlwaysStoppedAnimation<Color>(breakdown.scoreColor),
                        strokeCap: StrokeCap.round,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${breakdown.totalScore}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            '/100',
                            style: TextStyle(
                              fontSize: 9,
                              color: colors.textMute,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isArabic ? 'سكور اليوم' : 'Daily Score',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          if (streak > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colors.ember.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    isArabic ? '$streak أيام' : '$streak days',
                                    style: TextStyle(
                                      color: colors.ember,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        breakdown.scoreTierLabel,
                        style: TextStyle(
                          color: breakdown.scoreColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isArabic
                            ? 'اضغط لعرض تفاصيل التقييم والنصائح اليومية'
                            : 'Tap to view breakdown & next steps',
                        style: TextStyle(
                          color: colors.textMute,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: colors.textMute),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBreakdownSheet(
    BuildContext context,
    DailyScoreBreakdown breakdown,
    int streak,
    bool isArabic,
  ) {
    final colors = context.vireoColors;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.line,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'تفاصيل سكور اليوم 🎯' : 'Daily Score Breakdown 🎯',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                    Text(
                      '${breakdown.totalScore}/100',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: breakdown.scoreColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Factor bars
                _factorRow('الخطوات والنشاط (25)', breakdown.stepsScore, 25, colors),
                _factorRow('البروتين المكتمل (20)', breakdown.proteinScore, 20, colors),
                _factorRow('توازن السعرات ±10% (15)', breakdown.caloriesScore, 15, colors),
                _factorRow('شرب الماء (15)', breakdown.waterScore, 15, colors),
                _factorRow('التمرين اليومي (15)', breakdown.workoutScore, 15, colors),
                _factorRow('النوم والتعافي (10)', breakdown.sleepScore, 10, colors),

                if (breakdown.tips.isNotEmpty) ...[
                  const Divider(height: 28),
                  Text(
                    isArabic ? 'نصائح لرفع السكور اليوم:' : 'How to boost your score today:',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ...breakdown.tips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right_rounded, color: colors.ember, size: 20),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(fontSize: 12.5, color: colors.textMute),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _factorRow(String label, double val, double max, VireoColors colors) {
    final frac = (val / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
              Text('${val.round()}/$max', style: TextStyle(fontSize: 12, color: colors.textMute)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: frac,
              backgroundColor: colors.line,
              valueColor: AlwaysStoppedAnimation<Color>(
                frac >= 1.0 ? colors.success : (frac >= 0.5 ? colors.gold : colors.ember),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

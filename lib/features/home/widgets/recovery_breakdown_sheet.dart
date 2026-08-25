import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/recovery_score_calculator.dart';

Future<void> showRecoveryBreakdownSheet(
  BuildContext context,
  RecoveryBreakdown breakdown,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx);
      final colors = ctx.vireoColors;
      final score = breakdown.totalScore;
      return Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          24 + MediaQuery.paddingOf(ctx).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homeRecoveryScore,
                      style: Theme.of(ctx).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    '$score%',
                    style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                          color: colors.success,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.homeRecoveryFormulaExplain,
                style: TextStyle(color: colors.textMute),
              ),
              const SizedBox(height: 16),
              _WeightedFactor(
                icon: Icons.spa_outlined,
                title: l10n.homeRecoveryFactorRestDays,
                weightLabel: '40%',
                score: breakdown.restDaysScore.round(),
                contribution: breakdown.restContribution,
                detail: l10n.homeRecoveryRestDetail(breakdown.weeklyRestDays),
                tip: l10n.homeRecoveryTipRest,
                colors: colors,
              ),
              _WeightedFactor(
                icon: Icons.directions_walk_outlined,
                title: l10n.homeRecoveryFactorSteps,
                weightLabel: '30%',
                score: breakdown.stepsScore.round(),
                contribution: breakdown.stepsContribution,
                detail: l10n.homeRecoveryStepsDetail(
                  breakdown.stepsToday,
                  breakdown.stepsGoal,
                ),
                tip: l10n.homeRecoveryTipSteps,
                colors: colors,
              ),
              _WeightedFactor(
                icon: Icons.check_circle_outline,
                title: l10n.homeRecoveryFactorConsistency,
                weightLabel: '30%',
                score: breakdown.consistencyScore.round(),
                contribution: breakdown.consistencyContribution,
                detail: l10n.homeRecoveryConsistencyDetail(
                  breakdown.mealsConfirmed,
                  breakdown.mealsPlanned,
                  breakdown.workoutCompletedThisWeek,
                  breakdown.workoutsPlannedThisWeek,
                ),
                tip: l10n.homeRecoveryTipConsistency,
                colors: colors,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.success.withValues(alpha: 0.35)),
                ),
                child: Text(
                  l10n.homeRecoveryMathLine(
                    breakdown.restContribution,
                    breakdown.stepsContribution,
                    breakdown.consistencyContribution,
                    score,
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: colors.success,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.homeRecoveryImproveTitle,
                style: Theme.of(ctx).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.homeRecoveryImproveBody,
                style: TextStyle(color: colors.textMute),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.continueButton),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _WeightedFactor extends StatelessWidget {
  const _WeightedFactor({
    required this.icon,
    required this.title,
    required this.weightLabel,
    required this.score,
    required this.contribution,
    required this.detail,
    required this.tip,
    required this.colors,
  });

  final IconData icon;
  final String title;
  final String weightLabel;
  final int score;
  final int contribution;
  final String detail;
  final String tip;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.recovery),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '$weightLabel → +$contribution',
                      style: TextStyle(
                        color: colors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$score% · $detail',
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
                Text(tip, style: TextStyle(color: colors.textMute, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

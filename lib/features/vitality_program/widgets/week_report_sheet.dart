import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality_program/domain/vitality_program_phase.dart';
import 'package:vireo/features/vitality_program/providers/vitality_program_provider.dart';

class WeekReportSheet extends ConsumerWidget {
  const WeekReportSheet({super.key, required this.weekNumber});

  final int weekNumber;

  static Future<void> show(BuildContext context, int weekNumber) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => WeekReportSheet(weekNumber: weekNumber),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final report = ref
        .read(vitalityProgramProvider.notifier)
        .getWeeklyReport(weekNumber);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.vitalityWeekReport,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text(
            l10n.vitalityWeekX(weekNumber),
            style: TextStyle(color: colors.textMute),
          ),
          const SizedBox(height: 16),
          _StatRow(
            label: l10n.vitalityReportCompletion,
            value: '${report.completionPercentage.toStringAsFixed(0)}%',
            colors: colors,
          ),
          _StatRow(
            label: l10n.vitalityMorningEnergy,
            value: report.averageMorningEnergy.toStringAsFixed(1),
            colors: colors,
            trend: report.energyTrend,
          ),
          _StatRow(
            label: l10n.vitalitySleepQuality,
            value: report.averageSleepQuality.toStringAsFixed(1),
            colors: colors,
            trend: report.sleepTrend,
          ),
          _StatRow(
            label: l10n.vitalityWorkoutPerformance,
            value: report.averageWorkoutPerformance.toStringAsFixed(1),
            colors: colors,
            trend: report.workoutTrend,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: report.isImproving
                  ? colors.success.withValues(alpha: 0.12)
                  : colors.surfaceRaised,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              report.isImproving
                  ? l10n.vitalityReportImproving
                  : l10n.vitalityReportKeepGoing,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: report.isImproving ? colors.success : colors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.colors,
    this.trend,
  });

  final String label;
  final String value;
  final VireoColors colors;
  final VitalityTrendDirection? trend;

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    Color? iconColor;
    if (trend != null) {
      icon = switch (trend!) {
        VitalityTrendDirection.improving => Icons.trending_up,
        VitalityTrendDirection.declining => Icons.trending_down,
        VitalityTrendDirection.stable => Icons.trending_flat,
      };
      iconColor = switch (trend!) {
        VitalityTrendDirection.improving => colors.success,
        VitalityTrendDirection.declining => colors.ember,
        VitalityTrendDirection.stable => colors.textMute,
      };
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          if (icon != null) Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

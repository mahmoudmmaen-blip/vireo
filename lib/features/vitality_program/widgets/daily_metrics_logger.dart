import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality_program/domain/vitality_metrics.dart';
import 'package:vireo/features/vitality_program/providers/vitality_program_provider.dart';

class DailyMetricsLogger extends ConsumerStatefulWidget {
  const DailyMetricsLogger({super.key, this.compact = false});

  final bool compact;

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const Padding(
        padding: EdgeInsets.only(top: 8),
        child: DailyMetricsLogger(),
      ),
    );
  }

  @override
  ConsumerState<DailyMetricsLogger> createState() => _DailyMetricsLoggerState();
}

class _DailyMetricsLoggerState extends ConsumerState<DailyMetricsLogger> {
  double _energy = 5;
  double _sleep = 5;
  double _workout = 5;
  double _stress = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final history = ref.watch(vitalityMetricsProvider);
    final last7 = ref.read(vitalityMetricsProvider.notifier).lastDays(7);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.vitalityMetricsTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          _MetricSlider(
            label: l10n.vitalityMorningEnergy,
            value: _energy,
            color: colors.gold,
            onChanged: (v) => setState(() => _energy = v),
          ),
          _MetricSlider(
            label: l10n.vitalitySleepQuality,
            value: _sleep,
            color: colors.recovery,
            onChanged: (v) => setState(() => _sleep = v),
          ),
          _MetricSlider(
            label: l10n.vitalityWorkoutPerformance,
            value: _workout,
            color: colors.ember,
            onChanged: (v) => setState(() => _workout = v),
          ),
          _MetricSlider(
            label: l10n.vitalityStressLevel,
            value: _stress,
            color: colors.ember,
            onChanged: (v) => setState(() => _stress = v),
          ),
          if (last7.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l10n.vitalityMetricsLast7Days,
              style: TextStyle(color: colors.textMute, fontSize: 12),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: _MiniSparkline(
                      values: last7.map((m) => m.morningEnergyScore.toDouble()).toList(),
                      color: colors.gold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MiniSparkline(
                      values: last7.map((m) => m.sleepQuality.toDouble()).toList(),
                      color: colors.recovery,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await ref.read(vitalityMetricsProvider.notifier).logMetrics(
                    VitalityMetrics(
                      date: DateTime.now(),
                      morningEnergyScore: _energy.round().clamp(1, 10),
                      sleepQuality: _sleep.round().clamp(1, 10),
                      workoutPerformance: _workout.round().clamp(1, 10),
                      stressLevel: _stress.round().clamp(1, 10),
                    ),
                  );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.vitalityMetricsSaved)),
                );
              }
            },
            child: Text(l10n.vitalityMetricsSave),
          ),
          if (history.isEmpty && widget.compact)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.vitalityMetricsEmpty,
                style: TextStyle(color: colors.textMute, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricSlider extends StatelessWidget {
  const _MetricSlider({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final double value;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${value.round()}/10', style: TextStyle(color: color)),
            ],
          ),
          Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: color,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _MiniSparkline extends StatelessWidget {
  const _MiniSparkline({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.12),
            ),
          ),
        ],
        minY: 0,
        maxY: 10,
      ),
    );
  }
}

class DailyMetricsInlineCard extends ConsumerWidget {
  const DailyMetricsInlineCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final last = ref.watch(vitalityMetricsProvider).lastOrNull;

    return Material(
      color: colors.surfaceRaised,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => DailyMetricsLogger.show(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.insights_outlined, color: colors.recovery),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.vitalityMetricsTitle,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      last != null
                          ? l10n.vitalityMetricsLastEntry(last.morningEnergyScore)
                          : l10n.vitalityMetricsTapToLog,
                      style: TextStyle(color: colors.textMute, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.add_circle_outline, color: colors.ember),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/progress/providers/progress_provider.dart';
import 'package:vireo/features/progress/widgets/adherence_bar_chart.dart';
import 'package:vireo/features/progress/widgets/energy_line_chart.dart';
import 'package:vireo/features/progress/widgets/weight_line_chart.dart';
import 'package:vireo/features/progress/widgets/weight_log_sheet.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unit = ref.watch(unitPreferenceProvider);
    final logsAsync = ref.watch(weightLogsProvider);
    final goalAsync = ref.watch(weightGoalProvider);
    final weeksAsync = ref.watch(adherenceWeeksProvider);
    final energyAsync = ref.watch(energyCheckInsProvider);

    return FeatureScaffold(
      title: l10n.progressTitle,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(weightLogsProvider);
              ref.invalidate(weightGoalProvider);
              ref.invalidate(adherenceWeeksProvider);
              ref.invalidate(energyCheckInsProvider);
              await Future<void>.delayed(const Duration(milliseconds: 400));
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              children: [
                Text(
                  l10n.progressAllChartsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                logsAsync.when(
                  loading: () => const _ChartLoading(),
                  error: (_, __) => _ChartError(message: l10n.authErrorGeneric),
                  data: (logs) {
                    final goalKg = goalAsync.valueOrNull;
                    return _ChartCard(
                      title: l10n.progressWeightChartTitle,
                      subtitle: goalKg != null
                          ? l10n.progressWeightGoalLine(
                              UnitConverter.displayWeight(goalKg, unit)
                                  .toStringAsFixed(1),
                              UnitConverter.weightLabel(unit),
                            )
                          : null,
                      child: WeightLineChart(
                        logs: logs,
                        goalKg: goalKg,
                        unit: unit,
                        dateAxisLabel: l10n.progressAxisDate,
                        weightAxisLabel: l10n.progressAxisWeight,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                weeksAsync.when(
                  loading: () => const _ChartLoading(),
                  error: (_, __) => _ChartError(message: l10n.authErrorGeneric),
                  data: (weeks) => _ChartCard(
                    title: l10n.progressAdherenceChartTitle,
                    subtitle: l10n.progressAdherenceSubtitle,
                    child: AdherenceBarChart(weeks: weeks),
                  ),
                ),
                const SizedBox(height: 16),
                energyAsync.when(
                  loading: () => const _ChartLoading(),
                  error: (_, __) => _ChartError(message: l10n.authErrorGeneric),
                  data: (checkIns) => _ChartCard(
                    title: l10n.progressEnergyChartTitle,
                    subtitle: l10n.progressEnergySubtitle,
                    child: EnergyLineChart(
                      checkIns: checkIns,
                      energyAxisLabel: l10n.progressAxisEnergy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () => showWeightLogSheet(context, ref),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ChartLoading extends StatelessWidget {
  const _ChartLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 240,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ChartError extends StatelessWidget {
  const _ChartError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(child: Text(message)),
    );
  }
}

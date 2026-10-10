import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/activity/providers/wearable_health_provider.dart';
import 'package:vireo/features/activity/services/wearable_health_service.dart';
import 'package:vireo/features/activity/widgets/manual_sleep_sheet.dart';

class HealthHubScreen extends ConsumerWidget {
  const HealthHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(wearableHealthProvider);
    final stress = ref.watch(stressFromHrvProvider);
    final manualSleep = ref.watch(manualSleepTodayProvider);
    final colors = context.vireoColors;

    return FeatureScaffold(
      title: l10n.healthHubTitle,
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.authErrorGeneric)),
        data: (snap) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(wearableHealthProvider);
              ref.invalidate(stressFromHrvProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(VSpace.md),
              children: [
                Text(
                  l10n.healthNotMedical,
                  style: TextStyle(color: colors.textMute, fontSize: 12, height: 1.35),
                ),
                const SizedBox(height: VSpace.sm),
                if (!snap.hasAnyData)
                  VireoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.watch_outlined, size: 48, color: colors.ember),
                        const SizedBox(height: VSpace.sm),
                        Text(
                          l10n.healthConnectWatchTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.healthConnectWatchBody,
                          style: TextStyle(color: colors.textMute, height: 1.35),
                        ),
                        const SizedBox(height: VSpace.md),
                        FilledButton(
                          onPressed: () async {
                            await WearableHealthService.requestPermissions();
                            ref.invalidate(wearableHealthProvider);
                          },
                          child: Text(l10n.healthGrantPermission),
                        ),
                      ],
                    ),
                  ),
                for (final m in snap.metrics) ...[
                  const SizedBox(height: VSpace.sm),
                  _MetricCard(metric: m, l10n: l10n),
                ],
                if (snap.metrics.every((m) => m.kind != HealthMetricKind.sleep)) ...[
                  const SizedBox(height: VSpace.sm),
                  _ManualSleepCard(
                    entry: manualSleep,
                    onLog: () async {
                      await showManualSleepSheet(context, ref);
                      ref.read(manualSleepRevisionProvider.notifier).state++;
                    },
                  ),
                ],
                stress.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (s) {
                    if (s.level == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: VSpace.md),
                      child: VireoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.healthStressTitle,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(l10n.healthFromWatch),
                            const SizedBox(height: 8),
                            Text(
                              _stressLabel(l10n, s.level!),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: colors.ember,
                              ),
                            ),
                            if (s.todayHrvMs != null && s.baselineHrvMs != null)
                              Text(
                                l10n.healthHrvDetail(
                                  s.todayHrvMs!.round(),
                                  s.baselineHrvMs!.round(),
                                ),
                                style: TextStyle(color: colors.textMute, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _stressLabel(AppLocalizations l10n, StressLevel level) => switch (level) {
        StressLevel.low => l10n.healthStressLow,
        StressLevel.medium => l10n.healthStressMedium,
        StressLevel.high => l10n.healthStressHigh,
      };
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric, required this.l10n});

  final HealthMetricCardData metric;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return VireoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _title(l10n, metric.kind),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Text(l10n.healthFromWatch, style: TextStyle(color: colors.textMute, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${metric.todayValue} ${metric.unit}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: VSpace.sm),
          SizedBox(
            height: 72,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < metric.last7Days.length; i++)
                        FlSpot(i.toDouble(), metric.last7Days[i].value),
                    ],
                    isCurved: true,
                    color: colors.recovery,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _title(AppLocalizations l10n, HealthMetricKind k) => switch (k) {
        HealthMetricKind.heartRate => l10n.healthMetricHeartRate,
        HealthMetricKind.restingHeartRate => l10n.healthMetricRestingHr,
        HealthMetricKind.hrv => l10n.healthMetricHrv,
        HealthMetricKind.bloodOxygen => l10n.healthMetricSpO2,
        HealthMetricKind.sleep => l10n.healthMetricSleep,
        HealthMetricKind.weight => l10n.healthMetricWeight,
        HealthMetricKind.workout => l10n.healthMetricWorkout,
        HealthMetricKind.steps => l10n.healthMetricSteps,
      };
}

class _ManualSleepCard extends StatelessWidget {
  const _ManualSleepCard({required this.entry, required this.onLog});

  final ManualSleepEntry? entry;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    return VireoCard(
      onTap: onLog,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.healthManualSleepTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          if (entry == null)
            Text(l10n.healthManualSleepHint, style: TextStyle(color: colors.textMute))
          else ...[
            Text(l10n.healthSleepScore(entry!.score)),
            Text(
              '${DateFormat.jm().format(entry!.bedtime)} – ${DateFormat.jm().format(entry!.wakeTime)}',
              style: TextStyle(color: colors.textMute, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

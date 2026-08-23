import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/core/utils/walking_metrics_calculator.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/providers/walking_tracker_provider.dart';
import 'package:vireo/features/walking/widgets/health_permission_denied_view.dart';
import 'package:vireo/features/walking/widgets/step_ring_indicator.dart';
import 'package:vireo/features/walking/widgets/weekly_steps_chart.dart';

class WalkingTrackerScreen extends ConsumerWidget {
  const WalkingTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(walkingTrackerProvider);
    final notifier = ref.read(walkingTrackerProvider.notifier);

    return FeatureScaffold(
      title: l10n.walkingTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: notifier.refresh,
        ),
      ],
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => HealthPermissionDeniedView(
          onOpenSettings: notifier.openSettings,
          onRetry: notifier.requestPermission,
        ),
        data: (data) {
          if (data.status == HealthStepsStatus.denied) {
            return HealthPermissionDeniedView(
              onOpenSettings: notifier.openSettings,
              onRetry: notifier.requestPermission,
            );
          }
          if (data.status == HealthStepsStatus.unavailable) {
            // Web / desktop: still show estimated metrics from home demo steps.
            return _WalkingTrackerBody(
              data: data.copyWithDemoFallback(steps: 4200),
              onRefresh: notifier.refresh,
              allowUnavailableNote: true,
            );
          }

          return _WalkingTrackerBody(
            data: data,
            onRefresh: notifier.refresh,
          );
        },
      ),
    );
  }
}

extension on WalkingTrackerState {
  WalkingTrackerState copyWithDemoFallback({required int steps}) {
    return WalkingTrackerState(
      status: HealthStepsStatus.granted,
      todaySteps: todaySteps > 0 ? todaySteps : steps,
      dailyGoal: dailyGoal,
      last7Days: last7Days.isNotEmpty
          ? last7Days
          : List.generate(
              7,
              (i) => DailyStepCount(
                date: DateTime.now().subtract(Duration(days: 6 - i)),
                steps: steps,
              ),
            ),
    );
  }
}

class _WalkingTrackerBody extends StatelessWidget {
  const _WalkingTrackerBody({
    required this.data,
    required this.onRefresh,
    this.allowUnavailableNote = false,
  });

  final WalkingTrackerState data;
  final Future<void> Function() onRefresh;
  final bool allowUnavailableNote;

  double get _weightKg {
    final profile = HiveService.isInitialized
        ? HiveService.cacheBox.get('guest_profile')
        : null;
    if (profile is Map) {
      return (profile['weight_kg'] as num?)?.toDouble() ?? 75.0;
    }
    return 75.0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final metrics = WalkingMetricsCalculator.compute(
      steps: data.todaySteps,
      weightKg: _weightKg,
    );

    return RefreshIndicator(
      color: colors.ember,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: StepRingIndicator(
              steps: data.todaySteps,
              goal: data.dailyGoal,
              stepsLabel: l10n.walkingStepsToday,
              goalLabel: l10n.walkingDailyGoal(data.dailyGoal),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              l10n.walkingGoalProgress((data.progress * 100).round()),
              style: TextStyle(color: colors.textMute),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.walkingMetricsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.55,
            children: [
              _MetricTile(
                icon: Icons.straighten,
                label: l10n.walkingDistance,
                value: '${metrics.distanceKm.toStringAsFixed(2)} km',
                colors: colors,
              ),
              _MetricTile(
                icon: Icons.speed,
                label: l10n.walkingSpeed,
                value: '${metrics.speedKmh.toStringAsFixed(1)} km/h',
                colors: colors,
              ),
              _MetricTile(
                icon: Icons.timer_outlined,
                label: l10n.walkingPace,
                value: metrics.paceMinPerKm > 0
                    ? '${metrics.paceMinPerKm.toStringAsFixed(1)} min/km'
                    : '—',
                colors: colors,
              ),
              _MetricTile(
                icon: Icons.local_fire_department_outlined,
                label: l10n.walkingCalories,
                value: '${metrics.caloriesBurned} kcal',
                colors: colors,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: VireoDecorations.premiumCard(colors),
            child: Row(
              children: [
                Icon(Icons.monitor_weight_outlined, color: colors.ember),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.walkingWeightLoss(
                      metrics.estimatedWeightLossKg.toStringAsFixed(3),
                    ),
                    style: TextStyle(color: colors.textMute),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.walkingCadence(metrics.cadenceSpm.round()),
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textMute, fontSize: 12),
          ),
          const SizedBox(height: 28),
          WeeklyStepsChart(
            days: data.last7Days,
            title: l10n.walkingWeeklyChartTitle,
            goal: data.dailyGoal,
          ),
          const SizedBox(height: 16),
          Text(
            allowUnavailableNote
                ? l10n.walkingMetricsEstimatedNote
                : l10n.walkingHealthSourceNote,
            style: TextStyle(color: colors.textMute, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final String value;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.ember),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(fontSize: 11, color: colors.textMute)),
        ],
      ),
    );
  }
}

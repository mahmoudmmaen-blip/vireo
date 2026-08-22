import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
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
            return const HealthPermissionDeniedView(
              isUnavailable: true,
              onOpenSettings: _noop,
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

void _noop() {}

class _WalkingTrackerBody extends StatelessWidget {
  const _WalkingTrackerBody({
    required this.data,
    required this.onRefresh,
  });

  final WalkingTrackerState data;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

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
          const SizedBox(height: 28),
          WeeklyStepsChart(
            days: data.last7Days,
            title: l10n.walkingWeeklyChartTitle,
            goal: data.dailyGoal,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.walkingHealthSourceNote,
            style: TextStyle(color: colors.textMute, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

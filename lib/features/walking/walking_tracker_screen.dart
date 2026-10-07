import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/core/utils/walking_metrics_calculator.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
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
        error: (e, st) => HealthPermissionDeniedView(
          onOpenSettings: notifier.openSettings,
          onRetry: notifier.requestPermission,
        ),
        data: (data) {
          return _WalkingTrackerBody(
            data: data,
            onRefresh: notifier.refresh,
            onManualSteps: notifier.setManualSteps,
            allowUnavailableNote: data.manualEntryActive,
          );
        },
      ),
    );
  }
}

class _WalkingTrackerBody extends ConsumerStatefulWidget {
  const _WalkingTrackerBody({
    required this.data,
    required this.onRefresh,
    this.onManualSteps,
    this.allowUnavailableNote = false,
  });

  final WalkingTrackerState data;
  final Future<void> Function() onRefresh;
  final Future<void> Function(int steps)? onManualSteps;
  final bool allowUnavailableNote;

  @override
  ConsumerState<_WalkingTrackerBody> createState() => _WalkingTrackerBodyState();
}

class _WalkingTrackerBodyState extends ConsumerState<_WalkingTrackerBody> {
  late final TextEditingController _stepsCtrl;

  @override
  void initState() {
    super.initState();
    _stepsCtrl = TextEditingController(
      text: widget.data.todaySteps > 0 ? widget.data.todaySteps.toString() : '',
    );
  }

  @override
  void didUpdateWidget(covariant _WalkingTrackerBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.todaySteps != widget.data.todaySteps &&
        widget.data.todaySteps > 0) {
      _stepsCtrl.text = widget.data.todaySteps.toString();
    }
  }

  @override
  void dispose() {
    _stepsCtrl.dispose();
    super.dispose();
  }

  double get _weightKg {
    final profile = HiveService.isInitialized
        ? HiveService.cacheBox.get('guest_profile')
        : null;
    if (profile is Map) {
      return (profile['weight_kg'] as num?)?.toDouble() ?? 75.0;
    }
    return 75.0;
  }

  Future<void> _submitManualSteps() async {
    final steps = int.tryParse(_stepsCtrl.text.trim());
    if (steps == null || widget.onManualSteps == null) return;
    await widget.onManualSteps!(steps);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final data = widget.data;
    final metrics = WalkingMetricsCalculator.compute(
      steps: data.todaySteps,
      weightKg: _weightKg,
    );
    final showManual = data.manualEntryActive || kIsWeb;

    return RefreshIndicator(
      color: colors.ember,
      onRefresh: widget.onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: VireoDecorations.premiumCard(colors),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: colors.ember, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.walkingHealthBanner,
                        style: TextStyle(color: colors.textMute, height: 1.35),
                      ),
                    ),
                  ],
                ),
                if (kIsWeb) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.walkingWebManualBanner,
                    style: TextStyle(
                      color: colors.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: StepRingIndicator(
              steps: data.todaySteps,
              goal: data.dailyGoal,
              stepsLabel: l10n.walkingStepsToday,
              goalLabel: l10n.walkingDailyGoal(data.dailyGoal),
            ),
          ),
          const SizedBox(height: 8),
          if (data.todaySteps > 0)
            Center(
              child: Text(
                l10n.walkingEstimatedMinutes(data.estimatedWalkingMinutes),
                style: TextStyle(
                  color: colors.ember,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              l10n.walkingGoalProgress((data.progress * 100).round()),
              style: TextStyle(color: colors.textMute),
            ),
          ),
          if (showManual && widget.onManualSteps != null) ...[
            const SizedBox(height: 20),
            TextField(
              controller: _stepsCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.walkingManualStepsLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: _submitManualSteps,
              child: Text(l10n.walkingUpdateSteps),
            ),
          ],
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
            widget.allowUnavailableNote
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

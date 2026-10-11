import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/core/utils/walking_metrics_calculator.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/walking/data/body_metrics.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/features/walking/providers/walking_tracker_provider.dart';
import 'package:vireo/features/walking/widgets/step_permission_gate.dart';
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
          onPressed: () async {
            await notifier.refresh();
            ref.invalidate(stepCounterBootstrapProvider);
          },
        ),
      ],
      body: StepPermissionGate(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(
            child: TextButton(
              onPressed: notifier.refresh,
              child: Text(l10n.walkingTryAgain),
            ),
          ),
          data: (data) => _WalkingTrackerBody(
            data: data,
            onRefresh: notifier.refresh,
            onManualSteps: notifier.setManualSteps,
          ),
        ),
      ),
    );
  }
}

class _WalkingTrackerBody extends ConsumerStatefulWidget {
  const _WalkingTrackerBody({
    required this.data,
    required this.onRefresh,
    this.onManualSteps,
  });

  final WalkingTrackerState data;
  final Future<void> Function() onRefresh;
  final Future<void> Function(int steps)? onManualSteps;

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
    final live = ref.watch(liveStepsProvider).valueOrNull;
    final steps = live?.todaySteps ?? data.todaySteps;
    final last7 = live?.last7Days.isNotEmpty == true
        ? live!.last7Days
        : data.last7Days;
    final body = readBodyMetrics();
    final metrics = WalkingMetricsCalculator.compute(
      steps: steps,
      weightKg: body.weightKg,
      heightCm: body.heightCm,
    );
    final progress = data.dailyGoal <= 0
        ? 0.0
        : (steps / data.dailyGoal).clamp(0.0, 1.0);
    final showManual = data.manualEntryActive || kIsWeb;

    return RefreshIndicator(
      color: colors.ember,
      onRefresh: widget.onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(VSpace.lg),
        children: [
          Center(
            child: Text(
              '$steps',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 64,
                    height: 1,
                    color: colors.ember,
                  ),
            ),
          ),
          const SizedBox(height: VSpace.xs),
          Center(
            child: Text(
              l10n.walkingStepsToday,
              style: TextStyle(
                color: colors.textMute,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: VSpace.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: colors.line.withValues(alpha: 0.55),
              color: colors.ember,
            ),
          ),
          const SizedBox(height: VSpace.sm),
          Center(
            child: Text(
              l10n.walkingDailyGoal(data.dailyGoal),
              style: TextStyle(color: colors.textMute),
            ),
          ),
          Center(
            child: Text(
              l10n.walkingGoalProgress((progress * 100).round()),
              style: TextStyle(
                color: colors.ember,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: VSpace.xl),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.straighten,
                  label: l10n.walkingDistance,
                  value: '${metrics.distanceKm.toStringAsFixed(2)} km',
                  colors: colors,
                ),
              ),
              const SizedBox(width: VSpace.sm),
              Expanded(
                child: _MetricTile(
                  icon: Icons.local_fire_department_outlined,
                  label: l10n.walkingCalories,
                  value: '${metrics.caloriesBurned} kcal',
                  colors: colors,
                  footer: FatEquivalent.hasEquivalent(metrics.caloriesBurned)
                      ? FatEquivalentBadge(
                          kcal: metrics.caloriesBurned,
                          isBurned: true,
                          style: TextStyle(
                            color: colors.ember,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          showIcon: false,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: VSpace.sm),
              Expanded(
                child: _MetricTile(
                  icon: Icons.timer_outlined,
                  label: l10n.walkingActiveMinutes,
                  value: '${metrics.activeMinutes.round()} min',
                  colors: colors,
                ),
              ),
            ],
          ),
          if (showManual && widget.onManualSteps != null) ...[
            const SizedBox(height: VSpace.xl),
            TextField(
              controller: _stepsCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.walkingManualStepsLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: VSpace.sm),
            FilledButton(
              onPressed: _submitManualSteps,
              child: Text(l10n.walkingUpdateSteps),
            ),
          ],
          const SizedBox(height: VSpace.xl),
          WeeklyStepsChart(
            days: last7,
            title: l10n.walkingWeeklyChartTitle,
            goal: data.dailyGoal,
          ),
          const SizedBox(height: VSpace.md),
          Text(
            kIsWeb
                ? l10n.walkingWebManualBanner
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
    this.footer,
  });

  final IconData icon;
  final String label;
  final String value;
  final VireoColors colors;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(VSpace.sm + 2),
      decoration: VireoDecorations.premiumCard(colors),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.ember),
          const SizedBox(height: VSpace.sm),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(fontSize: 11, color: colors.textMute)),
          if (footer != null) ...[
            const SizedBox(height: 2),
            footer!,
          ],
        ],
      ),
    );
  }
}

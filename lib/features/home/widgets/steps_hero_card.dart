import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class StepsHeroCard extends ConsumerWidget {
  const StepsHeroCard({
    super.key,
    required this.stepsCurrent,
    required this.stepsGoal,
    required this.onTap,
  });

  final int stepsCurrent;
  final int stepsGoal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final live = ref.watch(liveStepsProvider).valueOrNull;
    final permissionGranted = live?.permissionGranted ?? true;

    // Distinct emerald/teal accent color for walking & steps
    const stepsAccent = VBridge.cFF10B981; // Emerald 500

    if (!permissionGranted && stepsCurrent == 0) {
      return VireoCard(
        padding: const EdgeInsets.all(VSpace.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: stepsAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.directions_walk_rounded, color: stepsAccent, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.stepsHeroTitle,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.stepsPermissionTitle,
                    style: TextStyle(color: colors.textMute, fontSize: 12),
                  ),
                ],
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: stepsAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VRadius.pill)),
              ),
              onPressed: () async {
                HapticFeedback.selectionClick();
                final enable = ref.read(enableStepCountingProvider);
                await enable();
              },
              child: Text(
                l10n.stepsEnableButton,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    final profile = WalkingCalculations.readProfileMetrics();
    final metrics = WalkingCalculations.compute(
      steps: stepsCurrent,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      isFemale: profile.isFemale,
    );
    final ratio = stepsGoal > 0 ? (stepsCurrent / stepsGoal).clamp(0.0, 1.0) : 0.0;
    final pct = (ratio * 100).round();
    final last7 = live?.last7Days ?? const <DailyStepCount>[];

    return VireoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(VSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              RingProgress(
                progress: ratio,
                size: 64,
                stroke: 6.5,
                color: stepsAccent,
                child: Text(
                  '$pct%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: stepsAccent,
                  ),
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
                          '$stepsCurrent',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                        ),
                        Text(
                          ' / $stepsGoal',
                          style: TextStyle(
                            color: colors.textMute,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.stepsHeroTitle,
                      style: TextStyle(
                        color: colors.textMute,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textMute),
            ],
          ),
          const SizedBox(height: VSpace.md),
          // 4 Key Stats: Km, Kcal, Fat (g), Active min
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(VRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: l10n.stepsKm(metrics.distanceKm.toStringAsFixed(1)),
                  value: metrics.distanceKm.toStringAsFixed(1),
                  icon: Icons.straighten_rounded,
                  color: stepsAccent,
                ),
                _StatItem(
                  label: l10n.uxBurned,
                  value: '${metrics.caloriesKcal}',
                  icon: Icons.local_fire_department_rounded,
                  color: colors.ember,
                ),
                _StatItem(
                  label: l10n.stepsFatBurned(metrics.fatBurnedGrams.toStringAsFixed(1)),
                  value: Localizations.localeOf(context).languageCode.startsWith('ar')
                      ? '${metrics.fatBurnedGrams.toStringAsFixed(1)} جم'
                      : '${metrics.fatBurnedGrams.toStringAsFixed(1)}g',
                  icon: Icons.water_drop_outlined,
                  color: colors.gold,
                ),
                _StatItem(
                  label: l10n.stepsActiveMinutes,
                  value: '${metrics.activeMinutes}m',
                  icon: Icons.timer_outlined,
                  color: colors.recovery,
                ),
              ],
            ),
          ),
          if (last7.isNotEmpty) ...[
            const SizedBox(height: VSpace.sm + 2),
            _Mini7DayBarChart(days: last7, goal: stepsGoal, accent: stepsAccent),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 3),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: colors.textMute, fontSize: 10.5, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Mini7DayBarChart extends StatelessWidget {
  const _Mini7DayBarChart({
    required this.days,
    required this.goal,
    required this.accent,
  });

  final List<DailyStepCount> days;
  final int goal;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final maxSteps = days.fold<int>(goal, (m, d) => d.steps > m ? d.steps : m);

    return SizedBox(
      height: 38,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final h = maxSteps > 0
                                ? (days[i].steps / maxSteps * constraints.maxHeight).clamp(4.0, constraints.maxHeight)
                                : 4.0;
                            final hit = goal > 0 && days[i].steps >= goal;
                            return Container(
                              height: h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: hit ? accent : colors.line,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _dayInitial(days[i].date),
                      style: TextStyle(color: colors.textMute, fontSize: 8.5),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _dayInitial(DateTime dt) {
    final names = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return names[(dt.weekday - 1) % 7];
  }
}

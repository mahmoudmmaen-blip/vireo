import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/data/step_foreground_service.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

/// Steps hero card matching Leap Step Tracker (leap_step_tracker_home.jpg).
/// Features:
/// - Huge step number with edit goal icon
/// - "/7000 خطوة"
/// - Big Play / Pause button
/// - Thick progress bar
/// - 3 stats: كم (Distance), سعرات (Calories), الوقت (Time)
/// - 7-day circular row with stars on goal reached + daily average
class PremiumStepsHeroCard extends ConsumerWidget {
  const PremiumStepsHeroCard({
    super.key,
    required this.stepsCurrent,
    required this.stepsGoal,
    required this.onTap,
  });

  final int stepsCurrent;
  final int stepsGoal;
  final VoidCallback onTap;

  static const stepsAccent = Color(0xFF10B981); // Bright Emerald Green
  static const stepsCardBg = Color(0xFF1E293B); // Deep slate blue / Leap style

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final live = ref.watch(liveStepsProvider).valueOrNull;
    final isRunning = ref.watch(isStepCounterRunningProvider);
    final permissionGranted = live?.permissionGranted ?? true;

    if (!permissionGranted && stepsCurrent == 0) {
      return Container(
        padding: const EdgeInsets.all(VSpace.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(VRadius.lg),
          border: Border.all(color: colors.line.withValues(alpha: 0.6)),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: stepsAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_walk_rounded, color: stepsAccent, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.stepsHeroTitle,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.stepsPermissionTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMute, fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: stepsAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(VRadius.pill)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                HapticFeedback.selectionClick();
                final enable = ref.read(enableStepCountingProvider);
                await enable();
              },
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: Text(
                l10n.stepsEnableButton,
                style: const TextStyle(fontWeight: FontWeight.w800),
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
    final effectiveGoal = stepsGoal > 0 ? stepsGoal : 7000;
    final ratio = (stepsCurrent / effectiveGoal).clamp(0.0, 1.0);
    final last7 = live?.last7Days ?? const <DailyStepCount>[];

    // Compute weekly daily average
    final totalSteps7 = last7.fold<int>(0, (s, d) => s + d.steps);
    final dailyAvg = last7.isNotEmpty ? (totalSteps7 / last7.length).round() : stepsCurrent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF162032), // Dark Navy matching leap_step_tracker_home.jpg
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Big steps number, goal, Play/Pause button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Play / Pause Circle Button
                InkWell(
                  onTap: () async {
                    HapticFeedback.heavyImpact();
                    await StepForegroundService.toggle();
                    ref.read(isStepCounterRunningProvider.notifier).state = StepForegroundService.isActive;
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3E55),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isRunning ? stepsAccent : Colors.white24,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: isRunning ? stepsAccent : Colors.white,
                      size: 28,
                    ),
                  ),
                ),

                // Center / Right: Big step number + goal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit, size: 16, color: Colors.white54),
                          const SizedBox(width: 6),
                          Text(
                            NumberFormat.decimalPattern().format(stepsCurrent),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '/$effectiveGoal خطوة',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Row 2: Thick progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 16,
                child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: const Color(0xFF2C3E55),
                  valueColor: const AlwaysStoppedAnimation<Color>(stepsAccent),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Row 3: 3 Stats Columns (كم, سعرات, الوقت)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Distance
                _LeapStatColumn(
                  icon: Icons.track_changes_rounded,
                  iconColor: const Color(0xFFFBBF24), // Yellow
                  value: metrics.distanceKm.toStringAsFixed(2),
                  label: 'كم',
                ),
                // Calories
                _LeapStatColumn(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFF97316), // Orange
                  value: '${metrics.caloriesKcal}',
                  label: 'السعرات',
                ),
                // Time
                _LeapStatColumn(
                  icon: Icons.access_time_filled_rounded,
                  iconColor: const Color(0xFF38BDF8), // Cyan
                  value: '${(metrics.activeMinutes ~/ 60)}س ${(metrics.activeMinutes % 60)}د',
                  label: 'الوقت',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 16),

            // Row 4: Daily average & 7-day circular row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  'المتوسط اليومي: $dailyAvg',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 7 Days Circles with Star when goal hit
            _Leap7DayRow(
              days: last7,
              goal: effectiveGoal,
              accent: stepsAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeapStatColumn extends StatelessWidget {
  const _LeapStatColumn({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Leap7DayRow extends StatelessWidget {
  const _Leap7DayRow({
    required this.days,
    required this.goal,
    required this.accent,
  });

  final List<DailyStepCount> days;
  final int goal;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    // Generate 7 days ending today
    final list = days.isNotEmpty ? days : _generateFallbackDays();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < list.length && i < 7; i++)
          _DayCircleItem(
            day: list[i],
            goal: goal,
            accent: accent,
          ),
      ],
    );
  }

  static List<DailyStepCount> _generateFallbackDays() {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DailyStepCount(date: d, steps: 0);
    });
  }
}

class _DayCircleItem extends StatelessWidget {
  const _DayCircleItem({
    required this.day,
    required this.goal,
    required this.accent,
  });

  final DailyStepCount day;
  final int goal;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final reached = goal > 0 && day.steps >= goal;
    final initial = _dayInitial(day.date);

    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: reached ? accent : const Color(0xFF223048),
            border: Border.all(
              color: reached ? accent : Colors.white12,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: reached
              ? const Icon(Icons.star_rounded, color: Colors.white, size: 22)
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          initial,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _dayInitial(DateTime dt) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return days[(dt.weekday - 1) % 7];
  }
}

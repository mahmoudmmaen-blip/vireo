import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

/// Premium 220dp circular gradient ring steps hero card (inspired by Honor Health and Leap Fitness).
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

  static const stepsAccent = Color(0xFF10B981); // Emerald 500
  static const stepsTeal = Color(0xFF06B6D4);   // Cyan 500

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final live = ref.watch(liveStepsProvider).valueOrNull;
    final permissionGranted = live?.permissionGranted ?? true;

    if (!permissionGranted && stepsCurrent == 0) {
      return VireoCard(
        padding: const EdgeInsets.all(VSpace.lg),
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
    final ratio = stepsGoal > 0 ? (stepsCurrent / stepsGoal).clamp(0.0, 1.0) : 0.0;
    final pct = (ratio * 100).round();
    final remaining = (stepsGoal - stepsCurrent).clamp(0, stepsGoal);
    final last7 = live?.last7Days ?? const <DailyStepCount>[];

    return VireoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(VSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row with Goal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_walk_rounded, color: stepsAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.stepsHeroTitle,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: stepsAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(VRadius.pill),
                  border: Border.all(color: stepsAccent.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'هدف: ${NumberFormat.decimalPattern().format(stepsGoal)}',
                  style: const TextStyle(
                    color: stepsAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: VSpace.lg),

          // 220dp Center Circular Gradient Ring
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: _GradientRingPainter(
                      progress: ratio,
                      trackColor: colors.line.withValues(alpha: 0.5),
                      startColor: stepsAccent,
                      endColor: stepsTeal,
                      strokeWidth: 16,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        NumberFormat.decimalPattern().format(stepsCurrent),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontFeatures: const [FontFeature.tabularFigures()],
                              height: 1.1,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        remaining > 0 ? 'باقي $remaining خطوة' : 'تم تحقيق الهدف! 🎉',
                        style: TextStyle(
                          color: remaining > 0 ? colors.textMute : stepsAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$pct%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: stepsAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: VSpace.xl),

          // 4 Metric Tiles (Km, Kcal, Fat, Active Minutes)
          Row(
            children: [
              Expanded(
                child: _HeroStatTile(
                  icon: Icons.straighten_rounded,
                  label: 'المسافة',
                  value: '${metrics.distanceKm.toStringAsFixed(1)} كم',
                  color: stepsTeal,
                  colors: colors,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroStatTile(
                  icon: Icons.local_fire_department_rounded,
                  label: 'السعرات',
                  value: '${metrics.caloriesKcal} ك.ع',
                  color: colors.ember,
                  colors: colors,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroStatTile(
                  icon: Icons.water_drop_outlined,
                  label: 'الدهون',
                  value: '${metrics.fatBurnedGrams.toStringAsFixed(1)} جم',
                  color: colors.gold,
                  colors: colors,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroStatTile(
                  icon: Icons.timer_outlined,
                  label: 'وقت النشاط',
                  value: '${metrics.activeMinutes} د',
                  color: colors.recovery,
                  colors: colors,
                ),
              ),
            ],
          ),

          if (last7.isNotEmpty) ...[
            const SizedBox(height: VSpace.md),
            _Mini7DayBarChart(days: last7, goal: stepsGoal, accent: stepsAccent),
          ],
        ],
      ),
    );
  }
}

class _HeroStatTile extends StatelessWidget {
  const _HeroStatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.line.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: colors.textMute, fontSize: 10.5, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  _GradientRingPainter({
    required this.progress,
    required this.trackColor,
    required this.startColor,
    required this.endColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color startColor;
  final Color endColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final sweepAngle = 2 * math.pi * progress;
    const startAngle = -math.pi / 2;

    final gradientPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + 2 * math.pi,
        colors: [
          startColor,
          endColor,
          startColor,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(startAngle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor;
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
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
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
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dayInitial(days[i].date),
                      style: TextStyle(color: colors.textMute, fontSize: 9.5, fontWeight: FontWeight.w600),
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
    final names = ['إث', 'ثل', 'أر', 'خم', 'جم', 'سب', 'أح'];
    return names[(dt.weekday - 1) % 7];
  }
}

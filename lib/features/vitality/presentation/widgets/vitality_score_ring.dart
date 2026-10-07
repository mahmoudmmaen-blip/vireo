import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/animations/vireo_animations.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/navigation/vireo_page_routes.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/vitality/screens/vitality_hub_screen.dart';

class VitalityScoreRing extends ConsumerStatefulWidget {
  const VitalityScoreRing({super.key});

  @override
  ConsumerState<VitalityScoreRing> createState() => _VitalityScoreRingState();
}

class _VitalityScoreRingState extends ConsumerState<VitalityScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _sweep;
  bool _animationConfigured = false;

  @override
  void initState() {
    super.initState();
    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animationConfigured) return;
    _animationConfigured = true;
    if (vireoAnimationsEnabled(context)) {
      _sweep.repeat();
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final score = ref.watch(vitalityScoreProvider);

    return Center(
      child: ScaleOnTap(
        onTap: () {
          Navigator.of(context).push(
            SlideUpRoute<void>(page: const VitalityHubScreen()),
          );
        },
        child: SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _sweep,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(140, 140),
                    painter: _GradientRingPainter(
                      progress: score.progress,
                      sweep: _sweep.value,
                      accent: colors.ember,
                      secondary: colors.recovery,
                      track: colors.line,
                    ),
                  );
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountUpNumber(
                    value: score.totalScore,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colors.recovery,
                        ),
                  ),
                  Text(
                    l10n.vitalityScoreLabel,
                    style: TextStyle(color: colors.textMute, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  _GradientRingPainter({
    required this.progress,
    required this.sweep,
    required this.accent,
    required this.secondary,
    required this.track,
  });

  final double progress;
  final double sweep;
  final Color accent;
  final Color secondary;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: sweep * 6.28,
        colors: [accent, secondary, accent],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      progress * 6.28,
      false,
      sweepPaint,
    );
  }

  @override
  bool shouldRepaint(_GradientRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.sweep != sweep;
}

class VitalityScoreSection extends ConsumerWidget {
  const VitalityScoreSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final score = ref.watch(vitalityScoreProvider);

    return Column(
      children: [
        const VitalityScoreRing(),
        const SizedBox(height: 8),
        Text(
          l10n.vitalityScoreBreakdown(
            score.sleepPoints,
            score.workoutPoints,
            score.proteinPoints,
            score.stressPoints,
          ),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.textMute, fontSize: 11),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.vitalityMedicalDisclaimer,
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.textMute, fontSize: 10, height: 1.3),
        ),
      ],
    );
  }
}

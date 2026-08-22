import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// Circular ring with conic gradient progress (ember) and line-color remainder.
class StepRingIndicator extends StatelessWidget {
  const StepRingIndicator({
    super.key,
    required this.steps,
    required this.goal,
    required this.stepsLabel,
    required this.goalLabel,
  });

  final int steps;
  final int goal;
  final String stepsLabel;
  final String goalLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final progress = goal <= 0 ? 0.0 : (steps / goal).clamp(0.0, 1.0);

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _StepRingPainter(
              progress: progress,
              ember: colors.ember,
              line: colors.line,
              strokeWidth: 14,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                NumberFormat.decimalPattern().format(steps),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
              const SizedBox(height: 4),
              Text(stepsLabel, style: TextStyle(color: colors.textMute)),
              const SizedBox(height: 8),
              Text(
                goalLabel,
                style: TextStyle(color: colors.textMute, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepRingPainter extends CustomPainter {
  _StepRingPainter({
    required this.progress,
    required this.ember,
    required this.line,
    required this.strokeWidth,
  });

  final double progress;
  final Color ember;
  final Color line;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final sweep = 2 * math.pi * progress;
    const startAngle = -math.pi / 2;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + 2 * math.pi,
        colors: [
          ember.withValues(alpha: 0.85),
          ember,
          ember.withValues(alpha: 0.95),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(startAngle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StepRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ember != ember ||
        oldDelegate.line != line;
  }
}

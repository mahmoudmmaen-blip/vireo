import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

/// Animated circular progress ring with rounded caps and gradient sweep.
///
/// [progress] may exceed 1.0 (e.g. over budget); the overflow is drawn as a
/// second lap in [overflowColor].
class RingProgress extends StatelessWidget {
  const RingProgress({
    super.key,
    required this.progress,
    required this.color,
    this.size = 120,
    this.stroke = 12,
    this.trackColor,
    this.secondaryColor,
    this.overflowColor,
    this.child,
    this.duration = VMotion.ring,
  });

  final double progress;
  final Color color;
  final Color? secondaryColor;
  final Color? trackColor;
  final Color? overflowColor;
  final double size;
  final double stroke;
  final Widget? child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final target = progress.isNaN ? 0.0 : progress.clamp(0.0, 2.0);
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: target),
        duration: duration,
        curve: VMotion.emphasized,
        builder: (context, value, inner) {
          return CustomPaint(
            painter: _RingPainter(
              progress: value,
              color: color,
              secondaryColor: secondaryColor ?? color,
              trackColor: trackColor ?? color.withValues(alpha: 0.14),
              overflowColor: overflowColor ?? const Color(0xFFE85C5C),
              stroke: stroke,
            ),
            child: inner,
          );
        },
        child: child == null ? null : Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.trackColor,
    required this.overflowColor,
    required this.stroke,
  });

  final double progress;
  final Color color;
  final Color secondaryColor;
  final Color trackColor;
  final Color overflowColor;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (math.min(size.width, size.height) - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = -math.pi / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    final main = progress.clamp(0.0, 1.0);
    if (main > 0) {
      final sweep = 2 * math.pi * main;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: 2 * math.pi,
          colors: [secondaryColor, color, color],
          stops: const [0.0, 0.6, 1.0],
          transform: const GradientRotation(start),
        ).createShader(rect);
      canvas.drawArc(rect, start, sweep, false, paint);
    }

    final over = (progress - 1).clamp(0.0, 1.0);
    if (over > 0) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = overflowColor;
      canvas.drawArc(rect, start, 2 * math.pi * over, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.secondaryColor != secondaryColor ||
      old.stroke != stroke;
}

/// Horizontal animated bar used for macros.
class MacroBar extends StatelessWidget {
  const MacroBar({
    super.key,
    required this.label,
    required this.value,
    required this.target,
    required this.color,
    this.unit = 'g',
  });

  final String label;
  final double value;
  final double target;
  final Color color;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final ratio = target <= 0 ? 0.0 : (value / target).clamp(0.0, 1.0);
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: value.round().toString(),
                    style: VType.number(size: 13, color: textTheme.bodyMedium?.color),
                  ),
                  TextSpan(
                    text: ' / ${target.round()}$unit',
                    style: VType.number(
                      size: 11,
                      weight: FontWeight.w500,
                      color: textTheme.labelMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(VRadius.pill),
          child: SizedBox(
            height: 7,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: color.withValues(alpha: 0.15)),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: ratio),
                  duration: VMotion.ring,
                  curve: VMotion.emphasized,
                  builder: (context, v, _) => FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: v,
                    heightFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(VRadius.pill),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

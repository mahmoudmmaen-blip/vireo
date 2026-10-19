import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class ParticleBurstPainter extends CustomPainter {
  const ParticleBurstPainter({
    required this.progress,
    required this.accentColor,
  });

  /// Progress from 0.0 to 1.0 of the burst.
  final double progress;
  final Color accentColor;

  static const _particleCount = 18;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    final center = Offset(size.width * 0.5, size.height * 0.45);
    final maxDist = math.min(size.width, size.height) * 0.35;
    final alpha = (1.0 - progress).clamp(0.0, 1.0);

    for (var i = 0; i < _particleCount; i++) {
      final angle = (i * 2 * math.pi / _particleCount) + (i * 0.12);
      final speedFactor = 0.6 + (i % 5) * 0.1;
      final distance = progress * maxDist * speedFactor;

      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);

      final isGold = i % 2 == 0;
      final color = isGold ? VBridge.cFFFFD700 : accentColor;

      final paint = Paint()
        ..color = color.withValues(alpha: alpha * 0.85)
        ..style = PaintingStyle.fill;

      final radius = (3.5 * (1.0 - progress * 0.5)).clamp(1.0, 4.0);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleBurstPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.accentColor != accentColor;
  }
}

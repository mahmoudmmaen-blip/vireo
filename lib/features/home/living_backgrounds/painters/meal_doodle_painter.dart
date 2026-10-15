import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Procedural vector line-art food doodles (plate, spoon, olive, bread)
/// drawn at low opacity (0.12 - 0.18) for the MealCaptureHeroCard background.
class MealDoodlePainter extends CustomPainter {
  const MealDoodlePainter({
    required this.lineColor,
  });

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = lineColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Stylized round plate with rim (right side)
    final plateCenter = Offset(w * 0.88, h * 0.45);
    canvas.drawCircle(plateCenter, 34, paint);
    canvas.drawCircle(plateCenter, 24, paint);

    // 2. Minimalist Spoon and Fork (near the plate)
    _paintSpoon(canvas, Offset(w * 0.76, h * 0.20), paint);
    _paintFork(canvas, Offset(w * 0.98, h * 0.20), paint);

    // 3. Olive branch with leaves and olive (left background)
    _paintOliveBranch(canvas, Offset(w * 0.12, h * 0.75), paint);

    // 4. Stylized bread loaf / wheat stalk (bottom right background)
    _paintBreadLoaf(canvas, Offset(w * 0.65, h * 0.82), paint);
  }

  void _paintSpoon(Canvas canvas, Offset base, Paint paint) {
    // Handle
    canvas.drawLine(base + const Offset(0, 36), base + const Offset(0, 10), paint);
    // Bowl of the spoon
    final rect = Rect.fromCenter(center: base + const Offset(0, 4), width: 9, height: 14);
    canvas.drawOval(rect, paint);
  }

  void _paintFork(Canvas canvas, Offset base, Paint paint) {
    // Handle
    canvas.drawLine(base + const Offset(0, 36), base + const Offset(0, 14), paint);
    // Fork base
    canvas.drawLine(base + const Offset(-4, 14), base + const Offset(4, 14), paint);
    // 3 Tines
    canvas.drawLine(base + const Offset(-4, 14), base + const Offset(-4, 2), paint);
    canvas.drawLine(base + const Offset(0, 14), base + const Offset(0, 2), paint);
    canvas.drawLine(base + const Offset(4, 14), base + const Offset(4, 2), paint);
  }

  void _paintOliveBranch(Canvas canvas, Offset stem, Paint paint) {
    // Main curved stem
    final branch = Path()
      ..moveTo(stem.dx, stem.dy)
      ..quadraticBezierTo(stem.dx + 15, stem.dy - 12, stem.dx + 30, stem.dy - 18);
    canvas.drawPath(branch, paint);

    // Leaves
    _paintLeaf(canvas, stem + const Offset(12, -8), -math.pi / 4, paint);
    _paintLeaf(canvas, stem + const Offset(22, -14), math.pi / 5, paint);

    // Little olive berry
    final oliveCenter = stem + const Offset(16, -2);
    canvas.drawOval(
      Rect.fromCenter(center: oliveCenter, width: 6, height: 9),
      paint,
    );
  }

  void _paintLeaf(Canvas canvas, Offset center, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final leaf = Path()
      ..moveTo(-5, 0)
      ..quadraticBezierTo(0, -4, 5, 0)
      ..quadraticBezierTo(0, 4, -5, 0);
    canvas.drawPath(leaf, paint);
    canvas.restore();
  }

  void _paintBreadLoaf(Canvas canvas, Offset center, Paint paint) {
    final loaf = Path()
      ..moveTo(center.dx - 18, center.dy)
      ..quadraticBezierTo(center.dx, center.dy - 14, center.dx + 18, center.dy)
      ..quadraticBezierTo(center.dx, center.dy + 8, center.dx - 18, center.dy);
    canvas.drawPath(loaf, paint);

    // Artisan scoring marks on crust
    canvas.drawLine(center + const Offset(-7, -5), center + const Offset(-4, -1), paint);
    canvas.drawLine(center + const Offset(0, -6), center + const Offset(1, -1), paint);
    canvas.drawLine(center + const Offset(6, -5), center + const Offset(7, -1), paint);
  }

  @override
  bool shouldRepaint(covariant MealDoodlePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}

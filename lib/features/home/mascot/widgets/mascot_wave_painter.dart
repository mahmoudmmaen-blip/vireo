import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/home/mascot/domain/mascot_companion.dart';
import 'package:vireo/features/home/mascot/domain/mascot_state.dart';

/// Original flat mascot whose body is a liquid-wave container.
///
/// Not based on any known brand character — simple rounded shapes only.
class MascotWavePainter extends CustomPainter {
  MascotWavePainter({
    required this.companion,
    required this.fill,
    required this.expression,
    required this.colorState,
    required this.accent,
    required this.success,
    required this.amber,
    required this.bodyOutline,
    required this.wavePhase,
    required this.showMacroLayers,
    this.proteinFill = 0,
    this.carbsFill = 0,
    this.fatFill = 0,
  });

  final MascotCompanion companion;
  final double fill; // 0..1 visual
  final MascotExpression expression;
  final MascotFillColorState colorState;
  final Color accent;
  final Color success;
  final Color amber;
  final Color bodyOutline;
  final double wavePhase; // 0..1 loop
  final bool showMacroLayers;
  final double proteinFill;
  final double carbsFill;
  final double fatFill;

  Color get _liquidColor => switch (colorState) {
        MascotFillColorState.calm => accent,
        MascotFillColorState.onTrack => success,
        MascotFillColorState.over => amber,
      };

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final bodyR = size.shortestSide * 0.38;

    // Soft bob
    final bob = math.sin(wavePhase * math.pi * 2) * (size.height * 0.012);
    canvas.save();
    canvas.translate(0, bob);

    final bodyCenter = Offset(cx, cy + size.height * 0.04);
    final bodyRect = Rect.fromCircle(center: bodyCenter, radius: bodyR);

    // Clip liquid to body oval
    canvas.save();
    final bodyPath = Path()..addOval(bodyRect);
    canvas.clipPath(bodyPath);

    // Body base fill (empty)
    canvas.drawOval(
      bodyRect,
      Paint()..color = bodyOutline.withValues(alpha: 0.12),
    );

    if (showMacroLayers && (proteinFill + carbsFill + fatFill) > 0.01) {
      _paintMacroBands(canvas, bodyRect);
    } else {
      _paintWave(canvas, bodyRect, fill, _liquidColor, wavePhase);
      _paintWave(
        canvas,
        bodyRect,
        fill,
        _liquidColor.withValues(alpha: 0.45),
        wavePhase + 0.18,
        amplitude: 0.035,
      );
    }
    canvas.restore();

    // Body outline
    canvas.drawOval(
      bodyRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = bodyOutline.withValues(alpha: 0.55),
    );

    // Ears / features by companion (outside clip)
    _paintCompanionExtras(canvas, size, bodyCenter, bodyR);

    // Face
    _paintFace(canvas, bodyCenter, bodyR);

    canvas.restore();
  }

  void _paintWave(
    Canvas canvas,
    Rect body,
    double fillLevel,
    Color color,
    double phase, {
    double amplitude = 0.045,
  }) {
    if (fillLevel <= 0) return;
    final levelY = body.bottom - body.height * fillLevel.clamp(0.0, 1.0);
    final path = Path();
    path.moveTo(body.left - 4, body.bottom + 4);
    path.lineTo(body.left - 4, levelY);
    final steps = 24;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = body.left + body.width * t;
      final y = levelY +
          math.sin((t * math.pi * 2) + phase * math.pi * 2) *
              body.height *
              amplitude;
      path.lineTo(x, y);
    }
    path.lineTo(body.right + 4, body.bottom + 4);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _paintMacroBands(Canvas canvas, Rect body) {
    // Stack from bottom: fat → carbs → protein (visual bands)
    var stacked = 0.0;
    void band(double portion, Color color, double phaseOff) {
      if (portion <= 0) return;
      final next = (stacked + portion).clamp(0.0, 1.0);
      _paintWave(canvas, body, next, color.withValues(alpha: 0.85), wavePhase + phaseOff);
      stacked = next;
    }

    band(fatFill.clamp(0.0, 1.0), VMacro.fat, 0.05);
    band(carbsFill.clamp(0.0, 1.0), VMacro.carbs, 0.12);
    band(proteinFill.clamp(0.0, 1.0), VMacro.protein, 0.2);
  }

  void _paintCompanionExtras(
    Canvas canvas,
    Size size,
    Offset bodyCenter,
    double bodyR,
  ) {
    final paint = Paint()..color = bodyOutline.withValues(alpha: 0.75);
    switch (companion) {
      case MascotCompanion.panda:
        // Round ears
        canvas.drawCircle(
          Offset(bodyCenter.dx - bodyR * 0.72, bodyCenter.dy - bodyR * 0.78),
          bodyR * 0.28,
          paint,
        );
        canvas.drawCircle(
          Offset(bodyCenter.dx + bodyR * 0.72, bodyCenter.dy - bodyR * 0.78),
          bodyR * 0.28,
          paint,
        );
        // Eye patches
        final patch = Paint()..color = bodyOutline.withValues(alpha: 0.35);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(bodyCenter.dx - bodyR * 0.32, bodyCenter.dy - bodyR * 0.12),
            width: bodyR * 0.42,
            height: bodyR * 0.36,
          ),
          patch,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(bodyCenter.dx + bodyR * 0.32, bodyCenter.dy - bodyR * 0.12),
            width: bodyR * 0.42,
            height: bodyR * 0.36,
          ),
          patch,
        );
      case MascotCompanion.cat:
        final ear = Path()
          ..moveTo(bodyCenter.dx - bodyR * 0.85, bodyCenter.dy - bodyR * 0.35)
          ..lineTo(bodyCenter.dx - bodyR * 0.45, bodyCenter.dy - bodyR * 1.05)
          ..lineTo(bodyCenter.dx - bodyR * 0.15, bodyCenter.dy - bodyR * 0.55)
          ..close();
        canvas.drawPath(ear, paint);
        final ear2 = Path()
          ..moveTo(bodyCenter.dx + bodyR * 0.85, bodyCenter.dy - bodyR * 0.35)
          ..lineTo(bodyCenter.dx + bodyR * 0.45, bodyCenter.dy - bodyR * 1.05)
          ..lineTo(bodyCenter.dx + bodyR * 0.15, bodyCenter.dy - bodyR * 0.55)
          ..close();
        canvas.drawPath(ear2, paint);
      case MascotCompanion.camel:
        // Soft hump on top
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(bodyCenter.dx, bodyCenter.dy - bodyR * 0.95),
            width: bodyR * 0.7,
            height: bodyR * 0.45,
          ),
          paint..color = accent.withValues(alpha: 0.55),
        );
        // Tiny snout
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(bodyCenter.dx, bodyCenter.dy + bodyR * 0.35),
            width: bodyR * 0.55,
            height: bodyR * 0.32,
          ),
          Paint()..color = bodyOutline.withValues(alpha: 0.2),
        );
      case MascotCompanion.owl:
        // Pointy ear tufts
        canvas.drawCircle(
          Offset(bodyCenter.dx - bodyR * 0.55, bodyCenter.dy - bodyR * 0.95),
          bodyR * 0.14,
          paint,
        );
        canvas.drawCircle(
          Offset(bodyCenter.dx + bodyR * 0.55, bodyCenter.dy - bodyR * 0.95),
          bodyR * 0.14,
          paint,
        );
    }
  }

  void _paintFace(Canvas canvas, Offset c, double r) {
    final eyePaint = Paint()..color = bodyOutline;
    final eyeY = c.dy - r * 0.08;
    final eyeSpread = r * 0.28;
    final eyeR = r * 0.07;

    void eye(double dx, {bool closed = false}) {
      final center = Offset(c.dx + dx, eyeY);
      if (closed || expression == MascotExpression.sleepy) {
        canvas.drawLine(
          Offset(center.dx - eyeR, center.dy),
          Offset(center.dx + eyeR, center.dy),
          Paint()
            ..color = bodyOutline
            ..strokeWidth = 2.2
            ..strokeCap = StrokeCap.round,
        );
      } else {
        canvas.drawCircle(center, eyeR, eyePaint);
        canvas.drawCircle(
          Offset(center.dx + eyeR * 0.25, center.dy - eyeR * 0.25),
          eyeR * 0.35,
          Paint()..color = Colors.white.withValues(alpha: 0.85),
        );
      }
    }

    eye(-eyeSpread);
    eye(eyeSpread);

    // Cheeks when full
    if (expression == MascotExpression.full) {
      final cheek = Paint()..color = const Color(0xFFFFB4A2).withValues(alpha: 0.7);
      canvas.drawCircle(Offset(c.dx - r * 0.55, c.dy + r * 0.15), r * 0.18, cheek);
      canvas.drawCircle(Offset(c.dx + r * 0.55, c.dy + r * 0.15), r * 0.18, cheek);
    }

    // Mouth
    final mouthPaint = Paint()
      ..color = bodyOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final mouthY = c.dy + r * 0.28;
    switch (expression) {
      case MascotExpression.hungry:
        canvas.drawArc(
          Rect.fromCenter(center: Offset(c.dx, mouthY), width: r * 0.35, height: r * 0.28),
          0.2,
          math.pi - 0.4,
          false,
          mouthPaint,
        );
      case MascotExpression.happy:
        canvas.drawArc(
          Rect.fromCenter(center: Offset(c.dx, mouthY - r * 0.05), width: r * 0.45, height: r * 0.35),
          0.15,
          math.pi - 0.3,
          false,
          mouthPaint,
        );
      case MascotExpression.satisfied:
        canvas.drawArc(
          Rect.fromCenter(center: Offset(c.dx, mouthY - r * 0.02), width: r * 0.4, height: r * 0.22),
          0.3,
          math.pi - 0.6,
          false,
          mouthPaint,
        );
      case MascotExpression.full:
        canvas.drawOval(
          Rect.fromCenter(center: Offset(c.dx, mouthY), width: r * 0.28, height: r * 0.18),
          Paint()..color = bodyOutline.withValues(alpha: 0.35),
        );
      case MascotExpression.sleepy:
        canvas.drawLine(
          Offset(c.dx - r * 0.12, mouthY),
          Offset(c.dx + r * 0.12, mouthY),
          mouthPaint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant MascotWavePainter old) {
    return old.fill != fill ||
        old.wavePhase != wavePhase ||
        old.expression != expression ||
        old.colorState != colorState ||
        old.companion != companion ||
        old.showMacroLayers != showMacroLayers ||
        old.proteinFill != proteinFill ||
        old.carbsFill != carbsFill ||
        old.fatFill != fatFill ||
        old.accent != accent;
  }
}

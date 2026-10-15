import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/features/home/living_backgrounds/domain/journey_stage.dart';
import 'package:vireo/features/home/living_backgrounds/domain/scene_pack.dart';
import 'package:vireo/features/home/living_backgrounds/domain/scrim_contrast.dart';

class StepJourneyPainter extends CustomPainter {
  const StepJourneyPainter({
    required this.stage,
    required this.pack,
    required this.variant,
    this.morphProgress = 1.0,
    this.previousStage,
    this.isDark = true,
  });

  final JourneyStage stage;
  final JourneyStage? previousStage;
  final ScenePack pack;
  final AppThemeVariant variant;
  final double morphProgress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final palette = pack.paletteFor(stage, variant, isDark);
    final rect = Offset.zero & size;

    // 1. Sky Gradient
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: palette.skyGradient,
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    // 2. Celestial Body (Sun or Moon + Stars)
    _paintCelestial(canvas, size, palette);

    // 3. Distant Mountains / Dunes / Horizons
    _paintDistantTerrain(canvas, size, palette);

    // 4. Midground Terrain / Nile Water / Hills
    _paintMidground(canvas, size, palette);

    // 5. The Living Journey Path
    _paintJourneyPath(canvas, size, palette);

    // 6. Landmarks based on unlocked stage
    _paintLandmarks(canvas, size, palette);

    // 7. Automatic Readability Scrim (guarantees WCAG AA >= 4.5:1 for overlay text)
    final scrimPaint = Paint()
      ..shader = ScrimContrast.standardStepsScrim().createShader(rect);
    canvas.drawRect(rect, scrimPaint);
  }

  void _paintCelestial(Canvas canvas, Size size, ScenePackPalette palette) {
    final cx = size.width * stage.sunAzimuth;
    final cy = size.height * (0.65 - stage.sunElevation * 0.45);

    if (stage.isNightOrDawn || pack.id == ScenePackId.nightSky || pack.id == ScenePackId.ramadan) {
      // Paint Moon + Stars
      // Stars
      final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.65);
      final starPoints = [
        Offset(size.width * 0.15, size.height * 0.18),
        Offset(size.width * 0.32, size.height * 0.12),
        Offset(size.width * 0.55, size.height * 0.22),
        Offset(size.width * 0.78, size.height * 0.15),
        Offset(size.width * 0.88, size.height * 0.26),
      ];
      for (final pt in starPoints) {
        canvas.drawCircle(pt, 1.5, starPaint);
      }

      // Crescent Moon
      final moonRadius = 14.0;
      final haloPaint = Paint()
        ..color = palette.sunHaloColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset(cx, cy), moonRadius * 1.6, haloPaint);

      final moonPath = Path()
        ..addArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: moonRadius),
          -math.pi / 2,
          math.pi,
        )
        ..arcTo(
          Rect.fromCircle(center: Offset(cx + 5, cy), radius: moonRadius * 0.85),
          math.pi / 2,
          -math.pi,
          false,
        )
        ..close();

      final moonPaint = Paint()..color = palette.sunOrMoonColor;
      canvas.drawPath(moonPath, moonPaint);
    } else {
      // Sun with radiant halo
      final sunRadius = 16.0;
      final haloPaint = Paint()
        ..color = palette.sunHaloColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawCircle(Offset(cx, cy), sunRadius * 2.2, haloPaint);

      final sunPaint = Paint()..color = palette.sunOrMoonColor;
      canvas.drawCircle(Offset(cx, cy), sunRadius, sunPaint);
    }
  }

  void _paintDistantTerrain(Canvas canvas, Size size, ScenePackPalette palette) {
    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(0, h * 0.58);
    path.cubicTo(w * 0.25, h * 0.48, w * 0.45, h * 0.64, w * 0.70, h * 0.52);
    path.cubicTo(w * 0.85, h * 0.44, w * 0.95, h * 0.56, w, h * 0.50);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    final paint = Paint()..color = palette.distantTerrainColor.withValues(alpha: 0.85);
    canvas.drawPath(path, paint);
  }

  void _paintMidground(Canvas canvas, Size size, ScenePackPalette palette) {
    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(0, h * 0.70);
    path.cubicTo(w * 0.30, h * 0.62, w * 0.60, h * 0.76, w, h * 0.66);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    final paint = Paint()..color = palette.midTerrainColor;
    canvas.drawPath(path, paint);
  }

  void _paintJourneyPath(Canvas canvas, Size size, ScenePackPalette palette) {
    final w = size.width;
    final h = size.height;

    // The path begins at the bottom center and curves upwards into the landscape
    final maxT = stage.pathProgress.clamp(0.08, 1.0);

    final startX = w * 0.50;
    final startY = h;
    final targetX = w * 0.35;
    final targetY = h * 0.62;

    final currentX = startX + (targetX - startX) * maxT;
    final currentY = startY + (targetY - startY) * maxT;

    final path = Path();
    path.moveTo(startX, startY);
    path.quadraticBezierTo(
      w * 0.42,
      h * 0.82,
      currentX,
      currentY,
    );

    final pathPaint = Paint()
      ..color = palette.foregroundPathColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0 * (1.0 - (maxT * 0.3))
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, pathPaint);

    // Glowing path marker at current progress point
    final markerPaint = Paint()
      ..color = palette.sunOrMoonColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(currentX, currentY), 3.5, markerPaint);
  }

  void _paintLandmarks(Canvas canvas, Size size, ScenePackPalette palette) {
    final w = size.width;
    final h = size.height;
    final landmarks = stage.landmarks;

    // 1. Palm tree (stage >= 2)
    if (landmarks.contains(LandmarkType.palm)) {
      _paintPalm(canvas, Offset(w * 0.82, h * 0.66), palette.landmarkColor);
    }

    // 2. Pyramid silhouette (stage >= 4)
    if (landmarks.contains(LandmarkType.pyramid)) {
      _paintPyramid(canvas, Offset(w * 0.18, h * 0.58), 34, palette.landmarkColor);
    }

    // 3. Minaret (stage >= 6)
    if (landmarks.contains(LandmarkType.minaret)) {
      _paintMinaret(canvas, Offset(w * 0.64, h * 0.62), palette.landmarkColor);
    }

    // 4. Nile Wave (stage >= 8)
    if (landmarks.contains(LandmarkType.nileWave)) {
      _paintNileWave(canvas, Offset(w * 0.40, h * 0.74), palette.landmarkColor);
    }

    // 5. Mountain Flag (stage >= 10)
    if (landmarks.contains(LandmarkType.mountainFlag)) {
      _paintMountainFlag(canvas, Offset(w * 0.72, h * 0.52), palette.landmarkColor);
    }

    // 6. Star Badge (stage >= 12 / 12,000+ steps)
    if (landmarks.contains(LandmarkType.starBadge)) {
      _paintStarBadge(canvas, Offset(w * 0.50, h * 0.28));
    }

    // Special Ramadan lantern
    if (pack.id == ScenePackId.ramadan) {
      _paintRamadanLantern(canvas, Offset(w * 0.22, h * 0.22), palette.sunOrMoonColor);
    }
  }

  void _paintPalm(Canvas canvas, Offset base, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Trunk
    final trunk = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(base.dx + 4, base.dy - 12, base.dx + 2, base.dy - 24);
    canvas.drawPath(trunk, paint);

    // Fronds
    final top = Offset(base.dx + 2, base.dy - 24);
    final frondPaint = Paint()
      ..color = color.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawLine(top, top + const Offset(-10, -6), frondPaint);
    canvas.drawLine(top, top + const Offset(10, -6), frondPaint);
    canvas.drawLine(top, top + const Offset(-7, 4), frondPaint);
    canvas.drawLine(top, top + const Offset(7, 4), frondPaint);
    canvas.drawLine(top, top + const Offset(0, -9), frondPaint);
  }

  void _paintPyramid(Canvas canvas, Offset base, double width, Color color) {
    final h = width * 0.65;
    final peak = Offset(base.dx, base.dy - h);
    final left = Offset(base.dx - width * 0.5, base.dy);
    final right = Offset(base.dx + width * 0.5, base.dy);

    final litPath = Path()
      ..moveTo(peak.dx, peak.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(base.dx + width * 0.08, base.dy)
      ..close();

    final shadowPath = Path()
      ..moveTo(peak.dx, peak.dy)
      ..lineTo(base.dx + width * 0.08, base.dy)
      ..lineTo(right.dx, right.dy)
      ..close();

    final litPaint = Paint()..color = color.withValues(alpha: 0.55);
    final shadowPaint = Paint()..color = color.withValues(alpha: 0.35);

    canvas.drawPath(litPath, litPaint);
    canvas.drawPath(shadowPath, shadowPaint);
  }

  void _paintMinaret(Canvas canvas, Offset base, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    // Tower base
    canvas.drawRect(Rect.fromLTWH(base.dx - 2.5, base.dy - 24, 5, 24), paint);
    // Balcony
    canvas.drawRect(Rect.fromLTWH(base.dx - 4.5, base.dy - 26, 9, 2), paint);
    // Spire
    final spire = Path()
      ..moveTo(base.dx - 2, base.dy - 26)
      ..lineTo(base.dx + 2, base.dy - 26)
      ..lineTo(base.dx, base.dy - 34)
      ..close();
    canvas.drawPath(spire, paint);
  }

  void _paintNileWave(Canvas canvas, Offset base, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(base.dx - 18, base.dy)
      ..cubicTo(base.dx - 9, base.dy - 5, base.dx - 9, base.dy + 5, base.dx, base.dy)
      ..cubicTo(base.dx + 9, base.dy - 5, base.dx + 9, base.dy + 5, base.dx + 18, base.dy);

    canvas.drawPath(path, paint);
  }

  void _paintMountainFlag(Canvas canvas, Offset base, Color color) {
    final polePaint = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..strokeWidth = 1.5;
    canvas.drawLine(base, Offset(base.dx, base.dy - 18), polePaint);

    final flagPath = Path()
      ..moveTo(base.dx, base.dy - 18)
      ..lineTo(base.dx + 8, base.dy - 14)
      ..lineTo(base.dx, base.dy - 10)
      ..close();

    final flagPaint = Paint()..color = const Color(0xFFEF4444).withValues(alpha: 0.85);
    canvas.drawPath(flagPath, flagPaint);
  }

  void _paintStarBadge(Canvas canvas, Offset center) {
    final haloPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, 18, haloPaint);

    final starPath = Path();
    const points = 5;
    const outerRadius = 11.0;
    const innerRadius = 5.0;

    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * math.pi / points) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();

    final starPaint = Paint()..color = const Color(0xFFFFD700);
    canvas.drawPath(starPath, starPaint);
  }

  void _paintRamadanLantern(Canvas canvas, Offset top, Color color) {
    final stringPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(top.dx, 0), top, stringPaint);

    final fanousPath = Path()
      ..moveTo(top.dx - 3, top.dy)
      ..lineTo(top.dx + 3, top.dy)
      ..lineTo(top.dx + 6, top.dy + 8)
      ..lineTo(top.dx - 6, top.dy + 8)
      ..close()
      ..moveTo(top.dx - 6, top.dy + 8)
      ..lineTo(top.dx + 6, top.dy + 8)
      ..lineTo(top.dx + 3, top.dy + 18)
      ..lineTo(top.dx - 3, top.dy + 18)
      ..close();

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(top.dx, top.dy + 9), 10, glowPaint);

    final lanternPaint = Paint()..color = color;
    canvas.drawPath(fanousPath, lanternPaint);
  }

  @override
  bool shouldRepaint(covariant StepJourneyPainter oldDelegate) {
    return oldDelegate.stage.index != stage.index ||
        oldDelegate.pack.id != pack.id ||
        oldDelegate.variant != variant ||
        oldDelegate.morphProgress != morphProgress ||
        oldDelegate.isDark != isDark;
  }
}

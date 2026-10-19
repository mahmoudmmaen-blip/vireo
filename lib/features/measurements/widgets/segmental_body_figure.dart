import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

/// Simple SVG-like body figure colored by segmental lean balance.
class SegmentalBodyFigure extends StatelessWidget {
  const SegmentalBodyFigure({super.key, required this.lean});

  final SegmentalMap lean;

  Color _colorFor(SegmentalPart part, Color ember, Color mute) {
    final pct = part.percent?.value;
    if (pct == null) return mute.withValues(alpha: 0.35);
    if (pct >= 100) return VBridge.cFF2E7D32;
    if (pct >= 90) return ember;
    return VBridge.cFFE8763C;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return SizedBox(
      height: 180,
      child: CustomPaint(
        painter: _BodyPainter(
          trunk: _colorFor(lean.trunk, colors.ember, colors.textMute),
          leftArm: _colorFor(lean.leftArm, colors.ember, colors.textMute),
          rightArm: _colorFor(lean.rightArm, colors.ember, colors.textMute),
          leftLeg: _colorFor(lean.leftLeg, colors.ember, colors.textMute),
          rightLeg: _colorFor(lean.rightLeg, colors.ember, colors.textMute),
          outline: colors.line,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.trunk,
    required this.leftArm,
    required this.rightArm,
    required this.leftLeg,
    required this.rightLeg,
    required this.outline,
  });

  final Color trunk;
  final Color leftArm;
  final Color rightArm;
  final Color leftLeg;
  final Color rightLeg;
  final Color outline;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final head = Offset(cx, size.height * 0.12);
    canvas.drawCircle(head, size.width * 0.06, Paint()..color = outline);

    void box(Rect r, Color c) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(6)),
        Paint()..color = c,
      );
    }

    box(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.38),
        width: size.width * 0.22,
        height: size.height * 0.28,
      ),
      trunk,
    );
    box(
      Rect.fromLTWH(cx - size.width * 0.34, size.height * 0.28, size.width * 0.1, size.height * 0.22),
      leftArm,
    );
    box(
      Rect.fromLTWH(cx + size.width * 0.24, size.height * 0.28, size.width * 0.1, size.height * 0.22),
      rightArm,
    );
    box(
      Rect.fromLTWH(cx - size.width * 0.14, size.height * 0.55, size.width * 0.1, size.height * 0.32),
      leftLeg,
    );
    box(
      Rect.fromLTWH(cx + size.width * 0.04, size.height * 0.55, size.width * 0.1, size.height * 0.32),
      rightLeg,
    );
  }

  @override
  bool shouldRepaint(covariant _BodyPainter oldDelegate) =>
      oldDelegate.trunk != trunk ||
      oldDelegate.leftArm != leftArm ||
      oldDelegate.rightArm != rightArm;
}


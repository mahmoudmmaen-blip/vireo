import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/progress_models.dart';

class EnergyLineChart extends StatelessWidget {
  const EnergyLineChart({super.key, required this.checkIns});

  final List<EnergyCheckIn> checkIns;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    if (checkIns.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(child: Text('—', style: TextStyle(color: colors.textMute))),
      );
    }

    return SizedBox(
      height: 220,
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: _EnergyLinePainter(
                checkIns: checkIns,
                ember: colors.ember,
                line: colors.line,
              ),
              child: Container(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: checkIns
                .map(
                  (c) => Text(
                    'W${c.weekNumber}',
                    style: TextStyle(color: colors.textMute, fontSize: 9),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _EnergyLinePainter extends CustomPainter {
  _EnergyLinePainter({
    required this.checkIns,
    required this.ember,
    required this.line,
  });

  final List<EnergyCheckIn> checkIns;
  final Color ember;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    const padLeft = 28.0;
    const padRight = 12.0;
    const padTop = 12.0;
    const padBottom = 24.0;
    const minScore = 1.0;
    const maxScore = 10.0;

    final chartW = size.width - padLeft - padRight;
    final chartH = size.height - padTop - padBottom;

    final gridPaint = Paint()
      ..color = line
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(padLeft, padTop + chartH),
      Offset(padLeft + chartW, padTop + chartH),
      gridPaint,
    );

    final points = <Offset>[];
    for (var i = 0; i < checkIns.length; i++) {
      final x = padLeft + (i / math.max(1, checkIns.length - 1)) * chartW;
      final score = checkIns[i].energyScore.toDouble();
      final y = padTop + chartH - ((score - minScore) / (maxScore - minScore)) * chartH;
      points.add(Offset(x, y));
    }

    if (points.length > 1) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = ember
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke,
      );
    }

    final dotPaint = Paint()..color = ember;
    for (final p in points) {
      canvas.drawCircle(p, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyLinePainter oldDelegate) => true;
}

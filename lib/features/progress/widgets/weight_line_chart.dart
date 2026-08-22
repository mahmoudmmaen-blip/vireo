import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/data/models/unit_preference.dart';

class WeightLineChart extends StatelessWidget {
  const WeightLineChart({
    super.key,
    required this.logs,
    required this.goalKg,
    required this.unit,
  });

  final List<WeightLogEntry> logs;
  final double? goalKg;
  final UnitPreference unit;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    if (logs.isEmpty) {
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
              painter: _WeightLinePainter(
                logs: logs,
                goalKg: goalKg,
                unit: unit,
                ember: colors.ember,
                line: colors.line,
                gold: colors.gold,
              ),
              child: Container(),
            ),
          ),
          if (logs.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                DateFormat.MMMd().format(logs.last.loggedAt),
                style: TextStyle(color: colors.textMute, fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeightLinePainter extends CustomPainter {
  _WeightLinePainter({
    required this.logs,
    required this.goalKg,
    required this.unit,
    required this.ember,
    required this.line,
    required this.gold,
  });

  final List<WeightLogEntry> logs;
  final double? goalKg;
  final UnitPreference unit;
  final Color ember;
  final Color line;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    const padLeft = 36.0;
    const padRight = 12.0;
    const padTop = 12.0;
    const padBottom = 28.0;

    final chartW = size.width - padLeft - padRight;
    final chartH = size.height - padTop - padBottom;

    final values = logs
        .map((l) => UnitConverter.displayWeight(l.weightKg, unit))
        .toList();
    var minY = values.reduce(math.min);
    var maxY = values.reduce(math.max);
    if (goalKg != null) {
      final goalDisplay = UnitConverter.displayWeight(goalKg!, unit);
      minY = math.min(minY, goalDisplay);
      maxY = math.max(maxY, goalDisplay);
    }
    final range = (maxY - minY).abs() < 0.5 ? 1.0 : maxY - minY;

    final gridPaint = Paint()
      ..color = line
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(padLeft, padTop + chartH),
      Offset(padLeft + chartW, padTop + chartH),
      gridPaint,
    );

    final points = <Offset>[];
    for (var i = 0; i < logs.length; i++) {
      final x = padLeft + (i / math.max(1, logs.length - 1)) * chartW;
      final yVal = UnitConverter.displayWeight(logs[i].weightKg, unit);
      final y = padTop + chartH - ((yVal - minY) / range) * chartH;
      points.add(Offset(x, y));
    }

    if (goalKg != null) {
      final goalY = padTop +
          chartH -
          ((UnitConverter.displayWeight(goalKg!, unit) - minY) / range) * chartH;
      final goalPaint = Paint()
        ..color = gold
        ..strokeWidth = 1.5;
      _drawDashedLine(
        canvas,
        Offset(padLeft, goalY),
        Offset(padLeft + chartW, goalY),
        goalPaint,
      );
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
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    final dotPaint = Paint()..color = ember;
    for (final p in points) {
      canvas.drawCircle(p, 4, dotPaint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 6.0;
    final total = (end - start).distance;
    final dir = (end - start) / total;
    var drawn = 0.0;
    while (drawn < total) {
      final p1 = start + dir * drawn;
      final p2 = start + dir * math.min(drawn + dash, total);
      canvas.drawLine(p1, p2, paint);
      drawn += dash * 2;
    }
  }

  @override
  bool shouldRepaint(covariant _WeightLinePainter oldDelegate) => true;
}

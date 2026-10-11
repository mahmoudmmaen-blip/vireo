import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/unit_converter.dart';
import 'package:vireo/data/models/progress_models.dart';
import 'package:vireo/data/models/unit_preference.dart';
import 'package:vireo/features/progress/domain/weight_trend_calculator.dart';

class WeightTrendChartCard extends StatelessWidget {
  const WeightTrendChartCard({
    super.key,
    required this.logs,
    required this.analysis,
    required this.goalKg,
    required this.unit,
  });

  final List<WeightLogEntry> logs;
  final WeightTrendAnalysis analysis;
  final double? goalKg;
  final UnitPreference unit;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final unitLabel = UnitConverter.weightLabel(unit);

    final change7 = analysis.change7DaysKg;
    final change30 = analysis.change30DaysKg;

    String formatDelta(double? valKg) {
      if (valKg == null) return '—';
      final converted = UnitConverter.displayWeight(valKg.abs(), unit);
      final sign = valKg > 0 ? '+' : (valKg < 0 ? '-' : '');
      return '$sign${converted.toStringAsFixed(1)} $unitLabel';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.progressWeightChartTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Trend (EMA α=0.1) vs Raw Logs',
                      style: TextStyle(color: colors.textMute, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (analysis.currentTrendKg != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${UnitConverter.displayWeight(analysis.currentTrendKg!, unit).toStringAsFixed(1)} $unitLabel',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.ember,
                          ),
                    ),
                    Text(
                      'Current Trend',
                      style: TextStyle(color: colors.textMute, fontSize: 10),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          // ── Headline: Trend change over 7 and 30 days ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.line.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TrendDeltaPill(
                    title: '7-Day Trend',
                    deltaStr: formatDelta(change7),
                    isNegative: (change7 ?? 0) < 0,
                    isPositive: (change7 ?? 0) > 0,
                    colors: colors,
                  ),
                ),
                Container(height: 28, width: 1, color: colors.line),
                Expanded(
                  child: _TrendDeltaPill(
                    title: '30-Day Trend',
                    deltaStr: formatDelta(change30),
                    isNegative: (change30 ?? 0) < 0,
                    isPositive: (change30 ?? 0) > 0,
                    colors: colors,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ── Chart Canvas ──
          if (logs.isEmpty)
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  l10n.progressTrendEmpty,
                  style: TextStyle(color: colors.textMute),
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _WeightTrendPainter(
                  logs: logs,
                  points: analysis.points,
                  goalKg: goalKg,
                  unit: unit,
                  ember: colors.ember,
                  line: colors.line,
                  gold: colors.gold,
                  textMute: colors.textMute,
                ),
                child: Container(),
              ),
            ),
            if (analysis.points.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 36, right: 12, top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.MMMd().format(analysis.points.first.date),
                      style: TextStyle(color: colors.textMute, fontSize: 10),
                    ),
                    Text(
                      DateFormat.MMMd().format(analysis.points.last.date),
                      style: TextStyle(color: colors.textMute, fontSize: 10),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 8),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: colors.textMute.withValues(alpha: 0.6), label: 'Raw Dot', isDot: true),
              const SizedBox(width: 16),
              _LegendItem(color: colors.ember, label: 'Trend Line', isDot: false),
              if (goalKg != null) ...[
                const SizedBox(width: 16),
                _LegendItem(color: colors.gold, label: 'Goal Line', isDot: false, isDashed: true),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendDeltaPill extends StatelessWidget {
  const _TrendDeltaPill({
    required this.title,
    required this.deltaStr,
    required this.isNegative,
    required this.isPositive,
    required this.colors,
  });

  final String title;
  final String deltaStr;
  final bool isNegative;
  final bool isPositive;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    Color badgeColor = colors.textMute;
    IconData icon = Icons.remove;
    if (isNegative) {
      badgeColor = const Color(0xFF22C55E); // Green for loss
      icon = Icons.trending_down;
    } else if (isPositive) {
      badgeColor = const Color(0xFFEAB308); // Yellow/amber for gain
      icon = Icons.trending_up;
    }

    return Column(
      children: [
        Text(title, style: TextStyle(color: colors.textMute, fontSize: 11)),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: badgeColor),
            const SizedBox(width: 4),
            Text(
              deltaStr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: badgeColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.isDot,
    this.isDashed = false,
  });

  final Color color;
  final String label;
  final bool isDot;
  final bool isDashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDot)
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle))
        else
          Container(width: 16, height: 2.5, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }
}

class _WeightTrendPainter extends CustomPainter {
  _WeightTrendPainter({
    required this.logs,
    required this.points,
    required this.goalKg,
    required this.unit,
    required this.ember,
    required this.line,
    required this.gold,
    required this.textMute,
  });

  final List<WeightLogEntry> logs;
  final List<WeightTrendPoint> points;
  final double? goalKg;
  final UnitPreference unit;
  final Color ember;
  final Color line;
  final Color gold;
  final Color textMute;

  @override
  void paint(Canvas canvas, Size size) {
    const padLeft = 36.0;
    const padRight = 12.0;
    const padTop = 16.0;
    const padBottom = 24.0;

    final chartW = size.width - padLeft - padRight;
    final chartH = size.height - padTop - padBottom;

    if (points.isEmpty) return;

    final rawVals = logs.map((l) => UnitConverter.displayWeight(l.weightKg, unit)).toList();
    final trendVals = points.map((p) => UnitConverter.displayWeight(p.trendWeightKg, unit)).toList();

    var minY = math.min(rawVals.reduce(math.min), trendVals.reduce(math.min));
    var maxY = math.max(rawVals.reduce(math.max), trendVals.reduce(math.max));

    if (goalKg != null) {
      final goalDisp = UnitConverter.displayWeight(goalKg!, unit);
      minY = math.min(minY, goalDisp);
      maxY = math.max(maxY, goalDisp);
    }

    final diff = maxY - minY;
    final range = diff < 0.5 ? 1.0 : diff + 0.4;
    minY -= 0.2;

    // Grid baseline
    final gridPaint = Paint()
      ..color = line.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(padLeft, padTop + chartH), Offset(padLeft + chartW, padTop + chartH), gridPaint);

    // Goal line
    if (goalKg != null) {
      final goalDisp = UnitConverter.displayWeight(goalKg!, unit);
      final goalY = padTop + chartH - ((goalDisp - minY) / range) * chartH;
      final goalPaint = Paint()
        ..color = gold
        ..strokeWidth = 1.5;
      _drawDashedLine(canvas, Offset(padLeft, goalY), Offset(padLeft + chartW, goalY), goalPaint);
    }

    final totalPoints = points.length;

    // 1. Draw Raw weigh-ins as dots
    final dotPaint = Paint()..color = textMute.withValues(alpha: 0.5);
    for (var i = 0; i < totalPoints; i++) {
      final x = padLeft + (i / math.max(1, totalPoints - 1)) * chartW;
      final yVal = UnitConverter.displayWeight(points[i].rawWeightKg, unit);
      final y = padTop + chartH - ((yVal - minY) / range) * chartH;
      canvas.drawCircle(Offset(x, y), 3.5, dotPaint);
    }

    // 2. Draw Trend line (EMA)
    final trendPath = Path();
    for (var i = 0; i < totalPoints; i++) {
      final x = padLeft + (i / math.max(1, totalPoints - 1)) * chartW;
      final yVal = UnitConverter.displayWeight(points[i].trendWeightKg, unit);
      final y = padTop + chartH - ((yVal - minY) / range) * chartH;
      if (i == 0) {
        trendPath.moveTo(x, y);
      } else {
        trendPath.lineTo(x, y);
      }
    }

    final trendPaint = Paint()
      ..color = ember
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(trendPath, trendPaint);

    // Draw end dot on trend line
    if (totalPoints > 0) {
      final lastX = padLeft + chartW;
      final lastYVal = UnitConverter.displayWeight(points.last.trendWeightKg, unit);
      final lastY = padTop + chartH - ((lastYVal - minY) / range) * chartH;
      canvas.drawCircle(Offset(lastX, lastY), 5.0, Paint()..color = ember);
      canvas.drawCircle(Offset(lastX, lastY), 2.5, Paint()..color = Colors.white);
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
  bool shouldRepaint(covariant _WeightTrendPainter oldDelegate) => true;
}

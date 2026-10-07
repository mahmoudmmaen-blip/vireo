import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/measurements/domain/body_measurement.dart';

class MeasurementWeightChart extends StatelessWidget {
  const MeasurementWeightChart({
    super.key,
    required this.measurements,
  });

  final List<BodyMeasurement> measurements;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;

    if (measurements.length < 2) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text(
            l10n.measurementsNeedMoreData,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textMute),
          ),
        ),
      );
    }

    final sorted = [...measurements]..sort((a, b) => a.date.compareTo(b.date));
    final weights = sorted.map((m) => m.weightKg).toList();
    final minW = weights.reduce((a, b) => a < b ? a : b) - 2;
    final maxW = weights.reduce((a, b) => a > b ? a : b) + 2;

    final spots = <FlSpot>[
      for (var i = 0; i < sorted.length; i++)
        FlSpot(i.toDouble(), sorted[i].weightKg),
    ];

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minY: minW,
          maxY: maxW,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colors.line.withValues(alpha: 0.6),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(color: colors.textMute, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: (sorted.length / 4).clamp(1, 999).toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sorted.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormat('dd/MM', locale).format(sorted[index].date),
                      style: TextStyle(color: colors.textMute, fontSize: 9),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final index = spot.x.toInt();
                  if (index < 0 || index >= sorted.length) return null;
                  final m = sorted[index];
                  return LineTooltipItem(
                    '${m.weightKg.toStringAsFixed(1)} kg\n${DateFormat.yMMMd(locale).format(m.date)}',
                    TextStyle(color: colors.text, fontWeight: FontWeight.w600),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: colors.ember,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 4,
                  color: colors.ember,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: colors.ember.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeasurementSparkline extends StatelessWidget {
  const MeasurementSparkline({
    super.key,
    required this.measurements,
  });

  final List<BodyMeasurement> measurements;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    if (measurements.length < 2) {
      return const SizedBox(height: 36);
    }

    final sorted = [...measurements]..sort((a, b) => a.date.compareTo(b.date));
    final weights = sorted.map((m) => m.weightKg).toList();
    final minW = weights.reduce((a, b) => a < b ? a : b);
    final maxW = weights.reduce((a, b) => a > b ? a : b);
    final range = (maxW - minW).abs() < 0.1 ? 1.0 : maxW - minW;

    final spots = [
      for (var i = 0; i < sorted.length; i++)
        FlSpot(i.toDouble(), sorted[i].weightKg),
    ];

    return SizedBox(
      height: 36,
      child: LineChart(
        LineChartData(
          minY: minW - range * 0.1,
          maxY: maxW + range * 0.1,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: colors.ember,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/progress_models.dart';

class AdherenceBarChart extends StatelessWidget {
  const AdherenceBarChart({super.key, required this.weeks});

  final List<AdherenceWeek> weeks;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    if (weeks.isEmpty) {
      return SizedBox(
        height: 240,
        child: Center(
          child: Text('—', style: TextStyle(color: colors.textMute)),
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          maxY: 100,
          minY: 0,
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
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
                reservedSize: 34,
                interval: 25,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}%',
                  style: TextStyle(color: colors.textMute, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= weeks.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat.MMMd().format(weeks[index].weekStart),
                      style: TextStyle(color: colors.textMute, fontSize: 9),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final week = weeks[group.x.toInt()];
                return BarTooltipItem(
                  '${week.completionPct}%\n${DateFormat.yMMMd().format(week.weekStart)}',
                  TextStyle(color: colors.text, fontWeight: FontWeight.w600),
                );
              },
            ),
          ),
          barGroups: [
            for (var i = 0; i < weeks.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: weeks[i].completionPct.toDouble().clamp(0, 100),
                    width: 18,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    color: weeks[i].completionPct >= 70
                        ? colors.ember
                        : weeks[i].completionPct == 0
                            ? colors.line
                            : colors.textMute.withValues(alpha: 0.55),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

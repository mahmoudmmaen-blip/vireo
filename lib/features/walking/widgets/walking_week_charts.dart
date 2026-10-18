import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/domain/walking_calculations.dart';

/// Last-7-days steps (bars) and walking calories (line), from the shared step history.
class WalkingWeekCharts extends StatelessWidget {
  const WalkingWeekCharts({
    super.key,
    required this.days,
    required this.heightCm,
    required this.weightKg,
    required this.isFemale,
  });

  final List<DailyStepCount> days;
  final double heightCm;
  final double weightKg;
  final bool isFemale;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final loggedDays = days.where((d) => d.steps > 0).length;
    if (loggedDays < 2) {
      return _Empty(
        message: isArabic
            ? 'لسه مفيش بيانات كفاية. امشى يومين عشان الرسم يظهر.'
            : 'Not enough data yet. Walk on two days to see the chart.',
      );
    }

    final accent = colors.ember;
    final labels = days
        .map((d) => DateFormat.E(Localizations.localeOf(context).toString()).format(d.date))
        .toList();
    final kcal = days
        .map(
          (d) => WalkingCalculations.compute(
            steps: d.steps,
            heightCm: heightCm,
            weightKg: weightKg,
            isFemale: isFemale,
          ).caloriesKcal.toDouble(),
        )
        .toList();
    final maxSteps = days.fold<int>(1, (m, d) => d.steps > m ? d.steps : m).toDouble();
    final maxKcal = kcal.fold<double>(1, (m, v) => v > m ? v : m);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isArabic ? 'الخطوات آخر ٧ أيام' : 'Steps, last 7 days',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.w800, fontSize: 15),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: BarChart(
            BarChartData(
              maxY: maxSteps * 1.15,
              minY: 0,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: colors.line.withValues(alpha: 0.7),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: _titles(labels, colors),
              barGroups: [
                for (var i = 0; i < days.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: days[i].steps.toDouble(),
                        color: accent,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isArabic ? 'سعرات المشي آخر ٧ أيام' : 'Walking calories, last 7 days',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.w800, fontSize: 15),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: maxKcal * 1.2,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: colors.line.withValues(alpha: 0.7),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: _titles(labels, colors),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < kcal.length; i++) FlSpot(i.toDouble(), kcal[i]),
                  ],
                  isCurved: true,
                  color: accent,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                      radius: 3,
                      color: accent,
                      strokeWidth: 0,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: accent.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  FlTitlesData _titles(List<String> labels, VireoColors colors) {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitlesWidget: (value, meta) {
            final i = value.round();
            if (i < 0 || i >= labels.length) return const SizedBox.shrink();
            return Text(
              labels[i],
              style: TextStyle(color: colors.textMute, fontSize: 10),
            );
          },
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      height: 120,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: colors.textMute, fontSize: 14, height: 1.35),
      ),
    );
  }
}

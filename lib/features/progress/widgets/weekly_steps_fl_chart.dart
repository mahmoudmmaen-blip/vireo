import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/daily_step_count.dart';

/// Weekly steps bar chart from [StepsRepository] history (P53).
class WeeklyStepsFlChart extends StatelessWidget {
  const WeeklyStepsFlChart({
    super.key,
    required this.days,
    required this.goal,
  });

  final List<DailyStepCount> days;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final active = days.where((d) => d.steps > 0).length;

    if (active == 0) {
      return _Empty(
        message: isArabic
            ? 'لسه مفيش خطوات مسجّلة الأسبوع ده. امشي شوية وهيتظهر الرسم.'
            : 'No steps logged this week yet. Take a short walk and the chart will appear.',
      );
    }

    final maxY = days
        .fold<int>(goal, (m, d) => d.steps > m ? d.steps : m)
        .toDouble();
    final labels = days
        .map(
          (d) => DateFormat.E(Localizations.localeOf(context).toString())
              .format(d.date),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          isArabic ? 'الخطوات آخر ٧ أيام' : 'Steps, last 7 days',
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isArabic
              ? 'الخط المتقطع = هدفك اليومي'
              : 'Dashed line = daily step goal',
          style: TextStyle(color: colors.textMute, fontSize: 12),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maxY * 1.15,
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
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: goal.toDouble(),
                    color: VMacro.steps.withValues(alpha: 0.9),
                    strokeWidth: 2,
                    dashArray: [6, 4],
                  ),
                ],
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (value, meta) {
                      final i = value.round();
                      if (i < 0 || i >= labels.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        labels[i],
                        style: TextStyle(
                          color: colors.textMute,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < days.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: days[i].steps.toDouble(),
                        color: days[i].steps >= goal
                            ? colors.success
                            : VMacro.steps,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
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
      height: 140,
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
        style: TextStyle(
          color: colors.textMute,
          fontSize: 14,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/progress/models/daily_deficit_entry.dart';

/// Weekly calorie intake bars vs daily goal (P53).
class WeeklyCaloriesIntakeChart extends StatelessWidget {
  const WeeklyCaloriesIntakeChart({
    super.key,
    required this.summary,
  });

  final WeeklyDeficitSummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final days = summary.days;
    final logged = days.where((d) => d.hasFoodLogged).length;

    if (logged == 0) {
      return _EmptyChartBox(
        message: isArabic
            ? 'لسه ما سجلتش وجبات الأسبوع ده. صوّر وجبة وهتلاقي الرسم هنا.'
            : 'No meals logged this week yet. Snap a meal and the chart will show up here.',
      );
    }

    final goal = days.isNotEmpty ? days.first.tdee.toDouble() : 2000.0;
    final maxY = days
        .fold<double>(goal, (m, d) => d.consumed > m ? d.consumed.toDouble() : m);
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
          isArabic ? 'السعرات مقابل الهدف' : 'Calories vs goal',
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isArabic
              ? 'الخط = هدفك اليومي · الأعمدة = اللي اتاكل'
              : 'Line = daily goal · bars = eaten',
          style: TextStyle(color: colors.textMute, fontSize: 12),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maxY * 1.2,
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
                    y: goal,
                    color: colors.success.withValues(alpha: 0.85),
                    strokeWidth: 2,
                    dashArray: [6, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topLeft,
                      style: TextStyle(
                        color: colors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      labelResolver: (_) =>
                          isArabic ? 'الهدف' : 'Goal',
                    ),
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
                        toY: days[i].consumed.toDouble().clamp(0, maxY * 1.2),
                        color: days[i].hasFoodLogged
                            ? VMacro.carbs
                            : colors.line,
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

class _EmptyChartBox extends StatelessWidget {
  const _EmptyChartBox({required this.message});

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

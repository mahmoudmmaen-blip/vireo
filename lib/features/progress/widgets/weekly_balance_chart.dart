import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/models/daily_deficit_entry.dart';

/// ميزان الأسبوع — daily surplus/deficit bars + cumulative line.
class WeeklyBalanceChart extends StatelessWidget {
  const WeeklyBalanceChart({
    super.key,
    required this.summary,
    this.weeklyTargetDeficit = 3500,
  });

  final WeeklyDeficitSummary summary;
  final int weeklyTargetDeficit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final days = summary.days;
    if (days.isEmpty || !summary.hasData) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(l10n.weeklyBalanceEmpty, style: TextStyle(color: colors.textMute)),
        ),
      );
    }

    final cum = <double>[];
    var running = 0.0;
    for (final d in days) {
      // netBalance in DailyDeficitEntry is TDEE − consumed + burned (deficit positive)
      running += d.netBalance.toDouble();
      cum.add(running);
    }
    final weekDeficit = summary.totalNetKcal;
    final onTrack = weekDeficit >= (weeklyTargetDeficit * 0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.weeklyBalanceTitle,
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          onTrack
              ? l10n.weeklyBalanceOnTrack(weekDeficit, weeklyTargetDeficit)
              : l10n.weeklyBalanceOffTrack(weekDeficit, weeklyTargetDeficit),
          style: TextStyle(color: colors.textMute, height: 1.35),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 800,
              minY: -800,
              barGroups: [
                for (var i = 0; i < days.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: days[i].netBalance.toDouble().clamp(-800, 800),
                        color: days[i].netBalance >= 0 ? colors.success : colors.ember,
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 || i >= days.length) return const SizedBox.shrink();
                      return Text(
                        '${days[i].date.day}',
                        style: TextStyle(color: colors.textMute, fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(color: colors.line, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(y: 0, color: colors.line, strokeWidth: 1),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.weeklyBalanceCumulative(cum.isEmpty ? 0 : cum.last.round()),
          style: TextStyle(color: colors.gold, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

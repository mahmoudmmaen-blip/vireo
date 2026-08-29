import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/models/daily_deficit_entry.dart';

const _deficitGreen = Color(0xFF2E7D32);
const _surplusAmber = Color(0xFFE8763C);

class WeeklyDeficitChart extends StatelessWidget {
  const WeeklyDeficitChart({
    super.key,
    required this.summary,
  });

  final WeeklyDeficitSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;

    if (!summary.hasData) {
      return SizedBox(
        height: 240,
        child: Center(
          child: Text(
            l10n.weeklyDeficitEmpty,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textMute),
          ),
        ),
      );
    }

    final days = summary.days;
    final values = days.map((d) => d.netBalance.toDouble()).toList();
    final maxAbs = values.map((v) => v.abs()).fold<double>(0, (a, b) => a > b ? a : b);
    final chartMax = (maxAbs * 1.25).clamp(200, 4000).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.weeklyDeficitTotal(summary.totalNetKcal),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: summary.totalNetKcal >= 0 ? _deficitGreen : _surplusAmber,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              minY: -chartMax,
              maxY: chartMax,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  if (value == 0) {
                    return FlLine(color: colors.textMute, strokeWidth: 1.2);
                  }
                  return FlLine(
                    color: colors.line.withValues(alpha: 0.5),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: chartMax / 2,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return Text(
                        '${value.toInt()}',
                        style: TextStyle(color: colors.textMute, fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= days.length) {
                        return const SizedBox.shrink();
                      }
                      final label = DateFormat.E(locale).format(days[index].date);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          label,
                          style: TextStyle(color: colors.textMute, fontSize: 10),
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
                    final day = days[group.x.toInt()];
                    return BarTooltipItem(
                      l10n.weeklyDeficitTooltip(
                        day.netBalance,
                        day.consumed,
                        day.burned,
                      ),
                      TextStyle(color: colors.text, fontWeight: FontWeight.w600),
                    );
                  },
                ),
              ),
              barGroups: [
                for (var i = 0; i < days.length; i++)
                  _barGroup(i, days[i].netBalance.toDouble()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _barGroup(int index, double value) {
    final color = value >= 0 ? _deficitGreen : _surplusAmber;
    final fromY = value >= 0 ? 0.0 : value;
    final toY = value >= 0 ? value : 0.0;

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          fromY: fromY,
          toY: toY,
          width: 16,
          borderRadius: BorderRadius.vertical(
            top: value >= 0 ? const Radius.circular(4) : Radius.zero,
            bottom: value < 0 ? const Radius.circular(4) : Radius.zero,
          ),
          color: color,
        ),
      ],
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/measurements/providers/measurement_provider.dart';
import 'package:vireo/features/measurements/screens/measurements_screen.dart';

enum BodyPartSelection { waist, chest, arms, thighs }

class BodyMeasurementsSection extends ConsumerStatefulWidget {
  const BodyMeasurementsSection({super.key});

  @override
  ConsumerState<BodyMeasurementsSection> createState() => _BodyMeasurementsSectionState();
}

class _BodyMeasurementsSectionState extends ConsumerState<BodyMeasurementsSection> {
  BodyPartSelection _part = BodyPartSelection.waist;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final listAsync = ref.watch(measurementListProvider);

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
            children: [
              Text(
                l10n.bodyCircumferenceTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const MeasurementsScreen()),
                ),
                child: Row(
                  children: [
                    Text(l10n.measurementsHistory, style: TextStyle(color: colors.ember, fontSize: 12)),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 16, color: colors.ember),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Part Switcher
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip(BodyPartSelection.waist, l10n.measurementsWaist),
                const SizedBox(width: 8),
                _chip(BodyPartSelection.chest, l10n.measurementsChest),
                const SizedBox(width: 8),
                _chip(BodyPartSelection.arms, l10n.measurementsArms),
                const SizedBox(width: 8),
                _chip(BodyPartSelection.thighs, l10n.measurementsThighs),
              ],
            ),
          ),
          const SizedBox(height: 16),
          listAsync.when(
            loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
            error: (e, st) => SizedBox(height: 120, child: Center(child: Text(l10n.authErrorGeneric))),
            data: (list) {
              final sorted = [...list]..sort((a, b) => a.date.compareTo(b.date));
              final points = <FlSpot>[];
              final values = <double>[];

              for (var i = 0; i < sorted.length; i++) {
                final m = sorted[i];
                final val = switch (_part) {
                  BodyPartSelection.waist => m.waistCm,
                  BodyPartSelection.chest => m.chestCm,
                  BodyPartSelection.arms => m.armsCm,
                  BodyPartSelection.thighs => m.thighsCm,
                };
                if (val != null && val > 0) {
                  points.add(FlSpot(points.length.toDouble(), val));
                  values.add(val);
                }
              }

              if (points.length < 2) {
                return Container(
                  height: 150,
                  alignment: Alignment.center,
                  child: Text(
                    '${l10n.measurementsNeedMoreData} (${_partLabel(l10n)})',
                    style: TextStyle(color: colors.textMute, fontSize: 12),
                  ),
                );
              }

              final minY = values.reduce((a, b) => a < b ? a : b) - 2;
              final maxY = values.reduce((a, b) => a > b ? a : b) + 2;

              return SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    minY: minY,
                    maxY: maxY,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: colors.line.withValues(alpha: 0.5),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (v, _) => Text(
                            '${v.toInt()}cm',
                            style: TextStyle(color: colors.textMute, fontSize: 9),
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: points,
                        isCurved: true,
                        color: colors.ember,
                        barWidth: 2.5,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                            radius: 3.5,
                            color: colors.ember,
                            strokeColor: Colors.white,
                            strokeWidth: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _partLabel(AppLocalizations l10n) {
    return switch (_part) {
      BodyPartSelection.waist => l10n.measurementsWaist,
      BodyPartSelection.chest => l10n.measurementsChest,
      BodyPartSelection.arms => l10n.measurementsArms,
      BodyPartSelection.thighs => l10n.measurementsThighs,
    };
  }

  Widget _chip(BodyPartSelection target, String label) {
    final colors = context.vireoColors;
    final active = _part == target;

    return ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) => setState(() => _part = target),
      selectedColor: colors.ember.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: active ? colors.ember : colors.textMute,
        fontWeight: active ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }
}

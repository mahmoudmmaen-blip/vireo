import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/features/measurements/domain/measurement_trend.dart';
import 'package:vireo/features/measurements/providers/measurement_provider.dart';
import 'package:vireo/features/measurements/screens/measurements_screen.dart';
import 'package:vireo/features/measurements/widgets/measurement_weight_chart.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class MeasurementSummaryCard extends ConsumerWidget {
  const MeasurementSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final listAsync = ref.watch(measurementListProvider);
    final trend = ref.watch(measurementTrendProvider);

    return listAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();

        final latest = list.first;
        final sparkData = list.take(7).toList().reversed.toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const MeasurementsScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: VireoDecorations.premiumCard(colors),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.monitor_weight_outlined, color: colors.ember, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.measurementsTitle,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        _TrendIcon(trend: trend),
                        const Icon(Icons.chevron_right, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${latest.weightKg.toStringAsFixed(1)} kg',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    MeasurementSparkline(measurements: sparkData),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TrendIcon extends StatelessWidget {
  const _TrendIcon({required this.trend});

  final MeasurementTrend trend;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (trend) {
      MeasurementTrend.improving => (Icons.arrow_downward, VBridge.cFF2E7D32),
      MeasurementTrend.declining => (Icons.arrow_upward, VBridge.cFFC62828),
      MeasurementTrend.stable => (Icons.arrow_forward, Colors.grey),
    };

    return Icon(icon, color: color, size: 20);
  }
}

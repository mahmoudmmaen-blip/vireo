import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/features/measurements/domain/body_measurement.dart';
import 'package:vireo/features/measurements/domain/measurement_trend.dart';
import 'package:vireo/features/measurements/providers/measurement_provider.dart';
import 'package:vireo/features/measurements/widgets/add_measurement_sheet.dart';
import 'package:vireo/core/widgets/vireo_fab.dart';
import 'package:vireo/features/measurements/widgets/measurement_weight_chart.dart';

class MeasurementsScreen extends ConsumerWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final listAsync = ref.watch(measurementListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.measurementsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showAddMeasurementSheet(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          listAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text(l10n.authErrorGeneric)),
            data: (list) {
              if (list.isEmpty) {
                return _EmptyState(onAdd: () => showAddMeasurementSheet(context));
              }
              return _MeasurementsBody(list: list);
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: VireoFab(
              onPressed: () => showAddMeasurementSheet(context),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monitor_weight_outlined, size: 72, color: colors.textMute),
            const SizedBox(height: 16),
            Text(
              l10n.measurementsNoData,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(l10n.measurementsAddFirst),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementsBody extends ConsumerWidget {
  const _MeasurementsBody({required this.list});

  final List<BodyMeasurement> list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final trend = ref.watch(measurementTrendProvider);
    final chartData = ref.watch(filteredMeasurementsProvider);
    final range = ref.watch(measurementChartRangeProvider);
    final latest = list.first;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: VireoDecorations.premiumCard(colors, glow: true),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${latest.weightKg.toStringAsFixed(1)} kg',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.measurementsLastUpdated}: ${DateFormat.MMMd(locale).format(latest.date)}',
                          style: TextStyle(color: colors.textMute),
                        ),
                      ],
                    ),
                  ),
                  _TrendBadge(trend: trend),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _RangeToggle(selected: range),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: VireoDecorations.premiumCard(colors),
          child: MeasurementWeightChart(measurements: chartData),
        ),
        const SizedBox(height: 24),
        Text(l10n.measurementsHistory, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...list.map((m) => _HistoryTile(measurement: m)),
      ],
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.trend});

  final MeasurementTrend trend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, color, label) = switch (trend) {
      MeasurementTrend.improving => (
          Icons.trending_down,
          const Color(0xFF2E7D32),
          l10n.measurementsTrendImproving,
        ),
      MeasurementTrend.declining => (
          Icons.trending_up,
          const Color(0xFFC62828),
          l10n.measurementsTrendDeclining,
        ),
      MeasurementTrend.stable => (
          Icons.trending_flat,
          Colors.grey,
          l10n.measurementsTrendStable,
        ),
    };

    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}

class _RangeToggle extends ConsumerWidget {
  const _RangeToggle({required this.selected});

  final MeasurementChartRange selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    Widget chip(MeasurementChartRange range, String label) {
      final active = selected == range;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: active,
          onSelected: (_) => ref.read(measurementChartRangeProvider.notifier).state = range,
          selectedColor: colors.ember.withValues(alpha: 0.25),
          labelStyle: TextStyle(
            color: active ? colors.ember : colors.textMute,
            fontWeight: active ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip(MeasurementChartRange.days7, l10n.measurements7Days),
          chip(MeasurementChartRange.days30, l10n.measurements30Days),
          chip(MeasurementChartRange.months3, l10n.measurements3Months),
          chip(MeasurementChartRange.all, l10n.measurementsAll),
        ],
      ),
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.measurement});

  final BodyMeasurement measurement;

  Future<bool> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.measurementsDelete),
        content: Text(l10n.measurementsDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.deleteAccountCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.measurementsDelete),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = DateFormat.yMMMd(locale).format(measurement.date);
    final waist = measurement.waistCm != null
        ? '${measurement.waistCm!.toStringAsFixed(0)} cm'
        : '—';

    return Dismissible(
      key: ValueKey(measurement.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        ref.read(measurementListProvider.notifier).deleteMeasurement(measurement.id);
      },
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.withValues(alpha: 0.85),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        title: Text(dateStr),
        subtitle: Text('${measurement.weightKg.toStringAsFixed(1)} kg · $waist'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colors.ember),
              onPressed: () => showAddMeasurementSheet(context, existing: measurement),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                if (await _confirmDelete(context) && context.mounted) {
                  ref.read(measurementListProvider.notifier).deleteMeasurement(measurement.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

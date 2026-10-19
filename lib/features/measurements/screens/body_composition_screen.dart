import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/utils/platform_utils.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/measurements/screens/inbody_scan_screen.dart';
import 'package:vireo/features/measurements/screens/navy_tape_measure_screen.dart';
import 'package:vireo/features/measurements/services/body_comp_health_sync.dart';
import 'package:vireo/features/measurements/widgets/segmental_body_figure.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class BodyCompositionScreen extends ConsumerStatefulWidget {
  const BodyCompositionScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const BodyCompositionScreen()),
    );
  }

  @override
  ConsumerState<BodyCompositionScreen> createState() =>
      _BodyCompositionScreenState();
}

class _BodyCompositionScreenState extends ConsumerState<BodyCompositionScreen> {
  BodyCompositionReport? _compareA;
  BodyCompositionReport? _compareB;

  static String _sourceLabel(BodyCompositionSource source, bool isArabic) {
    return switch (source) {
      BodyCompositionSource.inbodyScan => isArabic ? 'تقرير InBody' : 'InBody Scan',
      BodyCompositionSource.navyTape => isArabic ? 'قياس المازورة (Navy)' : 'Tape Measure',
      BodyCompositionSource.healthConnect => 'Health Connect',
      BodyCompositionSource.manual => isArabic ? 'يدوي' : 'Manual',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final async = ref.watch(bodyCompositionListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.inbodyBodyTitle),
        actions: [
          IconButton(
            tooltip: isArabic ? 'قياس المازورة (Navy)' : 'Tape Measure',
            icon: const Icon(Icons.straighten),
            onPressed: () => NavyTapeMeasureScreen.open(context),
          ),
          if (PlatformUtils.isAndroid)
            IconButton(
              tooltip: l10n.inbodySyncHealth,
              icon: const Icon(Icons.sync),
              onPressed: () async {
                final n = await BodyCompHealthSync.syncFromHealthConnect(
                  ref.read(bodyCompositionRepositoryProvider),
                );
                await ref.read(bodyCompositionListProvider.notifier).refresh();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    persist: false,
                    duration: const Duration(seconds: 3),
                    content: Text(l10n.inbodySyncResult(n)),
                  ),
                );
              },
            ),
          IconButton(
            tooltip: l10n.inbodyAddResult,
            icon: const Icon(Icons.add_a_photo_outlined),
            onPressed: () => InBodyScanScreen.open(context),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.authErrorGeneric)),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.inbodyEmpty, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => NavyTapeMeasureScreen.open(context),
                      icon: const Icon(Icons.straighten),
                      label: Text(isArabic ? 'قياس المازورة (طريقة البحرية)' : 'Tape Measure (Navy)'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => InBodyScanScreen.open(context),
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: Text(l10n.inbodyAddResult),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.inbodyMedicalNote,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.textMute, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }

          final latest = list.first;
          _compareA ??= list.first;
          _compareB ??= list.length > 1 ? list[1] : list.first;

          return ListView(
            padding: const EdgeInsets.all(VSpace.md),
            children: [
              Text(l10n.inbodyMedicalNote,
                  style: TextStyle(color: colors.textMute, fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => NavyTapeMeasureScreen.open(context),
                      icon: const Icon(Icons.straighten, size: 18),
                      label: Text(isArabic ? 'قياس المازورة' : 'Tape Measure'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => InBodyScanScreen.open(context),
                      icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                      label: Text(l10n.inbodyAddResult),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.inbodyLatestTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.ember.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colors.ember.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _sourceLabel(latest.source, isArabic),
                      style: TextStyle(
                        color: colors.ember,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat.yMMMd().format(latest.testDate),
                style: TextStyle(color: colors.textMute),
              ),
              const SizedBox(height: 8),
              if (latest.segmentalLean.trunk.kg?.hasValue == true) ...[
                SegmentalBodyFigure(lean: latest.segmentalLean),
                const SizedBox(height: 16),
              ],
              // Primary Body Comp Charts: BF% & Lean Mass
              _MetricChart(
                title: isArabic ? 'نسبة الدهون (%BF)' : 'Body Fat %',
                reports: list,
                valueOf: (r) => r.percentBodyFat,
              ),
              _MetricChart(
                title: isArabic ? 'الكتلة العضلية / الصافية (كجم)' : 'Lean Mass (kg)',
                reports: list,
                valueOf: (r) => r.leanMassKg ?? r.skeletalMuscleMassKg,
              ),
              _MetricChart(
                title: l10n.inbodyWeight,
                reports: list,
                valueOf: (r) => r.weightKg,
              ),
              _MetricChart(
                title: l10n.inbodyFatMass,
                reports: list,
                valueOf: (r) => r.bodyFatMassKg,
              ),
              _MetricChart(
                title: l10n.inbodyVisceral,
                reports: list,
                valueOf: (r) => r.visceralFatLevel,
              ),
              const SizedBox(height: 16),
              Text(l10n.inbodyCompareTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Expanded(
                    child: _ReportDropdown(
                      label: 'A',
                      value: _compareA,
                      reports: list,
                      onChanged: (r) => setState(() => _compareA = r),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ReportDropdown(
                      label: 'B',
                      value: _compareB,
                      reports: list,
                      onChanged: (r) => setState(() => _compareB = r),
                    ),
                  ),
                ],
              ),
              if (_compareA != null && _compareB != null)
                _CompareCard(
                  newer: _compareA!.testDate.isAfter(_compareB!.testDate)
                      ? _compareA!
                      : _compareB!,
                  older: _compareA!.testDate.isAfter(_compareB!.testDate)
                      ? _compareB!
                      : _compareA!,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportDropdown extends StatelessWidget {
  const _ReportDropdown({
    required this.label,
    required this.value,
    required this.reports,
    required this.onChanged,
  });

  final String label;
  final BodyCompositionReport? value;
  final List<BodyCompositionReport> reports;
  final ValueChanged<BodyCompositionReport> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<BodyCompositionReport>(
      key: ValueKey('${label}_${value?.id}'),
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        for (final r in reports)
          DropdownMenuItem(
            value: r,
            child: Text(DateFormat.yMMMd().format(r.testDate)),
          ),
      ],
      onChanged: (r) {
        if (r != null) onChanged(r);
      },
    );
  }
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({required this.newer, required this.older});

  final BodyCompositionReport newer;
  final BodyCompositionReport older;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final delta = BodyCompositionMath.compare(newer, older);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _DeltaRow(l10n.inbodySmm, delta.skeletalMuscleMassKg, goodWhenUp: true),
            _DeltaRow(l10n.inbodyFatMass, delta.bodyFatMassKg, goodWhenUp: false),
            _DeltaRow(l10n.inbodyPbf, delta.percentBodyFat, goodWhenUp: false),
            _DeltaRow(l10n.inbodyWeight, delta.weightKg, goodWhenUp: null),
            _DeltaRow(l10n.inbodyVisceral, delta.visceralFatLevel, goodWhenUp: false),
          ],
        ),
      ),
    );
  }
}

class _DeltaRow extends StatelessWidget {
  const _DeltaRow(this.label, this.delta, {required this.goodWhenUp});
  final String label;
  final double? delta;
  final bool? goodWhenUp;

  @override
  Widget build(BuildContext context) {
    if (delta == null) {
      return ListTile(
        dense: true,
        title: Text(label),
        trailing: const Text('—'),
      );
    }
    final up = delta! > 0;
    Color? color;
    if (goodWhenUp != null) {
      final good = goodWhenUp! ? up : !up;
      color = good ? VBridge.cFF2E7D32 : context.vireoColors.danger;
    }
    final sign = delta! > 0 ? '+' : '';
    return ListTile(
      dense: true,
      title: Text(label),
      trailing: Text(
        '$sign${delta!.toStringAsFixed(1)}',
        style: TextStyle(color: color, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _MetricChart extends StatelessWidget {
  const _MetricChart({
    required this.title,
    required this.reports,
    required this.valueOf,
  });

  final String title;
  final List<BodyCompositionReport> reports;
  final double? Function(BodyCompositionReport) valueOf;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final points = <FlSpot>[];
    for (var i = 0; i < reports.length; i++) {
      // chronological left→right
      final r = reports[reports.length - 1 - i];
      final v = valueOf(r);
      if (v != null) points.add(FlSpot(i.toDouble(), v));
    }
    if (points.length < 2) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text('$title —', style: TextStyle(color: colors.textMute)),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: points,
                    isCurved: true,
                    color: colors.ember,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

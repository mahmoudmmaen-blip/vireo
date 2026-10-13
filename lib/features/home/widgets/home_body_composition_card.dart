import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/measurements/screens/inbody_scan_screen.dart';
import 'package:vireo/features/measurements/screens/navy_tape_measure_screen.dart';

/// "تحليل الجسم" card on Home (below the score card).
/// Shows latest body fat %, muscle mass, visceral fat, and trend arrows,
/// plus primary "صوّر تقرير InBody" and secondary "قيس بالشريط".
/// Empty state: "عندك InBody؟ صوّره وإحنا نظبط خطتك عليه".
class HomeBodyCompositionCard extends ConsumerWidget {
  const HomeBodyCompositionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    final latest = ref.watch(latestBodyCompositionProvider);
    final historyList = ref.watch(bodyCompositionListProvider).valueOrNull ?? const [];

    BodyCompositionReport? previous;
    if (latest != null && historyList.length > 1) {
      previous = historyList.firstWhere(
        (r) => r.id != latest.id,
        orElse: () => latest,
      );
      if (previous.id == latest.id) previous = null;
    }

    final delta = (latest != null && previous != null)
        ? BodyCompositionMath.compare(latest, previous)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: VSpace.md),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(VRadius.lg),
        border: Border.all(color: colors.line),
      ),
      child: latest == null
          ? _buildEmptyState(context, colors, isArabic)
          : _buildDataState(context, colors, isArabic, latest, delta),
    );
  }

  Widget _buildEmptyState(BuildContext context, VireoColors colors, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.ember.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('📊', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'تحليل الجسم' : 'Body Composition',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isArabic
                        ? 'عندك InBody؟ صوّره وإحنا نظبط خطتك عليه'
                        : 'Have an InBody scan? Snap it and we will tune your plan',
                    style: TextStyle(
                      color: colors.textMute,
                      fontSize: 12.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: FilledButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  InBodyScanScreen.open(context);
                },
                icon: const Icon(Icons.camera_alt_rounded, size: 16),
                label: Text(
                  isArabic ? 'صوّر تقرير InBody' : 'Scan InBody',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.ember,
                  minimumSize: const Size.fromHeight(40),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  NavyTapeMeasureScreen.open(context);
                },
                icon: const Icon(Icons.straighten_rounded, size: 16),
                label: Text(
                  isArabic ? 'قيس بالشريط' : 'Tape Measure',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataState(
    BuildContext context,
    VireoColors colors,
    bool isArabic,
    BodyCompositionReport report,
    BodyCompositionDelta? delta,
  ) {
    final fatPercent = report.percentBodyFat;
    final smm = report.skeletalMuscleMassKg;
    final visceral = report.visceralFatLevel;

    final sourceChipLabel = switch (report.source) {
      BodyCompositionSource.inbodyScan => 'InBody',
      BodyCompositionSource.navyTape => isArabic ? 'شريط القياس' : 'Navy Tape',
      BodyCompositionSource.healthConnect => isArabic ? 'ميزان ذكي' : 'Smart Scale',
      BodyCompositionSource.manual => isArabic ? 'يدوي' : 'Manual',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    isArabic ? 'تحليل الجسم' : 'Body Composition',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.ember.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      sourceChipLabel,
                      style: TextStyle(
                        color: colors.ember,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat.MMMd().format(report.testDate),
              style: TextStyle(color: colors.textMute, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 3-Metric Row
        Row(
          children: [
            // Body fat %
            Expanded(
              child: _MetricTile(
                title: isArabic ? 'نسبة الدهون' : 'Body Fat',
                value: fatPercent != null ? '${fatPercent.toStringAsFixed(1)}%' : '--',
                deltaText: delta?.percentBodyFat != null
                    ? _deltaStr(delta!.percentBodyFat!, '%')
                    : null,
                isPositiveChange: delta?.percentBodyFat != null && delta!.percentBodyFat! < 0,
                colors: colors,
              ),
            ),
            const SizedBox(width: 8),

            // Muscle mass (SMM)
            Expanded(
              child: _MetricTile(
                title: isArabic ? 'العضلات (SMM)' : 'Muscle (SMM)',
                value: smm != null ? '${smm.toStringAsFixed(1)} كجم' : '--',
                deltaText: delta?.skeletalMuscleMassKg != null
                    ? _deltaStr(delta!.skeletalMuscleMassKg!, 'كجم')
                    : null,
                isPositiveChange: delta?.skeletalMuscleMassKg != null && delta!.skeletalMuscleMassKg! > 0,
                colors: colors,
              ),
            ),
            const SizedBox(width: 8),

            // Visceral fat
            Expanded(
              child: _MetricTile(
                title: isArabic ? 'دهون حشوية' : 'Visceral Fat',
                value: visceral != null ? visceral.toStringAsFixed(0) : '--',
                statusLabel: visceral != null
                    ? (visceral <= 9
                        ? (isArabic ? 'صحية ✓' : 'Healthy ✓')
                        : (isArabic ? 'مرتفعة' : 'High'))
                    : null,
                isPositiveChange: visceral != null && visceral <= 9,
                colors: colors,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Action buttons
        Row(
          children: [
            Expanded(
              flex: 6,
              child: FilledButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  InBodyScanScreen.open(context);
                },
                icon: const Icon(Icons.camera_alt_rounded, size: 16),
                label: Text(
                  isArabic ? 'صوّر تقرير InBody' : 'Scan InBody',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.ember,
                  minimumSize: const Size.fromHeight(38),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  NavyTapeMeasureScreen.open(context);
                },
                icon: const Icon(Icons.straighten_rounded, size: 16),
                label: Text(
                  isArabic ? 'قيس بالشريط' : 'Tape Measure',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(38),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _deltaStr(double d, String unit) {
    if (d == 0) return '0 $unit';
    final sign = d > 0 ? '+' : '';
    return '$sign${d.toStringAsFixed(1)} $unit';
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    this.deltaText,
    this.statusLabel,
    this.isPositiveChange = false,
    required this.colors,
  });

  final String title;
  final String value;
  final String? deltaText;
  final String? statusLabel;
  final bool isPositiveChange;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.textMute,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          if (deltaText != null)
            Row(
              children: [
                Icon(
                  isPositiveChange ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                  size: 13,
                  color: isPositiveChange ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    deltaText!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isPositiveChange ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          else if (statusLabel != null)
            Text(
              statusLabel!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isPositiveChange ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

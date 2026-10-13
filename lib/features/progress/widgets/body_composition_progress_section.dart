import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/measurements/screens/body_composition_screen.dart';
import 'package:vireo/features/measurements/screens/inbody_scan_screen.dart';
import 'package:vireo/features/measurements/screens/navy_tape_measure_screen.dart';

class BodyCompositionProgressSection extends ConsumerWidget {
  const BodyCompositionProgressSection({super.key});

  static String _sourceLabel(BodyCompositionSource source, bool isArabic) {
    return switch (source) {
      BodyCompositionSource.inbodyScan => isArabic ? 'تقرير InBody' : 'InBody Scan',
      BodyCompositionSource.navyTape => isArabic ? 'قياس المازورة (Navy)' : 'Tape Measure',
      BodyCompositionSource.healthConnect => 'Health Connect',
      BodyCompositionSource.manual => isArabic ? 'يدوي' : 'Manual',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');
    final latest = ref.watch(latestBodyCompositionProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.ember.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.accessibility_new_rounded, color: colors.ember, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'تحليل الجسم' : 'Body Composition',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => BodyCompositionScreen.open(context),
                child: Text(
                  isArabic ? 'السجل والمقارنة' : 'History',
                  style: TextStyle(color: colors.ember, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (latest != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMd().format(latest.testDate),
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
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
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: isArabic ? 'نسبة الدهون' : 'Body Fat',
                    value: latest.percentBodyFat != null ? '${latest.percentBodyFat!.toStringAsFixed(1)}%' : '—',
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricCard(
                    title: isArabic ? 'الكتلة العضلية' : 'Lean Mass',
                    value: latest.leanMassKg != null ? '${latest.leanMassKg!.toStringAsFixed(1)} كجم' : '—',
                    colors: colors,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: isArabic ? 'كتلة الدهون' : 'Fat Mass',
                    value: latest.bodyFatMassKg != null ? '${latest.bodyFatMassKg!.toStringAsFixed(1)} كجم' : '—',
                    colors: colors,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MetricCard(
                    title: isArabic ? 'حرق BMR' : 'BMR Kcal',
                    value: latest.bmrKcal != null ? '${latest.bmrKcal!.round()} سعرة' : '—',
                    colors: colors,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => NavyTapeMeasureScreen.open(context),
                    icon: const Icon(Icons.straighten, size: 16),
                    label: Text(isArabic ? 'قياس بالمازورة' : 'Tape Measure'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => InBodyScanScreen.open(context),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                    label: Text(isArabic ? 'مسح InBody' : 'Scan InBody'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: colors.ember,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              isArabic
                  ? 'اعرف نسبة دهونك وكتلتك العضلية وحرقك الأساسي (BMR) من خلال قياس المازورة أو مسح ورقة InBody.'
                  : 'Track your body fat %, lean muscle mass, and BMR using tape measurement or InBody scans.',
              style: TextStyle(color: colors.textMute, fontSize: 12.5, height: 1.4),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => NavyTapeMeasureScreen.open(context),
                    icon: const Icon(Icons.straighten, size: 16),
                    label: Text(isArabic ? 'قياس بالمازورة' : 'Tape Measure'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: colors.ember,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => InBodyScanScreen.open(context),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                    label: Text(isArabic ? 'مسح InBody' : 'Scan InBody'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.colors,
  });

  final String title;
  final String value;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, color: colors.textMute, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

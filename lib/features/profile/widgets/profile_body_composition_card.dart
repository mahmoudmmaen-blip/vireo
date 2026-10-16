import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/measurements/screens/body_composition_screen.dart';
import 'package:vireo/features/measurements/screens/inbody_scan_screen.dart';
import 'package:vireo/features/measurements/screens/navy_tape_measure_screen.dart';

/// "جسمي" body-composition block on the Profile screen.
///
/// Shows the latest values from [latestBodyCompositionProvider] (fat %, muscle,
/// visceral fat) and two entry points: scan an InBody report, or measure with
/// a tape (Navy method). Works as an empty state when nothing was measured.
class ProfileBodyCompositionCard extends ConsumerWidget {
  const ProfileBodyCompositionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final latest = ref.watch(latestBodyCompositionProvider);

    final muscle = latest?.skeletalMuscleMassKg ?? latest?.leanMassKg;
    final kg = isAr ? 'كجم' : 'kg';

    return VireoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.accessibility_new_rounded, color: colors.ember),
              const SizedBox(width: VSpace.sm),
              Expanded(
                child: Text(
                  isAr ? 'تحليل الجسم' : 'Body composition',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              if (latest != null)
                TextButton(
                  onPressed: () => BodyCompositionScreen.open(context),
                  child: Text(isAr ? 'السجل' : 'History'),
                ),
            ],
          ),
          const SizedBox(height: VSpace.sm),
          if (latest == null)
            Text(
              isAr
                  ? 'لسه مفيش قياس. صوّر تقرير InBody أو قيس بالشريط وإحنا نظبط خطتك عليه.'
                  : 'No measurement yet. Scan an InBody report or use a tape and we will tune your plan.',
              style: TextStyle(color: colors.textMute, height: 1.4),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    label: isAr ? 'نسبة الدهون' : 'Body fat',
                    value: latest.percentBodyFat != null
                        ? '${latest.percentBodyFat!.toStringAsFixed(1)}%'
                        : '—',
                  ),
                ),
                const SizedBox(width: VSpace.sm),
                Expanded(
                  child: _Stat(
                    label: isAr ? 'العضلات' : 'Muscle',
                    value:
                        muscle != null ? '${muscle.toStringAsFixed(1)} $kg' : '—',
                  ),
                ),
                const SizedBox(width: VSpace.sm),
                Expanded(
                  child: _Stat(
                    label: isAr ? 'دهون حشوية' : 'Visceral fat',
                    value: latest.visceralFatLevel != null
                        ? latest.visceralFatLevel!.toStringAsFixed(0)
                        : '—',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.yMMMd().format(latest.testDate),
              style: TextStyle(color: colors.textMute, fontSize: 12),
            ),
          ],
          const SizedBox(height: VSpace.md),
          FilledButton.icon(
            onPressed: () => InBodyScanScreen.open(context),
            icon: const Icon(Icons.camera_alt_rounded, size: 18),
            label: Text(isAr ? 'صوّر تقرير InBody' : 'Scan InBody report'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: colors.ember,
            ),
          ),
          const SizedBox(height: VSpace.sm),
          OutlinedButton.icon(
            onPressed: () => NavyTapeMeasureScreen.open(context),
            icon: const Icon(Icons.straighten_rounded, size: 18),
            label: Text(isAr ? 'قيس بالشريط' : 'Measure with tape'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
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
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.textMute,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

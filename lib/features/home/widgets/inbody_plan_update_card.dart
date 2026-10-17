import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';

const _inbodyPlanDismissedKey = 'inbody_plan_update_dismissed_id';

final inbodyPlanUpdateVisibleProvider = StateProvider<bool>((ref) {
  final inbody = ref.watch(latestBodyCompositionProvider);
  if (inbody == null) return false;
  if (inbody.source != BodyCompositionSource.inbodyScan &&
      inbody.source != BodyCompositionSource.healthConnect) {
    return false;
  }
  if (!HiveService.isInitialized) return false;
  final dismissedId = HiveService.settingsBox.get(_inbodyPlanDismissedKey) as String?;
  return dismissedId != inbody.id;
});

class InBodyPlanUpdateCard extends ConsumerWidget {
  const InBodyPlanUpdateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(inbodyPlanUpdateVisibleProvider);
    if (!visible) return const SizedBox.shrink();

    final inbody = ref.watch(latestBodyCompositionProvider);
    if (inbody == null) return const SizedBox.shrink();

    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final target = ref.watch(calorieGoalProvider);

    return Container(
      margin: const EdgeInsets.only(bottom: VSpace.md),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(VRadius.lg),
        border: Border.all(color: colors.ember.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.ember.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.ember.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome_rounded, color: colors.ember, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? 'حدّثنا خطتك بناءً على ${inbody.source == BodyCompositionSource.inbodyScan ? "InBody" : "الميزان الذكي"}'
                          : 'Plan updated based on ${inbody.source == BodyCompositionSource.inbodyScan ? "InBody" : "Smart Scale"}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isArabic
                          ? 'حساب دقيق لمعدل الأيض والبروتين بناءً على كتلتك العضلية (${target.calories} سعرة · ${target.proteinG} جم بروتين)'
                          : 'BMR & protein tuned to your lean mass (${target.calories} kcal · ${target.proteinG}g protein)',
                      style: TextStyle(color: colors.textMute, fontSize: 11.5, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                onPressed: () async {
                  // Undo: remove the report so targets revert back
                  await ref.read(bodyCompositionListProvider.notifier).remove(inbody.id);
                  ref.invalidate(calorieGoalProvider);
                  ref.read(inbodyPlanUpdateVisibleProvider.notifier).state = false;
                },
                child: Text(
                  isArabic ? 'تراجع' : 'Undo',
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.ember,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  if (HiveService.isInitialized) {
                    await HiveService.settingsBox.put(_inbodyPlanDismissedKey, inbody.id);
                  }
                  ref.read(inbodyPlanUpdateVisibleProvider.notifier).state = false;
                },
                child: Text(
                  isArabic ? 'تمام، اعتمد' : 'Got it',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

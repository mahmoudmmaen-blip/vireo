import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_snackbar.dart';
import 'package:vireo/features/ai_coach/domain/plan_action.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class PlanActionConfirmationCard extends ConsumerStatefulWidget {
  const PlanActionConfirmationCard({
    super.key,
    required this.action,
  });

  final PlanAction action;

  @override
  ConsumerState<PlanActionConfirmationCard> createState() => _PlanActionConfirmationCardState();
}

class _PlanActionConfirmationCardState extends ConsumerState<PlanActionConfirmationCard> {
  bool _applied = false;
  Map<String, dynamic>? _previousState;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final currentTarget = ref.watch(calorieGoalProvider);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _applied ? VBridge.cFF10B981 : colors.ember.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (_applied ? VBridge.cFF10B981 : colors.ember).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _applied ? Icons.check_circle_rounded : Icons.auto_awesome_rounded,
                  size: 16,
                  color: _applied ? VBridge.cFF10B981 : colors.ember,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.action.title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            widget.action.description,
            style: TextStyle(color: colors.textMute, fontSize: 12, height: 1.3),
          ),
          const SizedBox(height: 10),

          // Before -> After details
          if (widget.action.type == PlanActionType.changeTargets) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.line),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          isArabic ? 'الحالي' : 'Current',
                          style: TextStyle(color: colors.textMute, fontSize: 10.5, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${currentTarget.calories} kcal · ${currentTarget.proteinG}g P',
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.arrow_forward_rounded, size: 14, color: colors.ember),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          isArabic ? 'الهدف الجديد' : 'New Target',
                          style: TextStyle(color: colors.ember, fontSize: 10.5, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${widget.action.data["target_kcal"] ?? currentTarget.calories} kcal · ${widget.action.data["target_protein_g"] ?? currentTarget.proteinG}g P',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: colors.ember),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Action buttons: "إضافة للخطة" vs "تراجع"
          if (!_applied)
            FilledButton.icon(
              onPressed: () async {
                HapticFeedback.mediumImpact();
                final reqKcal = (widget.action.data['target_kcal'] as num?)?.toInt() ?? currentTarget.calories;
                final reqProtein = (widget.action.data['target_protein_g'] as num?)?.toInt() ?? currentTarget.proteinG;

                // Safety rails
                final (safeKcal, safeProtein) = PlanAction.clampTargets(
                  requestedKcal: reqKcal,
                  requestedProtein: reqProtein,
                  isFemale: false, // Default or check female provider
                );

                _previousState = {
                  'calories': currentTarget.calories,
                  'proteinG': currentTarget.proteinG,
                };

                // Apply targets
                await setManualTargets(
                  calories: safeKcal,
                  proteinG: safeProtein,
                );
                ref.read(dietPlanRevisionProvider.notifier).state++;

                setState(() => _applied = true);
                if (!context.mounted) return;
                VireoSnackBar.showText(
                  context,
                  isArabic ? 'تم تحديث خطتك بنجاح! 🎯' : 'Plan updated successfully! 🎯',
                );
              },
              icon: const Icon(Icons.add_task_rounded, size: 16),
              label: Text(isArabic ? 'إضافة للخطة' : 'Apply to Plan'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.ember,
                minimumSize: const Size.fromHeight(36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: VBridge.cFF10B981.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isArabic ? 'مُطبّق في الخطة ✓' : 'Applied to Plan ✓',
                      style: const TextStyle(
                        color: VBridge.cFF10B981,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () async {
                    HapticFeedback.selectionClick();
                    if (_previousState != null) {
                      await setManualTargets(
                        calories: _previousState!['calories'] as int?,
                        proteinG: _previousState!['proteinG'] as int?,
                      );
                      ref.read(dietPlanRevisionProvider.notifier).state++;
                    }
                    setState(() => _applied = false);
                    if (!context.mounted) return;
                    VireoSnackBar.showText(
                      context,
                      isArabic ? 'تم التراجع عن التعديل' : 'Reverted changes',
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(isArabic ? 'تراجع' : 'Undo'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

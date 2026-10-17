import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/estimated_kcal_label.dart';
import 'package:vireo/core/ui/vireo_icon_button.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/progress/domain/adaptive_calorie_calculator.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';
import 'package:vireo/features/subscription/feature_gates.dart';

class AdaptiveCalorieSuggestionCard extends ConsumerWidget {
  const AdaptiveCalorieSuggestionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final suggestion = ref.watch(adaptiveCalorieSuggestionProvider);

    if (!suggestion.isEligible || suggestion.appliedDeltaKcal == 0) {
      return const SizedBox.shrink();
    }

    final isIncrease = suggestion.appliedDeltaKcal > 0;
    final deltaSign = isIncrease ? '+' : '';
    final deltaColor = isIncrease ? colors.recovery : colors.success;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final kcalUnit = isAr ? 'سعرة' : 'kcal';

    return Container(
      padding: const EdgeInsets.all(VSpace.md),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(VRadius.md),
        border: Border.all(color: colors.ember.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.ember.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(VSpace.xs),
                decoration: BoxDecoration(
                  color: colors.ember.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, color: colors.ember, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.adaptiveCalorieCardTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      l10n.adaptiveCalorieBasedOnResponse,
                      style: TextStyle(color: colors.textMute, fontSize: 11),
                    ),
                  ],
                ),
              ),
              VireoIconButton(
                icon: Icons.info_outline,
                tooltip: l10n.adaptiveCalorieExplainMath,
                color: colors.textMute,
                iconSize: 20,
                onPressed: () => _showMathExplanation(context, suggestion),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.adaptiveCalorieCurrentTarget,
                    style: TextStyle(color: colors.textMute, fontSize: 11),
                  ),
                  Text(
                    '${formatCount(suggestion.currentCalorieTarget)} $kcalUnit',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward, color: colors.ember, size: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.adaptiveCalorieSuggestedTarget,
                    style: TextStyle(color: colors.textMute, fontSize: 11),
                  ),
                  Text(
                    '${formatCount(suggestion.suggestedCalorieTarget)} $kcalUnit',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: colors.ember,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: deltaColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(VRadius.sm),
                ),
                child: Text(
                  l10n.adaptiveCalorieDeltaPerDay(
                    deltaSign,
                    suggestion.appliedDeltaKcal.abs(),
                  ),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: deltaColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: VSpace.sm),
          Text(
            l10n.adaptiveCalorieMaintenanceLine(
              suggestion.estimatedMaintenanceKcal ?? 0,
              suggestion.daysCount,
            ),
            style: TextStyle(color: colors.textMute, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(adaptiveCalorieActionProvider.notifier).dismiss(
                          suggestion.suggestedCalorieTarget,
                        );
                  },
                  child: Text(l10n.adaptiveCalorieDismiss),
                ),
              ),
              const SizedBox(width: VSpace.sm),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.ember,
                    foregroundColor: colors.text,
                    minimumSize: const Size(48, 48),
                  ),
                  onPressed: () async {
                    if (!FeatureGates.requirePro(context, ref, force: true)) {
                      return;
                    }
                    await ref
                        .read(adaptiveCalorieActionProvider.notifier)
                        .acceptSuggestion(suggestion.suggestedCalorieTarget, ref);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 3),
                          content: Text(
                            l10n.adaptiveCalorieUpdatedSnack(
                              suggestion.suggestedCalorieTarget,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(l10n.adaptiveCalorieAccept),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMathExplanation(BuildContext context, AdaptiveCalorieSuggestion s) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surfaceRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(VRadius.lg)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(VSpace.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.adaptiveCalorieExplainMath,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  VireoIconButton(
                    icon: Icons.close,
                    tooltip: MaterialLocalizations.of(ctx).closeButtonTooltip,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: VSpace.sm),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(VRadius.sm),
                  border: Border.all(color: colors.line),
                ),
                child: Text(
                  l10n.adaptiveCalorieMathFormula,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.ember,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _MathRow(label: l10n.adaptiveCalorieWindowSpan, value: '${s.daysCount}'),
              _MathRow(label: l10n.adaptiveCalorieFoodLogsCount, value: '${s.foodLogsCount}'),
              _MathRow(label: l10n.adaptiveCalorieWeighInsCount, value: '${s.weighInsCount}'),
              _MathRow(
                label: l10n.adaptiveCalorieAverageIntake,
                value:
                    '${formatCount(s.averageIntakeKcal ?? 0)} ${Localizations.localeOf(context).languageCode.startsWith('ar') ? 'سعرة' : 'kcal'}',
              ),
              _MathRow(
                label: l10n.adaptiveCalorieTrendWeightChange,
                value:
                    '${(s.trendWeightChangeKg ?? 0) >= 0 ? '+' : ''}${s.trendWeightChangeKg}',
              ),
              _MathRow(
                label: l10n.adaptiveCalorieEstimatedMaintenance,
                value:
                    '${formatCount(s.estimatedMaintenanceKcal ?? 0)} ${Localizations.localeOf(context).languageCode.startsWith('ar') ? 'سعرة' : 'kcal'}',
              ),
              _MathRow(
                label: l10n.adaptiveCalorieWeeklyChangeCap,
                value:
                    '±150 (${s.cappedDeltaKcal >= 0 ? '+' : ''}${s.cappedDeltaKcal})',
              ),
              _MathRow(
                label: l10n.adaptiveCalorieSafetyFloorApplied,
                value: s.floorApplied ? l10n.adaptiveCalorieFloorYes : l10n.adaptiveCalorieFloorNo,
              ),
              const SizedBox(height: VSpace.md),
            ],
          ),
        );
      },
    );
  }
}

class _MathRow extends StatelessWidget {
  const _MathRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: context.vireoColors.textMute, fontSize: 13),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

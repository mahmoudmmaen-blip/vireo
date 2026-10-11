import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/progress/domain/adaptive_calorie_calculator.dart';
import 'package:vireo/features/progress/providers/progress_extended_provider.dart';

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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.all(8),
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
                      'Based on your real metabolic response',
                      style: TextStyle(color: colors.textMute, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, size: 20),
                color: colors.textMute,
                tooltip: l10n.adaptiveCalorieExplainMath,
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
                  Text('Current Target', style: TextStyle(color: colors.textMute, fontSize: 11)),
                  Text(
                    '${suggestion.currentCalorieTarget} kcal',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward, color: colors.ember, size: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Suggested Target', style: TextStyle(color: colors.textMute, fontSize: 11)),
                  Text(
                    '${suggestion.suggestedCalorieTarget} kcal',
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
                  color: (isIncrease ? const Color(0xFF3B82F6) : const Color(0xFF10B981))
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$deltaSign${suggestion.appliedDeltaKcal} kcal/d',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isIncrease ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Estimated real maintenance: ${suggestion.estimatedMaintenanceKcal} kcal/day '
            'from ${suggestion.daysCount} days tracking.',
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
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.ember,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await ref
                        .read(adaptiveCalorieActionProvider.notifier)
                        .acceptSuggestion(suggestion.suggestedCalorieTarget, ref);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 3),
                          content: Text(
                            'Calorie target updated to ${suggestion.suggestedCalorieTarget} kcal!',
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.adaptiveCalorieExplainMath,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.line),
                ),
                child: Text(
                  'Maintenance = Avg Intake − (Weight Change kg × 7700 ÷ Days)',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: colors.ember,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _MathRow(label: 'Window span', value: '${s.daysCount} days'),
              _MathRow(label: 'Food logs count', value: '${s.foodLogsCount} days'),
              _MathRow(label: 'Weigh-ins count', value: '${s.weighInsCount} times'),
              _MathRow(label: 'Average intake', value: '${s.averageIntakeKcal} kcal/day'),
              _MathRow(
                label: 'Trend weight change',
                value: '${(s.trendWeightChangeKg ?? 0) >= 0 ? '+' : ''}${s.trendWeightChangeKg} kg',
              ),
              _MathRow(
                label: 'Estimated maintenance',
                value: '${s.estimatedMaintenanceKcal} kcal/day',
              ),
              _MathRow(
                label: 'Weekly change cap',
                value: '±150 kcal/week (${s.cappedDeltaKcal >= 0 ? '+' : ''}${s.cappedDeltaKcal} kcal)',
              ),
              _MathRow(
                label: 'Safety floor applied',
                value: s.floorApplied ? 'Yes (minimum 1500 kcal)' : 'No (>1500 kcal)',
              ),
              const SizedBox(height: 16),
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
          Text(label, style: TextStyle(color: context.vireoColors.textMute, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

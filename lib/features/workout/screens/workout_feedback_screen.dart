import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/services/celebration_service.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/workout_session.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';

class WorkoutFeedbackScreen extends ConsumerStatefulWidget {
  const WorkoutFeedbackScreen({super.key});

  @override
  ConsumerState<WorkoutFeedbackScreen> createState() =>
      _WorkoutFeedbackScreenState();
}

class _WorkoutFeedbackScreenState extends ConsumerState<WorkoutFeedbackScreen> {
  bool _submitting = false;

  Future<void> _submit(WorkoutDifficultyFeedback feedback) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      await ref.read(workoutRepositoryProvider).saveWorkoutFeedback(
            sessionId: ref.read(workoutFlowProvider)!.session.id,
            feedback: feedback,
          );
      ref.read(workoutFlowProvider.notifier).completeWorkout();
      await ref.read(vitalityDailyLogProvider.notifier).markWorkoutCompleted();
      await StepCounterService.markWorkoutCompleted();
      if (mounted) {
        final isFemale = ref.read(isFemaleUserProvider);
        final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
        await CelebrationService.trigger(
          context,
          type: CelebrationType.workout,
          message: isFemale && isAr
              ? 'عاش يا بطلة! خلّصتِ تمرينك النهاردة بنجاح 🔥'
              : AppLocalizations.of(context).celebrationWorkoutTitle,
        );
      }
      final isPro = ref.read(isProUserProvider);
      ref.read(workoutFlowProvider.notifier).clearSession();
      if (mounted) Navigator.of(context).pop();
      await AdService.instance.showInterstitialIfEligible(isPro: isPro);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(duration: const Duration(seconds: 3), persist: false, content: Text(AppLocalizations.of(context).authErrorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final flow = ref.watch(workoutFlowProvider);
    final lang = Localizations.localeOf(context).languageCode;

    // Calculate completed sets and estimated metrics
    int totalSets = 0;
    if (flow != null) {
      for (final setsList in flow.completedSets.values) {
        totalSets += setsList.where((d) => d).length;
      }
    }
    if (totalSets == 0 && flow != null) {
      totalSets = flow.exercises.fold<int>(0, (sum, e) => sum + e.sets);
    }
    final estMinutes = (totalSets * 2.5).round().clamp(15, 90);
    final estKcal = (totalSets * 18).round().clamp(100, 650);
    final estFatG = (estKcal * 0.08).toStringAsFixed(1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Text(
            l10n.workoutFeedbackTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Workout summary stats card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.ember.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  lang == 'ar' ? 'ملخص جلسة اليوم 🔥' : 'Today\'s Session Summary 🔥',
                  style: TextStyle(
                    color: colors.ember,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryMetric(
                      title: lang == 'ar' ? 'المدة' : 'Duration',
                      value: '$estMinutes ${lang == 'ar' ? 'د' : 'min'}',
                      colors: colors,
                    ),
                    _SummaryMetric(
                      title: lang == 'ar' ? 'المجموعات' : 'Sets',
                      value: '$totalSets',
                      colors: colors,
                    ),
                    _SummaryMetric(
                      title: lang == 'ar' ? 'السعرات' : 'Calories',
                      value: '~$estKcal ${lang == 'ar' ? 'ك.س' : 'kcal'}',
                      colors: colors,
                    ),
                    _SummaryMetric(
                      title: lang == 'ar' ? 'دهون' : 'Fat',
                      value: '~$estFatG ${lang == 'ar' ? 'جم' : 'g'}',
                      colors: colors,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _FeedbackButton(
            label: l10n.workoutFeedbackEasy,
            color: colors.success,
            enabled: !_submitting,
            onTap: () => _submit(WorkoutDifficultyFeedback.easy),
          ),
          const SizedBox(height: 12),
          _FeedbackButton(
            label: l10n.workoutFeedbackJustRight,
            color: colors.ember,
            enabled: !_submitting,
            onTap: () => _submit(WorkoutDifficultyFeedback.justRight),
          ),
          const SizedBox(height: 12),
          _FeedbackButton(
            label: l10n.workoutFeedbackHard,
            color: colors.danger,
            enabled: !_submitting,
            onTap: () => _submit(WorkoutDifficultyFeedback.hard),
          ),
          if (_submitting) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
    required this.label,
    required this.color,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: color),
        foregroundColor: color,
      ),
      onPressed: enabled ? onTap : null,
      child: Text(label),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.title,
    required this.value,
    required this.colors,
  });

  final String title;
  final String value;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: colors.textMute, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

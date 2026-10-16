import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/services/celebration_service.dart';
import 'package:vireo/core/services/user_sex_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/repositories/workout_repository.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/vitality/providers/vitality_provider.dart';
import 'package:vireo/features/walking/data/step_counter_service.dart';
import 'package:vireo/features/workout/domain/workout_rpe.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';

/// Post-workout check-in: RPE 1–10, feelings, optional note, then a short
/// smart comment.
///
/// This screen owns its own [Scaffold] (theme background, close button,
/// title) so it can never render as a blank/black page, and it is scroll-safe
/// (no `Spacer` inside a scroll view) and null-safe when no flow is active.
class WorkoutFeedbackScreen extends ConsumerStatefulWidget {
  const WorkoutFeedbackScreen({super.key});

  @override
  ConsumerState<WorkoutFeedbackScreen> createState() =>
      _WorkoutFeedbackScreenState();
}

class _WorkoutFeedbackScreenState extends ConsumerState<WorkoutFeedbackScreen> {
  final TextEditingController _noteController = TextEditingController();
  final Set<WorkoutFeeling> _feelings = <WorkoutFeeling>{};

  int? _rpe;
  int? _previousRpe;
  bool _submitting = false;
  bool _completionMarked = false;
  WorkoutRpeInsight? _insight;

  @override
  void initState() {
    super.initState();
    _previousRpe = WorkoutRpe.lastRpe();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _saved => _insight != null;

  double _completionFraction() {
    final flow = ref.read(workoutFlowProvider);
    if (flow == null) return 1.0;
    var planned = 0;
    var done = 0;
    for (final entry in flow.completedSets.entries) {
      planned += entry.value.length;
      done += entry.value.where((d) => d).length;
    }
    if (planned == 0) return 1.0;
    return done / planned;
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        persist: false,
        content: Text(AppLocalizations.of(context).authErrorGeneric),
      ),
    );
  }

  /// Marks today's workout done in Vitality / steps once.
  Future<void> _markWorkoutCompleted() async {
    if (_completionMarked) return;
    _completionMarked = true;
    // Bounded: a slow sync queue must never leave the user stuck on this page.
    const limit = Duration(seconds: 3);
    try {
      await ref
          .read(vitalityDailyLogProvider.notifier)
          .markWorkoutCompleted()
          .timeout(limit);
    } catch (_) {}
    try {
      await StepCounterService.markWorkoutCompleted().timeout(limit);
    } catch (_) {}
  }

  Future<void> _save() async {
    final rpe = _rpe;
    if (rpe == null || _submitting) return;
    setState(() => _submitting = true);
    try {
      final sessionId = ref.read(workoutFlowProvider)?.session.id;
      final note = _noteController.text.trim();

      await WorkoutRpe.persist(
        rpe: rpe,
        feelings: _feelings,
        note: note,
        sessionId: sessionId,
      );
      if (sessionId != null) {
        await ref.read(workoutRepositoryProvider).saveWorkoutFeedback(
              sessionId: sessionId,
              feedback: WorkoutRpe.toDifficulty(rpe),
            ).timeout(const Duration(seconds: 10));
      }
      await _markWorkoutCompleted();

      final insight = WorkoutRpe.insightFor(
        rpe: rpe,
        feelings: _feelings,
        completion: _completionFraction(),
        previousRpe: _previousRpe,
      );
      if (mounted) setState(() => _insight = insight);
    } catch (_) {
      _showError();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Closes the flow: celebrates (if enabled), pops and clears the session.
  Future<void> _finish() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    // Capture everything we need before the widget is removed from the tree.
    final notifier = ref.read(workoutFlowProvider.notifier);
    final navigator = Navigator.of(context);
    final isPro = ref.read(isProUserProvider);
    final isFemale = ref.read(isFemaleUserProvider);
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    try {
      await _markWorkoutCompleted();
      if (mounted) {
        await CelebrationService.trigger(
          context,
          type: CelebrationType.workout,
          message: isFemale && isAr
              ? 'عاش يا بطلة! خلّصتِ تمرينك النهاردة بنجاح 🔥'
              : l10n.celebrationWorkoutTitle,
        );
      }
    } catch (_) {
      // Celebration is cosmetic — never block leaving the screen.
    }
    navigator.pop();
    notifier.completeWorkout();
    notifier.clearSession();
    try {
      await AdService.instance.showInterstitialIfEligible(isPro: isPro);
    } catch (_) {}
  }

  void _toggleFeeling(WorkoutFeeling feeling, bool selected) {
    setState(() {
      if (selected) {
        _feelings.add(feeling);
      } else {
        _feelings.remove(feeling);
      }
    });
  }

  String _insightText(AppLocalizations l10n, WorkoutRpeInsight insight) {
    return switch (insight) {
      WorkoutRpeInsight.joint => l10n.workoutRpeCommentJoint,
      WorkoutRpeInsight.hard => l10n.workoutRpeCommentHard,
      WorkoutRpeInsight.better => l10n.workoutRpeCommentBetter,
      WorkoutRpeInsight.easy => l10n.workoutRpeCommentEasy,
      WorkoutRpeInsight.partial => l10n.workoutRpeCommentPartial,
      WorkoutRpeInsight.steady => l10n.workoutRpeCommentSteady,
    };
  }

  String _feelingLabel(
    AppLocalizations l10n,
    WorkoutFeeling feeling,
    String gender,
  ) {
    return switch (feeling) {
      WorkoutFeeling.tired => l10n.workoutFeelTired,
      WorkoutFeeling.jointPain => l10n.workoutFeelJointPain,
      WorkoutFeeling.happy => l10n.workoutFeelHappy(gender),
      WorkoutFeeling.energized => l10n.workoutFeelEnergized,
    };
  }

  Color _rpeColor(VireoColors colors, int value) {
    if (value <= 3) return colors.success;
    if (value <= 7) return colors.ember;
    return colors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final textTheme = Theme.of(context).textTheme;
    final isFemale = ref.watch(isFemaleUserProvider);
    final gender = isFemale ? 'female' : 'male';
    final rpe = _rpe;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish();
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          foregroundColor: colors.text,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: _submitting ? null : _finish,
          ),
          title: Text(
            l10n.workoutFeedbackTitle,
            style: textTheme.titleLarge?.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SessionSummary(colors: colors),
                const SizedBox(height: 20),
                if (_saved)
                  _SavedCard(
                    colors: colors,
                    title: l10n.workoutRpeSavedTitle,
                    comment: _insightText(l10n, _insight!),
                  )
                else ...[
                  Text(
                    l10n.workoutRpeSubtitle,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.textMute,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = WorkoutRpe.min; i <= WorkoutRpe.max; i++)
                        _RpeBubble(
                          value: i,
                          color: _rpeColor(colors, i),
                          selected: rpe == i,
                          enabled: !_submitting,
                          semanticLabel: '$i ${l10n.workoutRpeLabel('$i')}',
                          onTap: () => setState(() => _rpe = i),
                          colors: colors,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 28,
                    child: Center(
                      child: Text(
                        rpe == null ? '' : l10n.workoutRpeLabel('$rpe'),
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: rpe == null
                              ? colors.textMute
                              : _rpeColor(colors, rpe),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.workoutRpeFeelingsTitle,
                    style: textTheme.titleSmall?.copyWith(
                      color: colors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final feeling in WorkoutFeeling.values)
                        FilterChip(
                          label: Text(_feelingLabel(l10n, feeling, gender)),
                          selected: _feelings.contains(feeling),
                          showCheckmark: true,
                          selectedColor: colors.ember.withValues(alpha: 0.22),
                          backgroundColor: colors.surfaceRaised,
                          side: BorderSide(
                            color: _feelings.contains(feeling)
                                ? colors.ember
                                : colors.line,
                          ),
                          labelStyle: TextStyle(color: colors.text),
                          onSelected: _submitting
                              ? null
                              : (v) => _toggleFeeling(feeling, v),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _noteController,
                    enabled: !_submitting,
                    minLines: 2,
                    maxLines: 3,
                    maxLength: 280,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(color: colors.text),
                    decoration: InputDecoration(
                      hintText: l10n.workoutRpeNoteHint,
                      hintStyle: TextStyle(color: colors.textMute),
                      filled: true,
                      fillColor: colors.surfaceRaised,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: colors.line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: colors.line),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.ember,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          colors.line.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submitting
                        ? null
                        : _saved
                            ? _finish
                            : (rpe == null ? null : _save),
                    child: _submitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text(
                            _saved ? l10n.workoutRpeDone : l10n.workoutRpeSave,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One tappable 1–10 bubble (48 dp).
class _RpeBubble extends StatelessWidget {
  const _RpeBubble({
    required this.value,
    required this.color,
    required this.selected,
    required this.enabled,
    required this.semanticLabel,
    required this.onTap,
    required this.colors,
  });

  final int value;
  final Color color;
  final bool selected;
  final bool enabled;
  final String semanticLabel;
  final VoidCallback onTap;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: Material(
        color: selected ? color : colors.surfaceRaised,
        shape: CircleBorder(
          side: BorderSide(color: selected ? color : colors.line, width: 1.5),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : colors.text,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({
    required this.colors,
    required this.title,
    required this.comment,
  });

  final VireoColors colors;
  final String title;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.success.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.success,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.text, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// Compact summary of the finished session. Hidden when no flow is active.
class _SessionSummary extends ConsumerWidget {
  const _SessionSummary({required this.colors});

  final VireoColors colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(workoutFlowProvider);
    if (flow == null) return const SizedBox.shrink();
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    var totalSets = 0;
    for (final setsList in flow.completedSets.values) {
      totalSets += setsList.where((d) => d).length;
    }
    if (totalSets == 0) {
      totalSets = flow.exercises.fold<int>(0, (sum, e) => sum + e.sets);
    }
    final estMinutes = (totalSets * 2.5).round().clamp(15, 90);
    final estKcal = (totalSets * 18).round().clamp(100, 650);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.ember.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryMetric(
            title: isAr ? 'المدة' : 'Duration',
            value: '$estMinutes ${isAr ? 'د' : 'min'}',
            colors: colors,
          ),
          _SummaryMetric(
            title: isAr ? 'المجموعات' : 'Sets',
            value: '$totalSets',
            colors: colors,
          ),
          _SummaryMetric(
            title: isAr ? 'السعرات' : 'Calories',
            value: '~$estKcal',
            colors: colors,
          ),
        ],
      ),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: TextStyle(color: colors.textMute, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

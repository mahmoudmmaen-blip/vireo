import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/widgets/animated_backgrounds.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/services/rest_alert_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/workout/data/exercise_detail_catalog.dart';
import 'package:vireo/features/workout/domain/exercise_detail.dart';
import 'package:vireo/features/workout/domain/exercise_media.dart';
import 'package:vireo/features/workout/providers/exercise_detail_provider.dart';
import 'package:vireo/features/workout/widgets/exercise_media_player.dart';
import 'package:vireo/features/workout/widgets/muscle_label_helper.dart';
import 'package:vireo/features/workout/widgets/muscle_map.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.heroTag,
    this.initialSets,
    this.initialReps,
    this.initialRestSeconds,
    this.onCompleteSet,
    this.completedSets = 0,
    this.targetSets,
  });

  final String exerciseId;
  final String? heroTag;
  final int? initialSets;
  final int? initialReps;
  final int? initialRestSeconds;
  final VoidCallback? onCompleteSet;
  final int completedSets;
  final int? targetSets;

  @override
  ConsumerState<ExerciseDetailScreen> createState() =>
      _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  int _currentSet = 1;
  int _targetSets = 3;
  int _targetReps = 10;
  int _restSeconds = 60;
  int _restRemaining = 0;
  Timer? _restTimer;
  bool _restRunning = false;
  bool _hydrated = false;
  bool _mediaLoading = true;

  @override
  void initState() {
    super.initState();
    _currentSet = widget.completedSets + 1;
    if (widget.initialSets != null) _targetSets = widget.initialSets!;
    if (widget.initialReps != null) _targetReps = widget.initialReps!;
    if (widget.initialRestSeconds != null) {
      _restSeconds = widget.initialRestSeconds!;
    }
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  void _hydrateFromDetail(ExerciseDetail detail) {
    if (_hydrated) return;
    _hydrated = true;
    _targetSets = widget.targetSets ?? widget.initialSets ?? detail.targetSets;
    _targetReps = widget.initialReps ?? detail.targetReps;
    _restSeconds = widget.initialRestSeconds ?? detail.restSeconds;
  }

  void _adjustSets(int delta) {
    setState(() {
      _targetSets = (_targetSets + delta).clamp(1, 10);
    });
  }

  void _adjustReps(int delta) {
    setState(() {
      _targetReps = (_targetReps + delta).clamp(1, 50);
    });
  }

  void _selectRestPreset(int seconds) {
    _restTimer?.cancel();
    setState(() {
      _restSeconds = seconds;
      _restRemaining = seconds;
      _restRunning = false;
    });
  }

  void _toggleRestTimer() {
    if (_restRunning) {
      _restTimer?.cancel();
      setState(() => _restRunning = false);
      return;
    }

    setState(() {
      _restRemaining = _restSeconds;
      _restRunning = true;
    });
    RestAlertService.resetAlerts();

    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_restRemaining <= 0) {
        timer.cancel();
        RestAlertService.onTick(0);
        setState(() => _restRunning = false);
        return;
      }
      RestAlertService.onTick(_restRemaining);
      setState(() => _restRemaining -= 1);
    });
  }

  void _completeSet() {
    widget.onCompleteSet?.call();
    if (_currentSet < _targetSets) {
      setState(() => _currentSet += 1);
    }
    _toggleRestTimer();
  }

  @override
  Widget build(BuildContext context) {
    final asyncDetail = ref.watch(exerciseDetailProvider(widget.exerciseId));
    final locale = ref.watch(localeProvider).languageCode;
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: FloatingParticleBackground(
        child: asyncDetail.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: colors.ember),
        ),
        error: (error, stackTrace) => Center(child: Text(l10n.authErrorGeneric)),
        data: (detail) {
          if (!_hydrated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_hydrated) {
                setState(() => _hydrateFromDetail(detail));
              }
            });
          }

          final heroTag = widget.heroTag ?? 'exercise_media_${detail.id}';
          final displayName =
              locale == 'ar' ? detail.nameAr : detail.name;

          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          ExerciseMediaPlayer(
                            detail: detail,
                            heroTag: heroTag,
                            onLoadingChanged: (loading) {
                              if (_mediaLoading != loading) {
                                setState(() => _mediaLoading = loading);
                              }
                            },
                          ),
                          if (_mediaLoading)
                            Positioned(
                              top: MediaQuery.sizeOf(context).height * 0.32,
                              left: 16,
                              right: 16,
                              child: Material(
                                color: colors.surface.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: colors.ember,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(l10n.exerciseLoadingDemo),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          SafeArea(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _GlassInfoCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  _DifficultyChip(difficulty: detail.difficulty),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      for (final m in detail.muscleGroups)
                                        _MuscleChip(
                                          label: localizedMuscleLabel(l10n, m),
                                          color: colors.danger,
                                        ),
                                      for (final m in detail.secondaryMuscles)
                                        _MuscleChip(
                                          label: localizedMuscleLabel(l10n, m),
                                          color: colors.ember,
                                        ),
                                    ],
                                  ),
                                  if (detail.equipment.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.exerciseEquipment,
                                      style: TextStyle(
                                        color: colors.textMute,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(detail.equipment.join(' · ')),
                                  ],
                                  const SizedBox(height: 16),
                                  MuscleMap(
                                    primaryMuscles: detail.muscleGroups,
                                    secondaryMuscles: detail.secondaryMuscles,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _InstructionAccordion(
                              title: l10n.exerciseSteps,
                              icon: Icons.check_circle_outline,
                              iconColor: colors.success,
                              items: detail.instructions,
                              numbered: true,
                            ),
                            const SizedBox(height: 12),
                            _InstructionAccordion(
                              title: l10n.exerciseMistakes,
                              icon: Icons.warning_amber_rounded,
                              iconColor: colors.danger,
                              items: detail.commonMistakes,
                            ),
                            const SizedBox(height: 12),
                            _InstructionAccordion(
                              title: l10n.exerciseTips,
                              icon: Icons.lightbulb_outline,
                              iconColor: colors.gold,
                              items: detail.tips,
                            ),
                            const SizedBox(height: 12),
                            _SingleGuideCard(
                              title: l10n.exerciseBreathingCue,
                              content: ExerciseDetailCatalog.breathingCueFor(detail.id, detail.name, locale),
                              icon: Icons.air_rounded,
                              iconColor: colors.ember,
                            ),
                            const SizedBox(height: 12),
                            _SingleGuideCard(
                              title: l10n.exerciseEasierVariation,
                              content: ExerciseDetailCatalog.easierVariationFor(detail.id, detail.name, locale),
                              icon: Icons.trending_down_rounded,
                              iconColor: colors.success,
                            ),
                            const SizedBox(height: 12),
                            _SingleGuideCard(
                              title: l10n.exerciseHarderVariation,
                              content: ExerciseDetailCatalog.harderVariationFor(detail.id, detail.name, locale),
                              icon: Icons.trending_up_rounded,
                              iconColor: colors.ember,
                            ),
                            const SizedBox(height: 12),
                            _SingleGuideCard(
                              title: l10n.exerciseSafetyNote,
                              content: ExerciseDetailCatalog.safetyNoteFor(detail.id, detail.name, locale),
                              icon: Icons.shield_outlined,
                              iconColor: colors.danger,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _WorkoutActionBar(
                currentSet: _currentSet,
                targetSets: _targetSets,
                targetReps: _targetReps,
                restSeconds: _restSeconds,
                restRemaining: _restRemaining,
                restRunning: _restRunning,
                onDecreaseSets: () => _adjustSets(-1),
                onIncreaseSets: () => _adjustSets(1),
                onDecreaseReps: () => _adjustReps(-1),
                onIncreaseReps: () => _adjustReps(1),
                onRestPreset: _selectRestPreset,
                onToggleRest: _toggleRestTimer,
                onCompleteSet: _completeSet,
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

class _GlassInfoCard extends StatelessWidget {
  const _GlassInfoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.line.withValues(alpha: 0.6)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.difficulty});

  final ExerciseDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    final (label, color) = switch (difficulty) {
      ExerciseDifficulty.beginner => (l10n.exerciseBeginner, colors.success),
      ExerciseDifficulty.intermediate =>
        (l10n.exerciseIntermediate, colors.ember),
      ExerciseDifficulty.advanced => (l10n.exerciseAdvanced, colors.danger),
    };

    return Chip(
      label: Text('${l10n.exerciseDifficulty}: $label'),
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide(color: color.withValues(alpha: 0.5)),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  const _MuscleChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      labelStyle: TextStyle(color: color),
    );
  }
}

class _InstructionAccordion extends StatelessWidget {
  const _InstructionAccordion({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    this.numbered = false,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final List<String> items;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    if (items.isEmpty) return const SizedBox.shrink();

    return Card(
      color: colors.surfaceRaised,
      child: ExpansionTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: items
            .asMap()
            .entries
            .map(
              (entry) => ListTile(
                leading: numbered
                    ? CircleAvatar(
                        radius: 14,
                        backgroundColor: iconColor.withValues(alpha: 0.15),
                        child: Text(
                          '${entry.key + 1}',
                          style: TextStyle(
                            color: iconColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Icon(icon, color: iconColor, size: 20),
                title: Text(entry.value),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SingleGuideCard extends StatelessWidget {
  const _SingleGuideCard({
    required this.title,
    required this.content,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) return const SizedBox.shrink();
    final colors = context.vireoColors;

    return Card(
      color: colors.surfaceRaised,
      child: ExpansionTile(
        initiallyExpanded: false,
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutActionBar extends StatelessWidget {
  const _WorkoutActionBar({
    required this.currentSet,
    required this.targetSets,
    required this.targetReps,
    required this.restSeconds,
    required this.restRemaining,
    required this.restRunning,
    required this.onDecreaseSets,
    required this.onIncreaseSets,
    required this.onDecreaseReps,
    required this.onIncreaseReps,
    required this.onRestPreset,
    required this.onToggleRest,
    required this.onCompleteSet,
  });

  final int currentSet;
  final int targetSets;
  final int targetReps;
  final int restSeconds;
  final int restRemaining;
  final bool restRunning;
  final VoidCallback onDecreaseSets;
  final VoidCallback onIncreaseSets;
  final VoidCallback onDecreaseReps;
  final VoidCallback onIncreaseReps;
  final ValueChanged<int> onRestPreset;
  final VoidCallback onToggleRest;
  final VoidCallback onCompleteSet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final progress = restSeconds == 0
        ? 0.0
        : (restRunning ? restRemaining : restSeconds) / restSeconds;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.line)),
        boxShadow: [
          BoxShadow(
            color: colors.background.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _CounterTile(
                    label: l10n.exerciseSets,
                    value: '$currentSet/$targetSets',
                    onDecrease: onDecreaseSets,
                    onIncrease: onIncreaseSets,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _CounterTile(
                    label: l10n.exerciseReps,
                    value: '$targetReps',
                    onDecrease: onDecreaseReps,
                    onIncrease: onIncreaseReps,
                  ),
                ),
                const SizedBox(width: 8),
                _RestTimerRing(
                  label: l10n.exerciseRest,
                  progress: progress,
                  display: restRunning
                      ? '${restRemaining}s'
                      : '${restSeconds}s',
                  running: restRunning,
                  onTap: onToggleRest,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final seconds in [30, 60, 90])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('${seconds}s'),
                      selected: restSeconds == seconds,
                      onSelected: (_) => onRestPreset(seconds),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.success,
                  foregroundColor: colors.background,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: onCompleteSet,
                child: Text(
                  l10n.exerciseComplete,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterTile extends StatelessWidget {
  const _CounterTile({
    required this.label,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String label;
  final String value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: colors.textMute, fontSize: 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onDecrease,
                icon: const Icon(Icons.remove),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onIncrease,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RestTimerRing extends StatelessWidget {
  const _RestTimerRing({
    required this.label,
    required this.progress,
    required this.display,
    required this.running,
    required this.onTap,
  });

  final String label;
  final double progress;
  final String display;
  final bool running;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        height: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: running ? progress.clamp(0.0, 1.0) : 1.0,
              strokeWidth: 4,
              color: colors.ember,
              backgroundColor: colors.line,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(color: colors.textMute, fontSize: 10),
                ),
                Text(
                  display,
                  style: TextStyle(
                    color: colors.ember,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

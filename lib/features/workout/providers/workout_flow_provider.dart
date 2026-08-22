import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/rest_alert_service.dart';
import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/data/models/workout_session.dart';

class WorkoutFlowState {
  const WorkoutFlowState({
    required this.phase,
    required this.session,
    required this.exercises,
    this.exerciseIndex = 0,
    this.completedSets = const {},
    this.isPaused = false,
    this.isRestActive = false,
    this.restSecondsRemaining = 0,
  });

  final WorkoutFlowPhase phase;
  final WorkoutSession session;
  final List<Exercise> exercises;
  final int exerciseIndex;
  final Map<int, List<bool>> completedSets;
  final bool isPaused;
  final bool isRestActive;
  final int restSecondsRemaining;

  Exercise? get currentExercise {
    if (exerciseIndex < 0 || exerciseIndex >= exercises.length) return null;
    return exercises[exerciseIndex];
  }

  List<bool> setsForCurrentExercise() =>
      completedSets[exerciseIndex] ?? const [];

  bool get isFirstExercise => exerciseIndex <= 0;
  bool get isLastExercise => exerciseIndex >= exercises.length - 1;

  bool get allSetsCompleteOnCurrent {
    final sets = setsForCurrentExercise();
    return sets.isNotEmpty && sets.every((done) => done);
  }

  WorkoutFlowState copyWith({
    WorkoutFlowPhase? phase,
    WorkoutSession? session,
    List<Exercise>? exercises,
    int? exerciseIndex,
    Map<int, List<bool>>? completedSets,
    bool? isPaused,
    bool? isRestActive,
    int? restSecondsRemaining,
  }) {
    return WorkoutFlowState(
      phase: phase ?? this.phase,
      session: session ?? this.session,
      exercises: exercises ?? this.exercises,
      exerciseIndex: exerciseIndex ?? this.exerciseIndex,
      completedSets: completedSets ?? this.completedSets,
      isPaused: isPaused ?? this.isPaused,
      isRestActive: isRestActive ?? this.isRestActive,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
    );
  }
}

class WorkoutFlowNotifier extends Notifier<WorkoutFlowState?> {
  Timer? _restTimer;
  void Function()? _restOnComplete;

  @override
  WorkoutFlowState? build() {
    ref.onDispose(_cancelRestTimer);
    return null;
  }

  void startSession(WorkoutSession session) {
    _cancelRestTimer();
    final exercises = List<Exercise>.from(session.exercises);
    final completedSets = <int, List<bool>>{
      for (var i = 0; i < exercises.length; i++)
        i: List.filled(exercises[i].sets, false),
    };

    state = WorkoutFlowState(
      phase: WorkoutFlowPhase.warmUp,
      session: session,
      exercises: exercises,
      completedSets: completedSets,
    );
  }

  void beginActivePhase() {
    if (state == null) return;
    if (state!.exercises.isEmpty) {
      state = state!.copyWith(phase: WorkoutFlowPhase.coolDown);
      return;
    }
    state = state!.copyWith(
      phase: WorkoutFlowPhase.active,
      exerciseIndex: 0,
      isPaused: false,
    );
  }

  void beginCoolDownPhase() {
    if (state == null) return;
    _cancelRestTimer();
    state = state!.copyWith(
      phase: WorkoutFlowPhase.coolDown,
      isRestActive: false,
      isPaused: false,
    );
  }

  void beginFeedbackPhase() {
    if (state == null) return;
    state = state!.copyWith(phase: WorkoutFlowPhase.feedback);
  }

  void completeWorkout() {
    _cancelRestTimer();
    state = state?.copyWith(phase: WorkoutFlowPhase.complete);
  }

  void clearSession() {
    _cancelRestTimer();
    state = null;
  }

  void togglePause(bool paused) {
    if (state == null) return;
    state = state!.copyWith(isPaused: paused);
  }

  void previousExercise() {
    if (state == null || state!.isFirstExercise) return;
    _cancelRestTimer();
    state = state!.copyWith(
      exerciseIndex: state!.exerciseIndex - 1,
      isRestActive: false,
    );
  }

  void nextExercise() {
    if (state == null) return;
    if (state!.isLastExercise) {
      beginCoolDownPhase();
      return;
    }
    _cancelRestTimer();
    state = state!.copyWith(
      exerciseIndex: state!.exerciseIndex + 1,
      isRestActive: false,
    );
  }

  void restartWorkout() {
    if (state == null) return;
    startSession(state!.session);
  }

  void swapExercise(Exercise replacement) {
    if (state == null) return;
    final index = state!.exerciseIndex;
    final exercises = List<Exercise>.from(state!.exercises);
    exercises[index] = replacement;

    final completedSets = Map<int, List<bool>>.from(state!.completedSets);
    completedSets[index] = List.filled(replacement.sets, false);

    _cancelRestTimer();
    state = state!.copyWith(
      exercises: exercises,
      completedSets: completedSets,
      isRestActive: false,
    );
  }

  void completeSet(int setIndex) {
    if (state == null) return;
    final exercise = state!.currentExercise;
    if (exercise == null) return;

    final sets = List<bool>.from(state!.setsForCurrentExercise());
    if (setIndex < 0 || setIndex >= sets.length || sets[setIndex]) return;

    sets[setIndex] = true;
    final completedSets = Map<int, List<bool>>.from(state!.completedSets);
    completedSets[state!.exerciseIndex] = sets;
    state = state!.copyWith(completedSets: completedSets);

    final isLastSet = setIndex == sets.length - 1;
    final rest = exercise.restSeconds;

    if (!isLastSet && rest > 0) {
      _startRest(rest);
      return;
    }

    if (isLastSet && state!.isLastExercise) {
      if (rest > 0) {
        _startRest(rest, onComplete: beginCoolDownPhase);
      } else {
        beginCoolDownPhase();
      }
      return;
    }

    if (isLastSet && rest > 0) {
      _startRest(rest);
    }
  }

  void skipRest() {
    _finishRest();
  }

  void addRestTime(int seconds) {
    if (state == null || !state!.isRestActive) return;
    state = state!.copyWith(
      restSecondsRemaining: state!.restSecondsRemaining + seconds,
    );
  }

  void _startRest(int seconds, {void Function()? onComplete}) {
    _cancelRestTimer();
    _restOnComplete = onComplete;
    RestAlertService.resetAlerts();
    state = state!.copyWith(
      isRestActive: true,
      restSecondsRemaining: seconds,
    );
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickRest());
  }

  void _tickRest() {
    if (state == null || !state!.isRestActive) return;
    final remaining = state!.restSecondsRemaining - 1;
    if (remaining <= 0) {
      _finishRest();
      return;
    }
    state = state!.copyWith(restSecondsRemaining: remaining);
  }

  void _finishRest() {
    _cancelRestTimer();
    final callback = _restOnComplete;
    _restOnComplete = null;
    if (state != null) {
      state = state!.copyWith(isRestActive: false, restSecondsRemaining: 0);
    }
    callback?.call();
  }

  void _cancelRestTimer() {
    _restTimer?.cancel();
    _restTimer = null;
    _restOnComplete = null;
  }
}

final workoutFlowProvider =
    NotifierProvider<WorkoutFlowNotifier, WorkoutFlowState?>(
  WorkoutFlowNotifier.new,
);

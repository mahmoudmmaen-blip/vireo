import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/workout_session.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';

void main() {
  group('WorkoutFlowNotifier §2.4 active workout', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    WorkoutFlowNotifier notifier() =>
        container.read(workoutFlowProvider.notifier);

    test('startSession begins at warmUp with per-set checkboxes', () {
      final session = WorkoutSession.demo;
      notifier().startSession(session);

      final state = container.read(workoutFlowProvider)!;
      expect(state.phase, WorkoutFlowPhase.warmUp);
      expect(state.exercises, session.exercises);
      expect(state.completedSets[0]!.length, session.exercises.first.sets);
      expect(state.completedSets[0]!.every((done) => !done), isTrue);
    });

    test('beginActivePhase moves to active exercise index 0', () {
      notifier().startSession(WorkoutSession.demo);
      notifier().beginActivePhase();

      final state = container.read(workoutFlowProvider)!;
      expect(state.phase, WorkoutFlowPhase.active);
      expect(state.exerciseIndex, 0);
      expect(state.currentExercise, isNotNull);
    });

    test('completeSet auto-launches rest timer between sets', () {
      final session = WorkoutSession.demo;
      notifier().startSession(session);
      notifier().beginActivePhase();

      notifier().completeSet(0);

      final state = container.read(workoutFlowProvider)!;
      expect(state.isRestActive, isTrue);
      expect(state.restSecondsRemaining, session.exercises.first.restSeconds);
      expect(state.setsForCurrentExercise()[0], isTrue);
    });

    test('skipRest clears active rest overlay state', () {
      notifier().startSession(WorkoutSession.demo);
      notifier().beginActivePhase();
      notifier().completeSet(0);

      notifier().skipRest();

      final state = container.read(workoutFlowProvider)!;
      expect(state.isRestActive, isFalse);
      expect(state.restSecondsRemaining, 0);
    });

    test('previousExercise and nextExercise navigate between exercises', () {
      notifier().startSession(WorkoutSession.demo);
      notifier().beginActivePhase();

      notifier().nextExercise();
      expect(container.read(workoutFlowProvider)!.exerciseIndex, 1);

      notifier().previousExercise();
      expect(container.read(workoutFlowProvider)!.exerciseIndex, 0);
    });

    test('nextExercise on last exercise transitions to coolDown', () {
      notifier().startSession(WorkoutSession.demo);
      notifier().beginActivePhase();

      final count = container.read(workoutFlowProvider)!.exercises.length;
      for (var i = 0; i < count - 1; i++) {
        notifier().nextExercise();
      }
      notifier().nextExercise();

      expect(container.read(workoutFlowProvider)!.phase, WorkoutFlowPhase.coolDown);
    });

    test('swapExercise replaces current exercise and resets sets', () {
      notifier().startSession(WorkoutSession.demo);
      notifier().beginActivePhase();

      final current = container.read(workoutFlowProvider)!.currentExercise!;
      final replacement = current.copyWith(id: 'swap_alt', sets: 4);

      notifier().swapExercise(replacement);

      final state = container.read(workoutFlowProvider)!;
      expect(state.currentExercise!.id, 'swap_alt');
      expect(state.setsForCurrentExercise().length, 4);
      expect(state.setsForCurrentExercise().every((done) => !done), isTrue);
    });

    test('togglePause drives pause overlay state', () {
      notifier().startSession(WorkoutSession.demo);
      notifier().togglePause(true);
      expect(container.read(workoutFlowProvider)!.isPaused, isTrue);

      notifier().togglePause(false);
      expect(container.read(workoutFlowProvider)!.isPaused, isFalse);
    });

    test('phase progression warmUp → active → coolDown → feedback → complete', () {
      notifier().startSession(WorkoutSession.demo);
      expect(container.read(workoutFlowProvider)!.phase, WorkoutFlowPhase.warmUp);

      notifier().beginActivePhase();
      expect(container.read(workoutFlowProvider)!.phase, WorkoutFlowPhase.active);

      notifier().beginCoolDownPhase();
      expect(container.read(workoutFlowProvider)!.phase, WorkoutFlowPhase.coolDown);

      notifier().beginFeedbackPhase();
      expect(container.read(workoutFlowProvider)!.phase, WorkoutFlowPhase.feedback);

      notifier().completeWorkout();
      expect(container.read(workoutFlowProvider)!.phase, WorkoutFlowPhase.complete);
    });
  });
}

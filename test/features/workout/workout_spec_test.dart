import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/services/rest_alert_service.dart';
import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/data/models/workout_session.dart';

void main() {
  group('WorkoutSession §2.4 demo structure', () {
    test('includes warm-up, main exercises, and cool-down', () {
      final session = WorkoutSession.demo;
      expect(session.warmUp, isNotEmpty);
      expect(session.exercises, isNotEmpty);
      expect(session.coolDown, isNotEmpty);
    });

    test('WorkoutFlowPhase covers full active workout lifecycle', () {
      expect(WorkoutFlowPhase.values, containsAll([
        WorkoutFlowPhase.warmUp,
        WorkoutFlowPhase.active,
        WorkoutFlowPhase.coolDown,
        WorkoutFlowPhase.feedback,
        WorkoutFlowPhase.complete,
      ]));
    });

    test('WorkoutDifficultyFeedback serializes for post-workout screen', () {
      expect(WorkoutDifficultyFeedback.easy.value, 'easy');
      expect(WorkoutDifficultyFeedback.justRight.value, 'just_right');
      expect(WorkoutDifficultyFeedback.hard.value, 'hard');
    });
  });

  group('Exercise §2.4 display helpers', () {
    const exercise = Exercise(
      id: 'ex',
      name: 'Push-ups',
      nameAr: 'ضغط',
      targetMuscle: 'Chest',
      targetMuscleAr: 'الصدر',
      sets: 3,
      reps: 12,
      restSeconds: 45,
      videoUrl: 'https://example.com/demo.mp4',
      type: ExerciseType.strength,
      environments: [],
    );

    test('localizedName and localizedTargetMuscle support AR/EN', () {
      expect(exercise.localizedName('en'), 'Push-ups');
      expect(exercise.localizedName('ar'), 'ضغط');
      expect(exercise.localizedTargetMuscle('en'), 'Chest');
      expect(exercise.localizedTargetMuscle('ar'), 'الصدر');
    });

    test('videoAspectRatio is defined per exercise type for demo loop', () {
      expect(exercise.videoAspectRatio, 16 / 9);
      expect(ExerciseType.mobility.videoAspectRatio, 1);
    });
  });

  group('RestAlertService §2.4 haptics', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('resetAlerts and onTick do not throw', () async {
      await RestAlertService.resetAlerts();
      await RestAlertService.onTick(5);
      await RestAlertService.onTick(0);
      await RestAlertService.resetAlerts();
      await RestAlertService.onTick(5);
    });
  });
}

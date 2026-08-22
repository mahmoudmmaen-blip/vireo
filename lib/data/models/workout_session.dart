import 'package:vireo/data/models/exercise.dart';
import 'package:vireo/data/models/training_environment.dart';

enum WorkoutDifficultyFeedback {
  easy('easy'),
  justRight('just_right'),
  hard('hard');

  const WorkoutDifficultyFeedback(this.value);
  final String value;
}

enum WorkoutFlowPhase {
  warmUp,
  active,
  coolDown,
  feedback,
  complete,
}

class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.warmUp,
    required this.exercises,
    required this.coolDown,
  });

  final String id;
  final List<Exercise> warmUp;
  final List<Exercise> exercises;
  final List<Exercise> coolDown;

  static WorkoutSession demo = WorkoutSession(
    id: 'demo-session',
    warmUp: _demoMobility(prefix: 'warm'),
    exercises: _demoMainExercises(),
    coolDown: _demoMobility(prefix: 'cool'),
  );

  static List<Exercise> _demoMobility({required String prefix}) => [
        Exercise(
          id: '${prefix}_1',
          name: 'Arm Circles',
          nameAr: 'دوائر الذراع',
          targetMuscle: 'Shoulders',
          targetMuscleAr: 'الأكتاف',
          sets: 1,
          reps: 30,
          restSeconds: 0,
          videoUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          type: ExerciseType.mobility,
          environments: TrainingEnvironment.values,
        ),
        Exercise(
          id: '${prefix}_2',
          name: 'Hip Openers',
          nameAr: 'فتح الورك',
          targetMuscle: 'Hips',
          targetMuscleAr: 'الورك',
          sets: 1,
          reps: 20,
          restSeconds: 0,
          videoUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          type: ExerciseType.mobility,
          environments: TrainingEnvironment.values,
        ),
        Exercise(
          id: '${prefix}_3',
          name: 'Ankle Rolls',
          nameAr: 'لف الكاحل',
          targetMuscle: 'Calves',
          targetMuscleAr: 'السمانة',
          sets: 1,
          reps: 20,
          restSeconds: 0,
          videoUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
          type: ExerciseType.mobility,
          environments: TrainingEnvironment.values,
        ),
      ];

  static List<Exercise> _demoMainExercises() => [
        Exercise(
          id: 'ex_1',
          name: 'Push-ups',
          nameAr: 'ضغط',
          targetMuscle: 'Chest',
          targetMuscleAr: 'الصدر',
          sets: 3,
          reps: 12,
          restSeconds: 45,
          videoUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          type: ExerciseType.strength,
          environments: [
            TrainingEnvironment.homeNoEquipment,
            TrainingEnvironment.homeLightEquipment,
            TrainingEnvironment.gymFull,
          ],
        ),
        Exercise(
          id: 'ex_2',
          name: 'Goblet Squat',
          nameAr: 'قرفصاء',
          targetMuscle: 'Legs',
          targetMuscleAr: 'الأرجل',
          sets: 3,
          reps: 10,
          restSeconds: 60,
          videoUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          type: ExerciseType.strength,
          environments: [
            TrainingEnvironment.homeLightEquipment,
            TrainingEnvironment.gymFull,
          ],
        ),
        Exercise(
          id: 'ex_3',
          name: 'Plank Hold',
          nameAr: 'بلانك',
          targetMuscle: 'Core',
          targetMuscleAr: 'الجذع',
          sets: 3,
          reps: 30,
          restSeconds: 30,
          videoUrl:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
          type: ExerciseType.strength,
          environments: TrainingEnvironment.values,
        ),
      ];
}

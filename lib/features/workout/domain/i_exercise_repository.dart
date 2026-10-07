import 'package:vireo/features/workout/domain/exercise_detail.dart';

abstract class IExerciseRepository {
  Future<ExerciseDetail> getExerciseDetail(String exerciseId);
  List<ExerciseDetail> getAllExercises();
}

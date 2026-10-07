import 'package:vireo/features/workout/data/exercise_detail_catalog.dart';
import 'package:vireo/features/workout/domain/exercise_detail.dart';
import 'package:vireo/features/workout/domain/i_exercise_repository.dart';

class ExerciseRepositoryImpl implements IExerciseRepository {
  const ExerciseRepositoryImpl();

  @override
  Future<ExerciseDetail> getExerciseDetail(String exerciseId) async {
    final found = ExerciseDetailCatalog.byId(exerciseId);
    if (found != null) return found;

    // Fallback: match by slug derived from id/name fragment.
    for (final detail in ExerciseDetailCatalog.all) {
      if (detail.name.toLowerCase().contains(exerciseId.toLowerCase())) {
        return detail;
      }
    }

    return ExerciseDetailCatalog.all.first;
  }

  @override
  List<ExerciseDetail> getAllExercises() => ExerciseDetailCatalog.all;
}

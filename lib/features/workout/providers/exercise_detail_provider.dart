import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/workout/data/exercise_repository_impl.dart';
import 'package:vireo/features/workout/domain/exercise_detail.dart';
import 'package:vireo/features/workout/domain/i_exercise_repository.dart';

final exerciseDetailRepositoryProvider = Provider<IExerciseRepository>(
  (ref) => const ExerciseRepositoryImpl(),
);

final exerciseDetailProvider =
    FutureProvider.family<ExerciseDetail, String>((ref, exerciseId) async {
  return ref.read(exerciseDetailRepositoryProvider).getExerciseDetail(exerciseId);
});

final allExerciseDetailsProvider = Provider<List<ExerciseDetail>>((ref) {
  return ref.read(exerciseDetailRepositoryProvider).getAllExercises();
});

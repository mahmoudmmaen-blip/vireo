import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vireo/features/workout/domain/exercise_media.dart';

part 'exercise_detail.freezed.dart';

@freezed
class ExerciseDetail with _$ExerciseDetail {
  const factory ExerciseDetail({
    required String id,
    required String name,
    required String nameAr,
    required List<String> muscleGroups,
    @Default([]) List<String> secondaryMuscles,
    required List<String> instructions,
    @Default([]) List<String> commonMistakes,
    @Default([]) List<String> tips,
    @Default([]) List<String> equipment,
    required ExerciseDifficulty difficulty,
    required String mediaPath,
    @Default(ExerciseMediaType.gif) ExerciseMediaType mediaType,
    @Default(3) int targetSets,
    @Default(10) int targetReps,
    @Default(60) int restSeconds,
    @Default(false) bool isCompound,
    @Default(false) bool vitalityBoost,
  }) = _ExerciseDetail;
}

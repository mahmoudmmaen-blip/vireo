import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/workout_session.dart';
import 'package:vireo/features/workout/providers/exercise_detail_provider.dart';
import 'package:vireo/features/workout/providers/workout_flow_provider.dart';
import 'package:vireo/features/workout/screens/exercise_detail_screen.dart';
import 'package:vireo/features/workout/widgets/exercise_media_player.dart';

/// Picture-in-picture exercise media during an active workout session.
class ExerciseMediaOverlay extends ConsumerStatefulWidget {
  const ExerciseMediaOverlay({super.key});

  @override
  ConsumerState<ExerciseMediaOverlay> createState() =>
      _ExerciseMediaOverlayState();
}

class _ExerciseMediaOverlayState extends ConsumerState<ExerciseMediaOverlay> {
  double _dragOffset = 0;

  void _openDetail(String exerciseId, String heroTag) {
    final flow = ref.read(workoutFlowProvider);
    if (flow == null) return;

    final exercise = flow.currentExercise!;
    final completed = flow.setsForCurrentExercise().where((d) => d).length;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExerciseDetailScreen(
          exerciseId: exerciseId,
          heroTag: heroTag,
          initialSets: exercise.sets,
          initialReps: exercise.reps,
          initialRestSeconds: exercise.restSeconds,
          targetSets: exercise.sets,
          completedSets: completed,
          onCompleteSet: () {
            final setIndex =
                flow.setsForCurrentExercise().indexWhere((d) => !d);
            if (setIndex >= 0) {
              ref.read(workoutFlowProvider.notifier).completeSet(setIndex);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(workoutFlowProvider);
    if (flow == null ||
        flow.phase != WorkoutFlowPhase.active ||
        flow.isRestActive ||
        flow.isPaused ||
        flow.currentExercise == null) {
      return const SizedBox.shrink();
    }

    final exercise = flow.currentExercise!;
    final detailAsync = ref.watch(exerciseDetailProvider(exercise.id));
    final colors = context.vireoColors;
    final heroTag = 'exercise_media_${exercise.id}';
    final notifier = ref.read(workoutFlowProvider.notifier);

    return Positioned(
      right: 12 + _dragOffset.clamp(-80.0, 80.0),
      bottom: 88,
      child: GestureDetector(
        onTap: () => _openDetail(exercise.id, heroTag),
        onHorizontalDragUpdate: (details) {
          setState(() => _dragOffset += details.delta.dx);
        },
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity > 400 && !flow.isLastExercise) {
            notifier.nextExercise();
          } else if (velocity < -400 && !flow.isFirstExercise) {
            notifier.previousExercise();
          }
          setState(() => _dragOffset = 0);
        },
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(14),
          color: colors.surface,
          child: SizedBox(
            width: 132,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: detailAsync.when(
                    loading: () => SizedBox(
                      height: 88,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: colors.ember,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    error: (error, stackTrace) => SizedBox(
                      height: 88,
                      child: Icon(Icons.fitness_center, color: colors.ember),
                    ),
                    data: (detail) => ExerciseMediaPlayer(
                      detail: detail,
                      compact: true,
                      showMuscleOverlay: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(Icons.swipe, size: 14, color: colors.textMute),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          exercise.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textMute,
                          ),
                        ),
                      ),
                      Icon(Icons.open_in_full, size: 14, color: colors.ember),
                    ],
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

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vireo/features/habits/data/providers/habit_repository_provider.dart';
import 'package:vireo/features/habits/domain/entities/habit.dart';

part 'habit_controller.g.dart';

@riverpod
class HabitController extends _$HabitController {
  @override
  FutureOr<List<Habit>> build() async {
    final repository = await ref.watch(habitRepositoryProvider.future);
    return repository.getHabits();
  }

  Future<void> toggleHabit(String id) async {
    final previous = state;
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    final optimistic = current
        .map((habit) => _toggleHabitOptimistically(habit, id))
        .toList(growable: false);

    state = AsyncData(optimistic);

    try {
      final repository = await ref.read(habitRepositoryProvider.future);
      await repository.toggleHabit(id);
      state = AsyncData(await repository.getHabits());
    } catch (error, stackTrace) {
      state = previous.hasValue
          ? AsyncError<List<Habit>>(error, stackTrace).copyWithPrevious(previous)
          : AsyncError<List<Habit>>(error, stackTrace);
    }
  }

  Future<void> addHabit(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final previous = state;

    try {
      final repository = await ref.read(habitRepositoryProvider.future);
      await repository.addHabit(trimmed);
      state = AsyncData(await repository.getHabits());
    } catch (error, stackTrace) {
      state = previous.hasValue
          ? AsyncError<List<Habit>>(error, stackTrace).copyWithPrevious(previous)
          : AsyncError<List<Habit>>(error, stackTrace);
    }
  }

  Habit _toggleHabitOptimistically(Habit habit, String id) {
    if (habit.id != id) {
      return habit;
    }

    final completed = !habit.isCompletedToday;
    return habit.copyWith(
      isCompletedToday: completed,
      streak: completed
          ? habit.streak + 1
          : (habit.streak > 0 ? habit.streak - 1 : 0),
    );
  }
}

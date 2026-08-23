import 'package:vireo/features/habits/data/datasources/habit_local_data_source.dart';
import 'package:vireo/features/habits/data/models/habit_model.dart';
import 'package:vireo/features/habits/domain/entities/habit.dart';
import 'package:vireo/features/habits/domain/repositories/i_habit_repository.dart';

class HabitRepositoryImpl implements IHabitRepository {
  HabitRepositoryImpl(this._localDataSource);

  final HabitLocalDataSource _localDataSource;

  @override
  Future<List<Habit>> getHabits() async {
    final models = await _localDataSource.getHabits();
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<void> toggleHabit(String id) async {
    final models = await _localDataSource.getHabits();
    final updated = models.map((model) {
      if (model.id != id) {
        return model;
      }

      final completed = !model.isCompletedToday;
      return HabitModel(
        id: model.id,
        title: model.title,
        streak: completed
            ? model.streak + 1
            : (model.streak > 0 ? model.streak - 1 : 0),
        isCompletedToday: completed,
        createdAt: model.createdAt,
      );
    }).toList();

    await _localDataSource.saveHabits(updated);
  }

  @override
  Future<void> addHabit(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final models = await _localDataSource.getHabits();
    final now = DateTime.now();

    await _localDataSource.saveHabits([
      ...models,
      HabitModel(
        id: now.microsecondsSinceEpoch.toString(),
        title: trimmed,
        streak: 0,
        isCompletedToday: false,
        createdAt: now,
      ),
    ]);
  }
}

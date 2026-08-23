import 'package:vireo/features/habits/domain/entities/habit.dart';

abstract interface class IHabitRepository {
  Future<List<Habit>> getHabits();

  Future<void> toggleHabit(String id);

  Future<void> addHabit(String title);
}

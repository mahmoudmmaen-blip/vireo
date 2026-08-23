import 'package:vireo/features/habits/data/models/habit_model.dart';

abstract interface class HabitLocalDataSource {
  Future<List<HabitModel>> getHabits();

  Future<void> saveHabits(List<HabitModel> habits);
}

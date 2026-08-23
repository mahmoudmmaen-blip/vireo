import 'package:json_annotation/json_annotation.dart';
import 'package:vireo/features/habits/domain/entities/habit.dart';

part 'habit_model.g.dart';

@JsonSerializable()
class HabitModel {
  const HabitModel({
    required this.id,
    required this.title,
    required this.streak,
    required this.isCompletedToday,
    required this.createdAt,
  });

  final String id;
  final String title;
  final int streak;
  final bool isCompletedToday;
  final DateTime createdAt;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);

  Map<String, dynamic> toJson() => _$HabitModelToJson(this);

  Habit toDomain() {
    return Habit(
      id: id,
      title: title,
      streak: streak,
      isCompletedToday: isCompletedToday,
      createdAt: createdAt,
    );
  }

  factory HabitModel.fromDomain(Habit habit) {
    return HabitModel(
      id: habit.id,
      title: habit.title,
      streak: habit.streak,
      isCompletedToday: habit.isCompletedToday,
      createdAt: habit.createdAt,
    );
  }
}

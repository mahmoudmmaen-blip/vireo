// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitModel _$HabitModelFromJson(Map<String, dynamic> json) => HabitModel(
      id: json['id'] as String,
      title: json['title'] as String,
      streak: (json['streak'] as num).toInt(),
      isCompletedToday: json['isCompletedToday'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$HabitModelToJson(HabitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'streak': instance.streak,
      'isCompletedToday': instance.isCompletedToday,
      'createdAt': instance.createdAt.toIso8601String(),
    };

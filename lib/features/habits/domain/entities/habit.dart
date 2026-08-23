import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';

@freezed
class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String title,
    required int streak,
    required bool isCompletedToday,
    required DateTime createdAt,
  }) = _Habit;
}

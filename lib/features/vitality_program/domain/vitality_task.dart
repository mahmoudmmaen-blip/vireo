import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vireo/features/vitality_program/domain/vitality_program_phase.dart';

part 'vitality_task.freezed.dart';

@freezed
class VitalityTask with _$VitalityTask {
  const factory VitalityTask({
    required String id,
    required String titleEn,
    required String titleAr,
    required VitalityTaskCategory category,
    @Default(false) bool isCompleted,
    @Default(<DateTime>[]) List<DateTime> completionDates,
  }) = _VitalityTask;
}

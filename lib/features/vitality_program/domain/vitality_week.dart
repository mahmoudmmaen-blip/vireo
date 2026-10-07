import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vireo/features/vitality_program/domain/vitality_program_phase.dart';
import 'package:vireo/features/vitality_program/domain/vitality_task.dart';

part 'vitality_week.freezed.dart';

@freezed
class VitalityWeek with _$VitalityWeek {
  const VitalityWeek._();

  const factory VitalityWeek({
    required int weekNumber,
    required VitalityProgramPhase phase,
    required String titleEn,
    required String titleAr,
    required String focusEn,
    required String focusAr,
    required List<VitalityTask> dailyTasks,
    @Default(false) bool isUnlocked,
    @Default(false) bool isCompleted,
    @Default(0.0) double completionPercentage,
  }) = _VitalityWeek;

  String titleFor(String locale) => locale == 'ar' ? titleAr : titleEn;

  String focusFor(String locale) => locale == 'ar' ? focusAr : focusEn;
}

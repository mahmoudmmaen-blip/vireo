import 'package:flutter/material.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/vitality_program/domain/vitality_program_phase.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

Color vitalityTaskCategoryColor(VitalityTaskCategory category, VireoColors colors) {
  return switch (category) {
    VitalityTaskCategory.nutrition => VBridge.cFF22C55E,
    VitalityTaskCategory.workout => VBridge.cFFF97316,
    VitalityTaskCategory.sleep => VBridge.cFFA855F7,
    VitalityTaskCategory.supplement => VBridge.cFF3B82F6,
    VitalityTaskCategory.mindset => VBridge.cFF14B8A6,
  };
}

IconData vitalityTaskCategoryIcon(VitalityTaskCategory category) {
  return switch (category) {
    VitalityTaskCategory.nutrition => Icons.restaurant_outlined,
    VitalityTaskCategory.workout => Icons.fitness_center_outlined,
    VitalityTaskCategory.sleep => Icons.bedtime_outlined,
    VitalityTaskCategory.supplement => Icons.medication_outlined,
    VitalityTaskCategory.mindset => Icons.self_improvement_outlined,
  };
}

String vitalityPhaseLabel(
  VitalityProgramPhase phase,
  String locale, {
  required String foundationEn,
  required String foundationAr,
  required String optimizationEn,
  required String optimizationAr,
  required String peakEn,
  required String peakAr,
}) {
  final isAr = locale == 'ar';
  return switch (phase) {
    VitalityProgramPhase.foundation =>
      isAr ? foundationAr : foundationEn,
    VitalityProgramPhase.optimization =>
      isAr ? optimizationAr : optimizationEn,
    VitalityProgramPhase.peak => isAr ? peakAr : peakEn,
  };
}

import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/data/models/unit_preference.dart';

/// In-memory onboarding draft — canonical storage is always metric (kg, cm).
class OnboardingDraft {
  const OnboardingDraft({
    this.age,
    this.heightCm,
    this.weightKg,
    this.unitPreference = UnitPreference.metric,
    this.activityLevel = ActivityLevel.moderatelyActive,
    this.dietaryRestrictions = const [],
    this.heartDisease = false,
    this.diabetes = false,
    this.highBloodPressure = false,
    this.jointInjuries = false,
    this.currentMedications = false,
    this.trainingEnvironment = TrainingEnvironment.homeNoEquipment,
    this.goal = FitnessGoal.generalVitality,
    this.consentAccepted = false,
    this.consentAcceptedAt,
    this.preferredWorkoutTime,
    this.walkingReminderEnabled = false,
    this.weeklyCheckInReminderEnabled = false,
  });

  final int? age;
  final double? heightCm;
  final double? weightKg;
  final UnitPreference unitPreference;
  final ActivityLevel activityLevel;
  final List<String> dietaryRestrictions;
  final bool heartDisease;
  final bool diabetes;
  final bool highBloodPressure;
  final bool jointInjuries;
  final bool currentMedications;
  final TrainingEnvironment trainingEnvironment;
  final FitnessGoal goal;
  final bool consentAccepted;
  final DateTime? consentAcceptedAt;
  final DateTime? preferredWorkoutTime;
  final bool walkingReminderEnabled;
  final bool weeklyCheckInReminderEnabled;

  bool get medicalFlag =>
      heartDisease ||
      diabetes ||
      highBloodPressure ||
      jointInjuries ||
      currentMedications;

  bool get isStep1Valid =>
      age != null &&
      age! >= 18 &&
      age! <= 100 &&
      heightCm != null &&
      heightCm! > 0 &&
      weightKg != null &&
      weightKg! > 0;

  bool get isStep5Valid => consentAccepted;

  OnboardingDraft copyWith({
    int? age,
    double? heightCm,
    double? weightKg,
    UnitPreference? unitPreference,
    ActivityLevel? activityLevel,
    List<String>? dietaryRestrictions,
    bool? heartDisease,
    bool? diabetes,
    bool? highBloodPressure,
    bool? jointInjuries,
    bool? currentMedications,
    TrainingEnvironment? trainingEnvironment,
    FitnessGoal? goal,
    bool? consentAccepted,
    DateTime? consentAcceptedAt,
    DateTime? preferredWorkoutTime,
    bool? walkingReminderEnabled,
    bool? weeklyCheckInReminderEnabled,
  }) {
    return OnboardingDraft(
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      unitPreference: unitPreference ?? this.unitPreference,
      activityLevel: activityLevel ?? this.activityLevel,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      heartDisease: heartDisease ?? this.heartDisease,
      diabetes: diabetes ?? this.diabetes,
      highBloodPressure: highBloodPressure ?? this.highBloodPressure,
      jointInjuries: jointInjuries ?? this.jointInjuries,
      currentMedications: currentMedications ?? this.currentMedications,
      trainingEnvironment: trainingEnvironment ?? this.trainingEnvironment,
      goal: goal ?? this.goal,
      consentAccepted: consentAccepted ?? this.consentAccepted,
      consentAcceptedAt: consentAcceptedAt ?? this.consentAcceptedAt,
      preferredWorkoutTime: preferredWorkoutTime ?? this.preferredWorkoutTime,
      walkingReminderEnabled:
          walkingReminderEnabled ?? this.walkingReminderEnabled,
      weeklyCheckInReminderEnabled:
          weeklyCheckInReminderEnabled ?? this.weeklyCheckInReminderEnabled,
    );
  }

  Map<String, dynamic> toUserRow(String userId) {
    return {
      'id': userId,
      'age': age,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'activity_level': activityLevel.value,
      'medical_flag': medicalFlag,
      'training_environment': trainingEnvironment.value,
      'goal': goal.value,
      'dietary_restrictions': dietaryRestrictions,
      'consent_accepted_at':
          consentAcceptedAt?.toUtc().toIso8601String(),
      'unit_preference': unitPreference.value,
    };
  }
}

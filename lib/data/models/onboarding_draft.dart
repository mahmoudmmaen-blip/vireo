import 'package:vireo/data/models/activity_level.dart';
import 'package:vireo/data/models/fitness_goal.dart';
import 'package:vireo/data/models/training_environment.dart';
import 'package:vireo/data/models/unit_preference.dart';

/// In-memory onboarding draft — canonical storage is always metric (kg, cm).
class OnboardingDraft {
  const OnboardingDraft({
    this.sex = 'male',
    this.age,
    this.heightCm,
    this.weightKg,
    this.targetWeightKg,
    this.unitPreference = UnitPreference.metric,
    this.activityLevel = ActivityLevel.moderatelyActive,
    this.dietaryRestrictions = const [],
    this.healthConditions = const {},
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
    this.focusGoals = const [],
  });

  final String sex;
  final int? age;
  final double? heightCm;
  final double? weightKg;
  final double? targetWeightKg;
  final UnitPreference unitPreference;
  final ActivityLevel activityLevel;
  final List<String> dietaryRestrictions;
  final Set<String> healthConditions;
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
  final List<String> focusGoals;

  bool get medicalFlag =>
      heartDisease ||
      diabetes ||
      highBloodPressure ||
      jointInjuries ||
      currentMedications ||
      healthConditions.isNotEmpty;

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
    String? sex,
    int? age,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    bool clearAge = false,
    bool clearHeightCm = false,
    bool clearWeightKg = false,
    bool clearTargetWeightKg = false,
    UnitPreference? unitPreference,
    ActivityLevel? activityLevel,
    List<String>? dietaryRestrictions,
    Set<String>? healthConditions,
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
    List<String>? focusGoals,
  }) {
    return OnboardingDraft(
      sex: sex ?? this.sex,
      age: clearAge ? null : (age ?? this.age),
      heightCm: clearHeightCm ? null : (heightCm ?? this.heightCm),
      weightKg: clearWeightKg ? null : (weightKg ?? this.weightKg),
      targetWeightKg: clearTargetWeightKg ? null : (targetWeightKg ?? this.targetWeightKg),
      unitPreference: unitPreference ?? this.unitPreference,
      activityLevel: activityLevel ?? this.activityLevel,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      healthConditions: healthConditions ?? this.healthConditions,
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
      focusGoals: focusGoals ?? this.focusGoals,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sex': sex,
      'age': age,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'target_weight_kg': targetWeightKg,
      'focus_goals': focusGoals,
      'activity_level': activityLevel.value,
      'medical_flag': medicalFlag,
      'training_environment': trainingEnvironment.value,
      'goal': goal.value,
      'dietary_restrictions': dietaryRestrictions,
      'health_conditions': healthConditions.toList(),
      'heart_disease': heartDisease,
      'diabetes': diabetes,
      'high_blood_pressure': highBloodPressure,
      'joint_injuries': jointInjuries,
      'current_medications': currentMedications,
      'consent_accepted': consentAccepted,
      'consent_accepted_at': consentAcceptedAt?.toUtc().toIso8601String(),
      'unit_preference': unitPreference.value,
      'preferred_workout_time': preferredWorkoutTime?.toUtc().toIso8601String(),
      'walking_reminder_enabled': walkingReminderEnabled,
      'weekly_checkin_reminder_enabled': weeklyCheckInReminderEnabled,
    };
  }

  factory OnboardingDraft.fromJson(Map<String, dynamic> json) {
    return OnboardingDraft(
      sex: json['sex']?.toString() ?? 'male',
      age: json['age'] as int?,
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      targetWeightKg: (json['target_weight_kg'] as num?)?.toDouble(),
      unitPreference: json['unit_preference'] != null
          ? UnitPreference.fromValue(json['unit_preference'].toString())
          : UnitPreference.metric,
      activityLevel: json['activity_level'] != null
          ? ActivityLevel.fromValue(json['activity_level'].toString())
          : ActivityLevel.moderatelyActive,
      dietaryRestrictions: (json['dietary_restrictions'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      healthConditions: (json['health_conditions'] as List? ?? [])
          .map((e) => e.toString())
          .toSet(),
      heartDisease: json['heart_disease'] as bool? ?? false,
      diabetes: json['diabetes'] as bool? ?? false,
      highBloodPressure: json['high_blood_pressure'] as bool? ?? false,
      jointInjuries: json['joint_injuries'] as bool? ?? false,
      currentMedications: json['current_medications'] as bool? ?? false,
      trainingEnvironment: json['training_environment'] != null
          ? TrainingEnvironment.fromValue(json['training_environment'].toString())
          : TrainingEnvironment.homeNoEquipment,
      goal: json['goal'] != null
          ? FitnessGoal.fromValue(json['goal'].toString())
          : FitnessGoal.generalVitality,
      consentAccepted: json['consent_accepted'] as bool? ?? false,
      consentAcceptedAt: json['consent_accepted_at'] != null
          ? DateTime.tryParse(json['consent_accepted_at'].toString())
          : null,
      preferredWorkoutTime: json['preferred_workout_time'] != null
          ? DateTime.tryParse(json['preferred_workout_time'].toString())
          : null,
      walkingReminderEnabled: json['walking_reminder_enabled'] as bool? ?? false,
      weeklyCheckInReminderEnabled:
          json['weekly_checkin_reminder_enabled'] as bool? ?? false,
      focusGoals: (json['focus_goals'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toUserRow(String userId) {
    return {
      'id': userId,
      'sex': sex,
      'age': age,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'target_weight_kg': targetWeightKg,
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

class WeightLogEntry {
  const WeightLogEntry({
    required this.id,
    required this.weightKg,
    required this.loggedAt,
  });

  final String id;
  final double weightKg;
  final DateTime loggedAt;

  factory WeightLogEntry.fromJson(Map<String, dynamic> json) {
    return WeightLogEntry(
      id: json['id'] as String? ?? '',
      weightKg: (json['weight_kg'] as num).toDouble(),
      loggedAt: DateTime.parse(json['logged_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'weight_kg': weightKg,
        'logged_at': loggedAt.toIso8601String(),
      };
}

class AdherenceWeek {
  const AdherenceWeek({
    required this.weekStart,
    required this.completionPct,
  });

  final DateTime weekStart;
  final int completionPct;
}

class EnergyCheckIn {
  const EnergyCheckIn({
    required this.weekNumber,
    required this.energyScore,
    required this.loggedAt,
  });

  final int weekNumber;
  final int energyScore;
  final DateTime loggedAt;

  factory EnergyCheckIn.fromJson(Map<String, dynamic> json) {
    return EnergyCheckIn(
      weekNumber: json['week_number'] as int,
      energyScore: json['energy_score'] as int? ?? 5,
      loggedAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class ReassessmentRecord {
  const ReassessmentRecord({
    required this.weightKg,
    required this.activityLevel,
    required this.trainingEnvironment,
    required this.programPhase,
    required this.createdAt,
    this.previousWeightKg,
    this.previousActivityLevel,
    this.previousTrainingEnvironment,
    this.phaseRecalculated = false,
  });

  final double weightKg;
  final String activityLevel;
  final String trainingEnvironment;
  final int programPhase;
  final DateTime createdAt;
  final double? previousWeightKg;
  final String? previousActivityLevel;
  final String? previousTrainingEnvironment;
  final bool phaseRecalculated;

  factory ReassessmentRecord.fromJson(Map<String, dynamic> json) {
    return ReassessmentRecord(
      weightKg: (json['weight_kg'] as num).toDouble(),
      activityLevel: json['activity_level'] as String,
      trainingEnvironment: json['training_environment'] as String,
      programPhase: json['program_phase'] as int? ?? 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      previousWeightKg: (json['previous_weight_kg'] as num?)?.toDouble(),
      previousActivityLevel: json['previous_activity_level'] as String?,
      previousTrainingEnvironment:
          json['previous_training_environment'] as String?,
      phaseRecalculated: json['phase_recalculated'] as bool? ?? false,
    );
  }
}

enum ProgressTab { weight, adherence, energy }

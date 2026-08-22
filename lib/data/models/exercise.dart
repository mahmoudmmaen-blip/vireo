import 'package:vireo/data/models/training_environment.dart';

enum ExerciseType {
  strength,
  mobility,
  cardio;

  double get videoAspectRatio {
    switch (this) {
      case ExerciseType.strength:
        return 16 / 9;
      case ExerciseType.mobility:
      case ExerciseType.cardio:
        return 1;
    }
  }
}

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.targetMuscle,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.videoUrl,
    required this.type,
    required this.environments,
    this.nameAr,
    this.targetMuscleAr,
  });

  final String id;
  final String name;
  final String? nameAr;
  final String targetMuscle;
  final String? targetMuscleAr;
  final int sets;
  final int reps;
  final int restSeconds;
  final String videoUrl;
  final ExerciseType type;
  final List<TrainingEnvironment> environments;

  double get videoAspectRatio => type.videoAspectRatio;

  String localizedName(String languageCode) =>
      languageCode == 'ar' && nameAr != null ? nameAr! : name;

  String localizedTargetMuscle(String languageCode) =>
      languageCode == 'ar' && targetMuscleAr != null
          ? targetMuscleAr!
          : targetMuscle;

  bool matchesEnvironment(TrainingEnvironment environment) =>
      environments.contains(environment);

  Exercise copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? targetMuscle,
    String? targetMuscleAr,
    int? sets,
    int? reps,
    int? restSeconds,
    String? videoUrl,
    ExerciseType? type,
    List<TrainingEnvironment>? environments,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      targetMuscleAr: targetMuscleAr ?? this.targetMuscleAr,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      videoUrl: videoUrl ?? this.videoUrl,
      type: type ?? this.type,
      environments: environments ?? this.environments,
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final envList = (json['environments'] as List<dynamic>? ??
            json['environment_tags'] as List<dynamic>? ??
            [])
        .map((e) => TrainingEnvironment.fromValue(e.toString()))
        .toList();

    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      targetMuscle: json['target_muscle'] as String,
      targetMuscleAr: json['target_muscle_ar'] as String?,
      sets: json['sets'] as int? ?? 3,
      reps: json['reps'] as int? ?? 10,
      restSeconds: json['rest_seconds'] as int? ?? 60,
      videoUrl: json['video_url'] as String? ?? '',
      type: ExerciseType.values.firstWhere(
        (t) => t.name == (json['type'] as String? ?? 'strength'),
        orElse: () => ExerciseType.strength,
      ),
      environments: envList.isEmpty
          ? TrainingEnvironment.values
          : envList,
    );
  }
}

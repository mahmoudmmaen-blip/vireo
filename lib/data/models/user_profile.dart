import 'package:vireo/data/models/training_environment.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    this.medicalFlag = false,
    this.trainingEnvironment = TrainingEnvironment.homeNoEquipment,
  });

  final String id;
  final bool medicalFlag;
  final TrainingEnvironment trainingEnvironment;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      medicalFlag: json['medical_flag'] as bool? ?? false,
      trainingEnvironment: TrainingEnvironment.fromValue(
        json['training_environment'] as String? ?? 'home_no_equipment',
      ),
    );
  }

  static const demo = UserProfile(
    id: 'demo-user',
    medicalFlag: true,
    trainingEnvironment: TrainingEnvironment.homeLightEquipment,
  );
}

import 'package:flutter/foundation.dart';

@immutable
class UserContext {
  const UserContext({
    required this.remainingCalories,
    required this.remainingProtein,
    required this.targetCalories,
    required this.targetProtein,
    required this.currentWeight,
    required this.goal,
  });

  final int remainingCalories;
  final double remainingProtein;
  final int targetCalories;
  final int targetProtein;
  final double currentWeight;
  final String goal;

  static const demo = UserContext(
    remainingCalories: 1200,
    remainingProtein: 80,
    targetCalories: 2000,
    targetProtein: 150,
    currentWeight: 75,
    goal: 'general_vitality',
  );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/meal_type.dart';

/// Picks the next meal slot based on time of day (demo-friendly heuristic).
MealType nextMealTypeFor(DateTime now) {
  final hour = now.hour;
  if (hour < 11) return MealType.breakfast;
  if (hour < 15) return MealType.lunch;
  if (hour < 20) return MealType.dinner;
  return MealType.snack;
}

final nextMealTypeProvider = Provider<MealType>(
  (ref) => nextMealTypeFor(DateTime.now()),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/meal_type.dart';

/// Meal slots the user has explicitly confirmed as eaten today.
///
/// Must start empty — never pre-confirm plan/demo meals (P56 phantom 320 kcal).
final confirmedMealsProvider = StateProvider<Set<MealType>>(
  (ref) => <MealType>{},
);

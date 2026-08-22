import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/meal_type.dart';

/// Demo confirmed meals for home quick stats.
final confirmedMealsProvider = StateProvider<Set<MealType>>(
  (ref) => {MealType.breakfast},
);

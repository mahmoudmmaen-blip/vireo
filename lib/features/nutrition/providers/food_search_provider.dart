import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/food_item.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';

final foodSearchProvider =
    FutureProvider.family<List<FoodItem>, String>((ref, query) async {
  return ref.read(nutritionRepositoryProvider).searchFoodItems(query);
});

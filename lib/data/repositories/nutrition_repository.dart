import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/data/demo/nutrition_demo_catalog.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/data/models/food_item.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/models/recipe.dart';
import 'package:vireo/data/repositories/fridge_scan_repository.dart';

class NutritionRepository {
  const NutritionRepository();

  static const basicMonthlyLimit = FridgeScanRepository.basicMonthlyLimit;

  Future<List<FoodItem>> searchFoodItems(String query) async {
    if (query.trim().length < 2) return [];
    if (!SupabaseService.isInitialized) return _demoFoodItems(query);

    try {
      final pattern = '%${query.trim()}%';
      final rows = await SupabaseService.client
          .from('food_items')
          .select()
          .or('name_en.ilike.$pattern,name_ar.ilike.$pattern')
          .limit(8);

      return (rows as List<dynamic>)
          .map((r) => FoodItem.fromJson(Map<String, dynamic>.from(r)))
          .toList();
    } catch (_) {
      return _demoFoodItems(query);
    }
  }

  List<FoodItem> _demoFoodItems(String query) {
    const demo = [
      FoodItem(id: '1', nameEn: 'Eggs', nameAr: 'بيض'),
      FoodItem(id: '2', nameEn: 'Chicken breast', nameAr: 'صدر دجاج'),
      FoodItem(id: '3', nameEn: 'Tomatoes', nameAr: 'طماطم'),
      FoodItem(id: '4', nameEn: 'Rice', nameAr: 'أرز'),
      FoodItem(id: '5', nameEn: 'Chickpeas', nameAr: 'حمص'),
    ];
    final q = query.toLowerCase();
    return demo
        .where(
          (f) =>
              f.nameEn.toLowerCase().contains(q) ||
              f.nameAr.contains(query),
        )
        .toList();
  }

  Future<List<Recipe>> suggestRecipes({
    required List<String> ingredients,
    String? scanId,
  }) async {
    if (!SupabaseService.isInitialized) {
      return _demoSuggestions();
    }

    try {
      final response = await SupabaseService.client.functions.invoke(
        AppConfig.suggestRecipesFunctionName,
        body: {
          'ingredients': ingredients,
          if (scanId != null) 'scan_id': scanId,
        },
      );

      if (response.status >= 400) {
        throw const NutritionException('Recipe suggestion failed.');
      }

      final data = Map<String, dynamic>.from(response.data as Map);
      final list = data['recipes'] as List? ?? [];
      return list
          .map((r) => Recipe.fromJson(Map<String, dynamic>.from(r)))
          .toList();
    } catch (_) {
      return _demoSuggestions();
    }
  }

  List<Recipe> _demoSuggestions() => NutritionDemoCatalog.fridgeQuickMeals;

  Future<int?> remainingScansThisMonth({required bool isPremium}) async {
    if (isPremium) return null;
    if (!SupabaseService.isInitialized) return basicMonthlyLimit;

    try {
      final userId = SupabaseService.auth.currentUser?.id;
      if (userId == null) return basicMonthlyLimit;

      final start = DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
      final rows = await SupabaseService.client
          .from('fridge_scans')
          .select('id')
          .eq('user_id', userId)
          .gte('created_at', start.toIso8601String());

      final used = (rows as List).length;
      return (basicMonthlyLimit - used).clamp(0, basicMonthlyLimit);
    } catch (_) {
      return basicMonthlyLimit;
    }
  }
}

class NutritionException implements Exception {
  const NutritionException(this.message);
  final String message;

  @override
  String toString() => message;
}

final nutritionRepositoryProvider = Provider<NutritionRepository>(
  (ref) => const NutritionRepository(),
);

final remainingFridgeScansProvider = FutureProvider<int?>((ref) async {
  final sub = await ref.watch(subscriptionProvider.future);
  if (sub.canUseUnlimitedFridgeScans) return null;
  return ref.read(nutritionRepositoryProvider).remainingScansThisMonth(
        isPremium: false,
      );
});

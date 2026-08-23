import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/meal_type.dart';

/// Controls the bottom-nav tab index in [MainShell].
class ShellTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void goTo(int index) => state = index.clamp(0, 4);

  void goHome() => state = 0;
  void goWorkout() => state = 1;
  void goNutrition({MealType? mealTab}) {
    if (mealTab != null) {
      ref.read(nutritionInitialTabProvider.notifier).state = mealTab;
    }
    state = 2;
  }

  void goProgress() => state = 3;
  void goProfile() => state = 4;
}

final shellTabIndexProvider =
    NotifierProvider<ShellTabIndexNotifier, int>(ShellTabIndexNotifier.new);

/// When set, NutritionScreen selects this meal tab on next build.
final nutritionInitialTabProvider = StateProvider<MealType?>((ref) => null);

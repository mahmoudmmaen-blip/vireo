import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/data/models/meal_type.dart';

/// Controls the bottom-nav / shell tab index in [MainShell].
///
/// Indices: 0 Home, 1 Food (Nutrition), 2 Walk, 3 Workout, 4 Progress, 5 Profile, 6 Diary.
class ShellTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void goTo(int index) => state = index.clamp(0, 6);

  void goHome() => state = 0;
  void goNutrition({MealType? mealTab}) {
    if (mealTab != null) {
      ref.read(nutritionInitialTabProvider.notifier).state = mealTab;
    }
    state = 1;
  }

  void goWalk() => state = 2;
  void goWorkout() => state = 3;
  void goProgress() => state = 4;
  void goProfile() => state = 5;
  void goDiary() => state = 6;
}

final shellTabIndexProvider =
    NotifierProvider<ShellTabIndexNotifier, int>(ShellTabIndexNotifier.new);

/// When set, NutritionScreen selects this meal tab on next build.
final nutritionInitialTabProvider = StateProvider<MealType?>((ref) => null);

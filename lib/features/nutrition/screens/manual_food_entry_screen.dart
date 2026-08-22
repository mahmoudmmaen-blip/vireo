import 'package:flutter/material.dart';
import 'package:vireo/features/nutrition/screens/ingredients_confirm_screen.dart';

/// Fallback when vision fails or the user prefers typing ingredients.
class ManualFoodEntryScreen extends StatelessWidget {
  const ManualFoodEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IngredientsConfirmScreen(
      initialIngredients: const [],
      showManualHint: true,
    );
  }
}

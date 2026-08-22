import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/features/nutrition/providers/fridge_scan_provider.dart';
import 'package:vireo/features/nutrition/screens/recipe_suggestions_screen.dart';
import 'package:vireo/features/nutrition/widgets/ingredient_editor.dart';

class IngredientsConfirmScreen extends ConsumerStatefulWidget {
  const IngredientsConfirmScreen({
    super.key,
    this.initialIngredients,
    this.showManualHint = false,
  });

  final List<String>? initialIngredients;
  final bool showManualHint;

  @override
  ConsumerState<IngredientsConfirmScreen> createState() =>
      _IngredientsConfirmScreenState();
}

class _IngredientsConfirmScreenState extends ConsumerState<IngredientsConfirmScreen> {
  late List<String> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients = widget.initialIngredients ??
        List<String>.from(ref.read(fridgeScanFlowProvider).ingredients);
  }

  Future<void> _confirm() async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).nutritionNoIngredients)),
      );
      return;
    }

    ref.read(fridgeScanFlowProvider.notifier).setIngredients(_ingredients);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeSuggestionsScreen(ingredients: _ingredients),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionConfirmIngredients)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.showManualHint
                ? l10n.nutritionManualEntryHint
                : l10n.nutritionIngredientsHint,
          ),
          const SizedBox(height: 16),
          IngredientEditor(
            ingredients: _ingredients,
            onChanged: (items) => setState(() => _ingredients = items),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _confirm,
            child: Text(l10n.nutritionGetRecipes),
          ),
        ],
      ),
    );
  }
}

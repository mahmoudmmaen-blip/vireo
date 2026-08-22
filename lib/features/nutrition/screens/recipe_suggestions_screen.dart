import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';
import 'package:vireo/features/nutrition/providers/fridge_scan_provider.dart';
import 'package:vireo/features/nutrition/widgets/recipe_suggestion_card.dart';

class RecipeSuggestionsScreen extends ConsumerWidget {
  const RecipeSuggestionsScreen({super.key, required this.ingredients});

  final List<String> ingredients;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider).languageCode;
    final scanId = ref.watch(fridgeScanFlowProvider).scanId;

    final recipesAsync = ref.watch(
      FutureProvider((ref) async {
        return ref.read(nutritionRepositoryProvider).suggestRecipes(
              ingredients: ingredients,
              scanId: scanId,
            );
      }),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionRecipeSuggestions)),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.authErrorGeneric)),
        data: (recipes) {
          if (recipes.isEmpty) {
            return Center(child: Text(l10n.nutritionNoRecipesFound));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(l10n.nutritionRecipeSuggestionsSubtitle),
              const SizedBox(height: 16),
              ...recipes.map(
                (r) => RecipeSuggestionCard(recipe: r, locale: locale),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/repositories/meal_plan_repository.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';
import 'package:vireo/features/nutrition/screens/fridge_scan_screen.dart';
import 'package:vireo/features/nutrition/screens/manual_food_entry_screen.dart';
import 'package:vireo/features/nutrition/widgets/meal_card.dart';
import 'package:vireo/features/nutrition/widgets/scan_quota_banner.dart';
import 'package:vireo/features/subscription/premium_access.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final remainingAsync = ref.watch(remainingFridgeScansProvider);

    return DefaultTabController(
      length: 4,
      child: FeatureScaffold(
        title: l10n.nutritionTitle,
        actions: [
          IconButton(
            tooltip: l10n.nutritionManualEntry,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ManualFoodEntryScreen()),
            ),
          ),
        ],
        body: Column(
          children: [
            remainingAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (remaining) {
                if (remaining == null) return const SizedBox.shrink();
                return ScanQuotaBanner(remaining: remaining);
              },
            ),
            TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: l10n.nutritionTabBreakfast),
                Tab(text: l10n.nutritionTabLunch),
                Tab(text: l10n.nutritionTabDinner),
                Tab(text: l10n.nutritionTabSnack),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _MealTab(mealType: MealType.breakfast),
                  _MealTab(mealType: MealType.lunch),
                  _MealTab(mealType: MealType.dinner),
                  _MealTab(mealType: MealType.snack),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  final sub = ref.read(subscriptionProvider).valueOrNull;
                  if (sub != null &&
                      !sub.canUseUnlimitedFridgeScans &&
                      (remainingAsync.valueOrNull ?? 1) <= 0) {
                    requirePremiumAccess(
                      context,
                      ref,
                      paywallContext: paywallContextForSnapshot(sub),
                    );
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FridgeScanScreen()),
                  );
                },
                icon: const Icon(Icons.kitchen_outlined),
                label: Text(l10n.nutritionScanFridge),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealTab extends ConsumerWidget {
  const _MealTab({required this.mealType});

  final MealType mealType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mealsAsync = ref.watch(todayMealsProvider);

    return mealsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(child: Text(l10n.authErrorGeneric)),
          data: (meals) {
            final entry = meals.where((m) => m.mealType == mealType).firstOrNull;
            if (entry == null) {
              return Center(child: Text(l10n.nutritionNoMealPlanned));
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [MealCard(recipe: entry.recipe, mealType: mealType)],
            );
          },
        );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}

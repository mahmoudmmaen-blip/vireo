import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/core/widgets/language_selector.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/screens/fridge_scan_screen.dart';
import 'package:vireo/features/nutrition/screens/manual_food_entry_screen.dart';
import 'package:vireo/features/ai_nutrition/widgets/quick_ai_scanner_card.dart';
import 'package:vireo/features/nutrition/widgets/daily_calorie_goal_card.dart';
import 'package:vireo/features/nutrition/widgets/fridge_scan_banner.dart';
import 'package:vireo/features/nutrition/widgets/meal_builder_panel.dart';
import 'package:vireo/features/nutrition/widgets/meal_card.dart';
import 'package:vireo/features/subscription/premium_access.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static int _indexFor(MealType? type) => switch (type) {
        MealType.breakfast => 0,
        MealType.lunch => 1,
        MealType.dinner => 2,
        MealType.snack => 3,
        null => 0,
      };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final remainingAsync = ref.watch(remainingFridgeScansProvider);
    final remaining = remainingAsync.valueOrNull ?? NutritionRepository.basicMonthlyLimit;

    ref.listen<MealType?>(nutritionInitialTabProvider, (prev, next) {
      if (next == null) return;
      final index = _indexFor(next);
      if (_tabController.index != index) {
        _tabController.animateTo(index);
      }
      ref.read(nutritionInitialTabProvider.notifier).state = null;
    });

    // Apply pending tab on first build after navigation.
    final pending = ref.read(nutritionInitialTabProvider);
    if (pending != null && _tabController.index != _indexFor(pending)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _tabController.animateTo(_indexFor(pending));
        ref.read(nutritionInitialTabProvider.notifier).state = null;
      });
    }

    return FeatureScaffold(
      title: l10n.nutritionTitle,
      actions: [
        IconButton(
          tooltip: l10n.nutritionManualEntry,
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ManualFoodEntryScreen()),
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.only(end: 4),
          child: LanguageSelector(compact: true),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: const QuickAiScannerCard(),
          ),
          FridgeScanBanner(
            remaining: remaining,
            onScan: () => _openFridgeScan(context, remaining),
          ),
          const DailyCalorieGoalCard(),
          TabBar(
            controller: _tabController,
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
              controller: _tabController,
              children: [
                _MealTab(mealType: MealType.breakfast),
                _MealTab(mealType: MealType.lunch),
                _MealTab(mealType: MealType.dinner),
                _MealTab(mealType: MealType.snack),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openFridgeScan(BuildContext context, int remaining) {
    final sub = ref.read(subscriptionProvider).valueOrNull;
    if (sub != null &&
        !sub.canUseUnlimitedFridgeScans &&
        remaining <= 0) {
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
  }
}

class _MealTab extends ConsumerWidget {
  const _MealTab({required this.mealType});

  final MealType mealType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mealsAsync = ref.watch(effectiveTodayMealsProvider);

    return mealsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text(l10n.authErrorGeneric)),
      data: (meals) {
        final meal = meals.where((m) => m.mealType == mealType).firstOrNull;
        if (meal == null) {
          return Center(child: Text(l10n.nutritionNoMealPlanned));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MealCard(entry: meal),
            MealBuilderPanel(mealType: mealType),
          ],
        );
      },
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}

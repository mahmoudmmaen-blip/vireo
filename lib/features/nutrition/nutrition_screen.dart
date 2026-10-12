import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/core/widgets/language_selector.dart';
import 'package:vireo/core/widgets/vireo_ad_widgets.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/data/repositories/nutrition_repository.dart';
import 'package:vireo/features/nutrition/providers/demo_meal_overrides_provider.dart';
import 'package:vireo/features/nutrition/screens/food_search_screen.dart';
import 'package:vireo/features/nutrition/screens/fridge_scan_screen.dart';
import 'package:vireo/features/nutrition/screens/manual_food_entry_screen.dart';
import 'package:vireo/features/ai_nutrition/widgets/quick_ai_scanner_card.dart';
import 'package:vireo/features/nutrition/widgets/daily_calorie_goal_card.dart';
import 'package:vireo/features/nutrition/widgets/fridge_scan_banner.dart';
import 'package:vireo/features/nutrition/widgets/meal_builder_panel.dart';
import 'package:vireo/features/nutrition/widgets/meal_card.dart';
import 'package:vireo/features/nutrition/widgets/meal_quick_relog_row.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/premium_access.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _lastRamadan = false;

  static int _indexFor(MealType? type, bool isRamadan) {
    if (isRamadan) {
      return switch (type) {
        MealType.breakfast => 0, // Suhoor
        MealType.lunch => 1,     // Iftar
        MealType.dinner => 1,    // Iftar
        MealType.snack => 2,     // Post-Iftar snack
        null => 0,
      };
    }
    return switch (type) {
      MealType.breakfast => 0,
      MealType.lunch => 1,
      MealType.dinner => 2,
      MealType.snack => 3,
      null => 0,
    };
  }

  @override
  void initState() {
    super.initState();
    _lastRamadan = false;
    _tabController = TabController(length: 4, vsync: this);
  }

  void _ensureTabController(bool isRamadan) {
    if (_lastRamadan != isRamadan) {
      _lastRamadan = isRamadan;
      final oldIndex = _tabController.index;
      _tabController.dispose();
      final newLength = isRamadan ? 3 : 4;
      _tabController = TabController(
        length: newLength,
        initialIndex: oldIndex.clamp(0, newLength - 1),
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;
    _ensureTabController(isRamadan);

    final isPro = ref.watch(isProUserProvider);
    final remainingAsync = ref.watch(remainingFridgeScansProvider);
    final remaining = remainingAsync.valueOrNull ?? NutritionRepository.basicMonthlyLimit;

    ref.listen<MealType?>(nutritionInitialTabProvider, (prev, next) {
      if (next == null) return;
      final index = _indexFor(next, isRamadan);
      if (_tabController.index != index) {
        _tabController.animateTo(index);
      }
      ref.read(nutritionInitialTabProvider.notifier).state = null;
    });

    // Apply pending tab on first build after navigation.
    final pending = ref.read(nutritionInitialTabProvider);
    if (pending != null && _tabController.index != _indexFor(pending, isRamadan)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _tabController.animateTo(_indexFor(pending, isRamadan));
        ref.read(nutritionInitialTabProvider.notifier).state = null;
      });
    }

    return FeatureScaffold(
      title: l10n.nutritionTitle,
      actions: [
        IconButton(
          tooltip: isAr ? 'البحث في قاعدة الأطعمة' : 'Search Food Database',
          icon: const Icon(Icons.search_rounded),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FoodSearchScreen()),
          ),
        ),
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: QuickAiScannerCard(),
                ),
                if (FeatureGates.shouldShowUpsellBanners(isPro: isPro))
                  FridgeScanBanner(
                    remaining: remaining,
                    onScan: () => _openFridgeScan(context, remaining),
                  ),
                const DailyCalorieGoalCard(),
                const MealQuickRelogRow(),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: isRamadan
                    ? [
                        Tab(text: isAr ? 'سحور' : 'Suhoor'),
                        Tab(text: isAr ? 'فطار' : 'Iftar'),
                        Tab(text: isAr ? 'سناك بعد الفطار' : 'Post-Iftar Snack'),
                      ]
                    : [
                        Tab(text: l10n.nutritionTabBreakfast),
                        Tab(text: l10n.nutritionTabLunch),
                        Tab(text: l10n.nutritionTabDinner),
                        Tab(text: l10n.nutritionTabSnack),
                      ],
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: isRamadan
              ? const [
                  _MealTab(mealType: MealType.breakfast), // Maps to Suhoor
                  _MealTab(mealType: MealType.lunch),     // Maps to Iftar
                  _MealTab(mealType: MealType.snack),     // Maps to Post-Iftar snack
                ]
              : const [
                  _MealTab(mealType: MealType.breakfast),
                  _MealTab(mealType: MealType.lunch),
                  _MealTab(mealType: MealType.dinner),
                  _MealTab(mealType: MealType.snack),
                ],
        ),
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
      error: (error, stackTrace) => Center(child: Text(l10n.authErrorGeneric)),
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
            const SizedBox(height: 12),
            const VireoNativeAdCard(),
          ],
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this.tabBar, {required this.color});

  final TabBar tabBar;
  final Color color;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: color,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || color != oldDelegate.color;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}

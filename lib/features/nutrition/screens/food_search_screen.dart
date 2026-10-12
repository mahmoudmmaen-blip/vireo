import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _results = [];
  List<String> _recentFoodIds = [];
  Set<String> _favoriteFoodIds = {};
  String? _selectedCategory;
  bool _isLoading = false;

  static const _recentPrefsKey = 'vireo_food_search_recents';
  static const _favoritesPrefsKey = 'vireo_food_search_favorites';

  static const _categories = [
    (id: 'all', labelAr: 'الكل', labelEn: 'All'),
    (id: 'egypt', labelAr: 'مصر 🇪🇬', labelEn: 'Egypt 🇪🇬'),
    (id: 'restaurant', labelAr: 'مطاعم 🍽️', labelEn: 'Restaurants 🍽️'),
    (id: 'drinks', labelAr: 'مشروبات 🥤', labelEn: 'Drinks 🥤'),
    (id: 'sweets', labelAr: 'حلويات 🍰', labelEn: 'Desserts 🍰'),
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentsAndFavorites();
    _performSearch('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentsAndFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentFoodIds = prefs.getStringList(_recentPrefsKey) ?? [];
      _favoriteFoodIds = (prefs.getStringList(_favoritesPrefsKey) ?? []).toSet();
    });
  }

  Future<void> _toggleFavorite(String foodId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteFoodIds.contains(foodId)) {
        _favoriteFoodIds.remove(foodId);
      } else {
        _favoriteFoodIds.add(foodId);
      }
    });
    await prefs.setStringList(_favoritesPrefsKey, _favoriteFoodIds.toList());
  }

  Future<void> _addToRecents(String foodId) async {
    final prefs = await SharedPreferences.getInstance();
    final updated = [foodId, ..._recentFoodIds.where((id) => id != foodId)].take(10).toList();
    _recentFoodIds = updated;
    await prefs.setStringList(_recentPrefsKey, updated);
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);
    final repo = FoodDbRepository.instance;
    await repo.load();

    List<FoodItem> items;
    if (query.trim().isEmpty) {
      if (_selectedCategory == 'restaurant') {
        items = (await repo.load()).where((f) => f.source.name.startsWith('restaurant_')).toList();
      } else if (_selectedCategory == 'sweets') {
        items = (await repo.load()).where((f) => f.aliases.any((a) => a.contains('حلو') || a.contains('sweet')) || f.id.contains('dessert') || f.id.contains('konafa') || f.id.contains('basbousa') || f.id.contains('qata')).toList();
      } else if (_selectedCategory == 'drinks') {
        items = (await repo.load()).where((f) => f.aliases.any((a) => a.contains('عصير') || a.contains('مشروب') || a.contains('drink')) || f.id.contains('tea') || f.id.contains('coffee') || f.id.contains('juice')).toList();
      } else if (_selectedCategory == 'egypt') {
        items = (await repo.load()).where((f) => f.source.name == 'egyptian_food_db' || f.source.name.startsWith('egypt_')).toList();
      } else {
        items = await repo.search('', limit: 50);
      }
    } else {
      items = await repo.search(query, limit: 50);
      if (_selectedCategory != null && _selectedCategory != 'all') {
        if (_selectedCategory == 'restaurant') {
          items = items.where((f) => f.source.name.startsWith('restaurant_')).toList();
        } else if (_selectedCategory == 'drinks') {
          items = items.where((f) => f.aliases.any((a) => a.contains('عصير') || a.contains('مشروب')) || f.id.contains('drink') || f.id.contains('juice') || f.id.contains('tea') || f.id.contains('coffee')).toList();
        } else if (_selectedCategory == 'sweets') {
          items = items.where((f) => f.aliases.any((a) => a.contains('حلو')) || f.id.contains('dessert') || f.id.contains('sweet')).toList();
        } else if (_selectedCategory == 'egypt') {
          items = items.where((f) => f.source.name == 'egyptian_food_db' || f.source.name.startsWith('egypt_')).toList();
        }
      }
    }

    if (mounted) {
      setState(() {
        _results = items;
        _isLoading = false;
      });
    }
  }

  void _onSelectFood(FoodItem food) {
    _addToRecents(food.id);
    Navigator.of(context).pop(food);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    final recentItems = _recentFoodIds
        .map((id) => FoodDbRepository.instance.byId(id))
        .whereType<FoodItem>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'قاعدة الأطعمة والمطاعم' : 'Food & Restaurant Database'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search input box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: isAr
                    ? 'ابحث باسم الأكلة (فول، شاورما، ماك، كشري...)'
                    : 'Search food or restaurant (koshari, shawarma, KFC...)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colors.line),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _performSearch,
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = (_selectedCategory ?? 'all') == cat.id;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: FilterChip(
                    label: Text(isAr ? cat.labelAr : cat.labelEn),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? cat.id : 'all';
                      });
                      _performSearch(_searchController.text);
                    },
                    selectedColor: colors.ember.withValues(alpha: 0.15),
                    checkmarkColor: colors.ember,
                    labelStyle: TextStyle(
                      color: isSelected ? colors.ember : colors.text,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Recents Bar (when search query is empty)
          if (_searchController.text.isEmpty && recentItems.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  isAr ? 'عناصر بحثت عنها مؤخراً' : 'Recently Viewed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textMute,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recentItems.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final food = recentItems[i];
                  return ActionChip(
                    avatar: const Icon(Icons.history, size: 14),
                    label: Text(
                      isAr ? food.nameAr : (food.nameEn.isNotEmpty ? food.nameEn : food.nameAr),
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () => _onSelectFood(food),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
          ],

          const Divider(height: 1),

          // Result List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off, size: 48, color: colors.textMute),
                            const SizedBox(height: 10),
                            Text(
                              isAr ? 'لا توجد نتائج مطابقة' : 'No matching foods found',
                              style: TextStyle(color: colors.textMute, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final food = _results[index];
                          final isFav = _favoriteFoodIds.contains(food.id);
                          final isRestaurant = food.source.name.startsWith('restaurant_');
                          final portionsDesc = food.commonPortions.isNotEmpty
                              ? food.commonPortions.map((p) => '${isAr ? p.nameAr : p.nameEn} (${p.grams.round()}g)').join(', ')
                              : '100g';

                          return ListTile(
                            onTap: () => _onSelectFood(food),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: CircleAvatar(
                              backgroundColor: isRestaurant
                                  ? colors.ember.withValues(alpha: 0.12)
                                  : colors.surface,
                              child: Text(
                                isRestaurant ? '🍽️' : '🥗',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    isAr ? food.nameAr : (food.nameEn.isNotEmpty ? food.nameEn : food.nameAr),
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isRestaurant) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: colors.ember.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isAr ? 'تقديري' : 'Approx.',
                                      style: TextStyle(
                                        color: colors.ember,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  '${food.per100g.kcal.round()} سعرة / 100 جم  ·  بروتين: ${food.per100g.protein.toStringAsFixed(1)} جم  ·  كارب: ${food.per100g.carbs.toStringAsFixed(1)} جم',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: colors.textMute,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  portionsDesc,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: colors.textMute.withValues(alpha: 0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? colors.danger : colors.textMute,
                                size: 20,
                              ),
                              onPressed: () => _toggleFavorite(food.id),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/auth/services/save_progress_prompt.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';
import 'package:vireo/features/nutrition/data/meal_resolution_service.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';

class MealReviewScreen extends ConsumerStatefulWidget {
  const MealReviewScreen({super.key, required this.draft});

  final MealScanDraft draft;

  static Future<bool?> open(BuildContext context, MealScanDraft draft) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => MealReviewScreen(draft: draft)),
    );
  }

  @override
  ConsumerState<MealReviewScreen> createState() => _MealReviewScreenState();
}

class _MealReviewScreenState extends ConsumerState<MealReviewScreen> {
  late List<ResolvedMealLine> _lines;
  late MealType _slot;
  final _resolver = MealResolutionService(FoodDbRepository.instance);

  @override
  void initState() {
    super.initState();
    _lines = List.of(widget.draft.lines);
    _slot = _mealSlotForNow();
  }

  MealType _mealSlotForNow() {
    final h = DateTime.now().hour;
    if (h < 11) return MealType.breakfast;
    if (h < 16) return MealType.lunch;
    if (h < 21) return MealType.dinner;
    return MealType.snack;
  }

  double get _kcal => _lines.fold(0.0, (s, l) => s + l.kcal);
  double get _p => _lines.fold(0.0, (s, l) => s + l.protein);
  double get _c => _lines.fold(0.0, (s, l) => s + l.carbs);
  double get _f => _lines.fold(0.0, (s, l) => s + l.fat);

  Future<void> _save() async {
    final result = MealScanDraft(
      lines: _lines,
      imageBytes: widget.draft.imageBytes,
    ).toAnalysisResult();
    await ref.read(aiMealLogProvider.notifier).save(result);
    await recordSuccessfulMealScan();
    await _resolver.rememberLines(_lines);
    await ref.read(mealRecentProvider.notifier).push(_lines);
    ref.read(confirmedMealsProvider.notifier).update((s) => {...s, _slot});
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.aiScanSavedSnack)),
    );
    Navigator.of(context).pop(true);
  }

  Future<void> _saveFavorite() async {
    await ref.read(mealFavoritesProvider.notifier).add(_lines);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).mealFavoriteSaved)),
    );
  }

  Future<void> _addFood() async {
    final picked = await showModalBottomSheet<FoodItem>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const _FoodSearchSheet(),
    );
    if (picked == null) return;
    final oil = FoodDbRepository.instance.byId('sunflower_oil');
    final grams = picked.commonPortions.isNotEmpty
        ? picked.commonPortions.first.grams
        : 100.0;
    setState(() {
      _lines.add(
        resolveLine(
          scanned: ScannedFoodItem(
            nameAr: picked.nameAr,
            nameEn: picked.nameEn,
            foodIdGuess: picked.id,
            estimatedGrams: grams,
            cookingMethod: CookingMethod.fromString(picked.state),
            confidence: 1,
          ),
          food: picked,
          oilFood: oil,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final nutrition = ref.watch(todayNutritionProvider(locale));
    final remaining = nutrition.remainingKcal;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.mealReviewTitle),
        actions: [
          IconButton(
            tooltip: l10n.mealFavoriteSave,
            icon: const Icon(Icons.star_outline),
            onPressed: _lines.isEmpty ? null : _saveFavorite,
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.draft.imageBytes.isNotEmpty)
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Image.memory(widget.draft.imageBytes, fit: BoxFit.cover),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(VSpace.md),
              itemCount: _lines.length + 1,
              itemBuilder: (context, i) {
                if (i == _lines.length) {
                  return TextButton.icon(
                    onPressed: _addFood,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.mealReviewAddItem),
                  );
                }
                final line = _lines[i];
                return Dismissible(
                  key: ValueKey('${line.nameEn}_$i'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => setState(() => _lines.removeAt(i)),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: colors.danger,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: _LineCard(
                    line: line,
                    locale: locale,
                    onChanged: (next) => setState(() => _lines[i] = next),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.line)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(l10n.mealReviewSlot),
                      const SizedBox(width: 8),
                      DropdownButton<MealType>(
                        value: _slot,
                        items: MealType.values
                            .map(
                              (m) => DropdownMenuItem(
                                value: m,
                                child: Text(_slotLabel(l10n, m)),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _slot = v);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_kcal.round()} kcal',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      Text(
                        'P ${_p.round()} · C ${_c.round()} · F ${_f.round()}',
                        style: TextStyle(color: colors.textMute, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.mealReviewRemaining(remaining),
                    style: TextStyle(color: colors.textMute, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: _lines.isEmpty ? null : _save,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(l10n.aiScanSaveToLog),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _slotLabel(AppLocalizations l10n, MealType m) => switch (m) {
        MealType.breakfast => l10n.nutritionTabBreakfast,
        MealType.lunch => l10n.nutritionTabLunch,
        MealType.dinner => l10n.nutritionTabDinner,
        MealType.snack => l10n.nutritionTabSnack,
      };
}

class _LineCard extends StatelessWidget {
  const _LineCard({
    required this.line,
    required this.locale,
    required this.onChanged,
  });

  final ResolvedMealLine line;
  final String locale;
  final ValueChanged<ResolvedMealLine> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final oil = FoodDbRepository.instance.byId('sunflower_oil');

    return VireoCard(
      padding: const EdgeInsets.all(VSpace.sm + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  locale == 'ar' ? line.nameAr : line.nameEn,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              if (line.isEstimated)
                _Badge(l10n.mealReviewEstimated, colors.gold),
              if (line.confidence < 0.6) ...[
                const SizedBox(width: 6),
                _Badge(l10n.mealReviewCheckAmount, colors.ember),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onChanged(rescaleLine(line, (line.grams - 10).clamp(10, 2000)));
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('${line.grams.round()} g',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onChanged(rescaleLine(line, (line.grams + 10).clamp(10, 2000)));
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
              Expanded(
                child: Slider(
                  value: line.grams.clamp(10, 500),
                  min: 10,
                  max: 500,
                  onChanged: (v) => onChanged(rescaleLine(line, v)),
                ),
              ),
            ],
          ),
          if (line.portions.isNotEmpty)
            Wrap(
              spacing: 6,
              children: [
                for (final p in line.portions.take(4))
                  ActionChip(
                    label: Text(p.label(locale)),
                    onPressed: () => onChanged(rescaleLine(line, p.grams)),
                  ),
              ],
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: [
              for (final m in [
                CookingMethod.raw,
                CookingMethod.boiled,
                CookingMethod.grilled,
                CookingMethod.fried,
                CookingMethod.baked,
              ])
                ChoiceChip(
                  label: Text(m.name),
                  selected: line.cookingMethod == m,
                  onSelected: (_) => onChanged(
                    recomputeWithMethod(line, m, oilFood: oil),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${line.kcal.round()} kcal · P ${line.protein.round()} · C ${line.carbs.round()} · F ${line.fat.round()}',
            style: TextStyle(color: colors.textMute, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _FoodSearchSheet extends StatefulWidget {
  const _FoodSearchSheet();

  @override
  State<_FoodSearchSheet> createState() => _FoodSearchSheetState();
}

class _FoodSearchSheetState extends State<_FoodSearchSheet> {
  final _ctrl = TextEditingController();
  List<FoodItem> _results = [];

  @override
  void initState() {
    super.initState();
    _search('');
  }

  Future<void> _search(String q) async {
    final r = await FoodDbRepository.instance.search(q);
    if (mounted) setState(() => _results = r);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (context, scroll) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: l10n.mealReviewSearchFood,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _search,
            ),
            Expanded(
              child: ListView.builder(
                controller: scroll,
                itemCount: _results.length,
                itemBuilder: (context, i) {
                  final f = _results[i];
                  return ListTile(
                    title: Text(f.displayName(locale)),
                    subtitle: Text('${f.per100g.kcal.round()} kcal / 100g'),
                    onTap: () => Navigator.pop(context, f),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

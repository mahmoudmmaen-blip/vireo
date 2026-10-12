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
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _askPlateSizeOnce());
  }

  Future<void> _askPlateSizeOnce() async {
    if (!mounted) return;
    if (ref.read(plateSizeProvider) != null) return;
    final l10n = AppLocalizations.of(context);
    final picked = await showDialog<PlateSize>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.plateSizeAskTitle),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, PlateSize.small),
            child: Text(l10n.plateSizeSmall),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, PlateSize.medium),
            child: Text(l10n.plateSizeMedium),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, PlateSize.large),
            child: Text(l10n.plateSizeLarge),
          ),
        ],
      ),
    );
    if (picked != null) {
      await ref.read(plateSizeProvider.notifier).setSize(picked);
    }
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
    // Force dependent UIs (Home eaten, macros, Nutrition log) to rebuild.
    ref.invalidate(todayNutritionProvider);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        persist: false,
        content: Text(l10n.aiScanSavedSnack),
      ),
    );
    final isPro = ref.read(isProUserProvider);
    Navigator.of(context).pop(true);
    await AdService.instance.showInterstitialIfEligible(isPro: isPro);
  }

  Future<void> _saveFavorite() async {
    await ref.read(mealFavoritesProvider.notifier).add(_lines);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: const Duration(seconds: 3), persist: false, content: Text(AppLocalizations.of(context).mealFavoriteSaved)),
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
                        l10n.mealReviewCaloriesFormat(_kcal.round()),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      Text(
                        locale.startsWith('ar')
                            ? 'بروتين ${_p.round()} · كارب ${_c.round()} · دهون ${_f.round()}'
                            : 'P ${_p.round()} · C ${_c.round()} · F ${_f.round()}',
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
                  locale.startsWith('ar')
                      ? line.nameAr
                      : (line.nameEn.isNotEmpty ? line.nameEn : line.nameAr),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              if (line.isEstimated)
                _Badge(l10n.mealReviewEstimated, colors.gold),
              if (line.confidence < 0.6 || line.isUnsure) ...[
                const SizedBox(width: 6),
                _Badge(l10n.mealClarificationTitle, colors.ember),
              ],
            ],
          ),
          if (line.confidence < 0.6 || line.isUnsure) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.ember.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.ember.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, size: 14, color: colors.ember),
                      const SizedBox(width: 4),
                      Text(
                        locale == 'ar' ? 'تأكيد سريع:' : 'Quick clarification:',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.ember,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildClarificationChips(context, line, locale, onChanged, oil),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          const SizedBox(height: 10),
          // ── Grams / Unit selection ──
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onChanged(rescaleLine(line, (line.grams - 10).clamp(10, 2000)));
                },
                icon: const Icon(Icons.remove_circle_outline, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(VRadius.sm),
                  border: Border.all(color: colors.line),
                ),
                child: Text(
                  '${line.grams.round()} g',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onChanged(rescaleLine(line, (line.grams + 10).clamp(10, 2000)));
                },
                icon: const Icon(Icons.add_circle_outline, size: 20),
              ),
              Expanded(
                child: Slider(
                  value: line.grams.clamp(10, 500),
                  min: 10,
                  max: 500,
                  divisions: 49,
                  onChanged: (v) => onChanged(rescaleLine(line, v)),
                ),
              ),
            ],
          ),
          // Unit Chips: Common portions plus localized quick units "حبة", "حفنة"
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 6),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (line.portions.isNotEmpty)
                  for (final p in line.portions.take(3))
                    ActionChip(
                      visualDensity: VisualDensity.compact,
                      label: Text('${p.label(locale)} (${p.grams.round()}g)'),
                      onPressed: () => onChanged(rescaleLine(line, p.grams)),
                    ),
                // "حبة" (Piece / ~80g)
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  label: Text(locale.startsWith('ar') ? 'حبة (80g)' : 'Piece (80g)'),
                  onPressed: () => onChanged(rescaleLine(line, 80)),
                ),
                // "حفنة" (Handful / ~35g)
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  label: Text(locale.startsWith('ar') ? 'حفنة (35g)' : 'Handful (35g)'),
                  onPressed: () => onChanged(rescaleLine(line, 35)),
                ),
                // Standard 100g
                ActionChip(
                  visualDensity: VisualDensity.compact,
                  label: const Text('100g'),
                  onPressed: () => onChanged(rescaleLine(line, 100)),
                ),
              ],
            ),
          ),
          // ── Cooking Method Chips with Delta (e.g. fried adds oil delta) ──
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                _CookingMethodDeltaChip(
                  label: l10n.mealReviewCookingRaw,
                  method: CookingMethod.raw,
                  isSelected: line.cookingMethod == CookingMethod.raw,
                  onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.raw, oilFood: oil)),
                ),
                _CookingMethodDeltaChip(
                  label: l10n.mealReviewCookingBoiled,
                  method: CookingMethod.boiled,
                  isSelected: line.cookingMethod == CookingMethod.boiled,
                  onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.boiled, oilFood: oil)),
                ),
                _CookingMethodDeltaChip(
                  label: l10n.mealReviewCookingGrilled,
                  method: CookingMethod.grilled,
                  isSelected: line.cookingMethod == CookingMethod.grilled,
                  onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.grilled, oilFood: oil)),
                ),
                _CookingMethodDeltaChip(
                  label: '${l10n.mealReviewCookingFried} +${(line.grams * 0.08 * 8.84).round()}kcal',
                  method: CookingMethod.fried,
                  isSelected: line.cookingMethod == CookingMethod.fried,
                  onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.fried, oilFood: oil)),
                ),
                _CookingMethodDeltaChip(
                  label: l10n.mealReviewCookingBaked,
                  method: CookingMethod.baked,
                  isSelected: line.cookingMethod == CookingMethod.baked,
                  onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.baked, oilFood: oil)),
                ),
              ],
            ),
          ),
          // ── Macro chips (kcal, protein, carbs, fat colored chips) ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(VRadius.md),
              border: Border.all(color: colors.line.withValues(alpha: 0.6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroColoredChip(
                  label: locale.startsWith('ar') ? 'سعرة' : 'kcal',
                  value: '${line.kcal.round()}',
                  color: colors.ember,
                ),
                _MacroColoredChip(
                  label: locale.startsWith('ar') ? 'بروتين' : 'Protein',
                  value: '${line.protein.round()}g',
                  color: VMacro.protein,
                ),
                _MacroColoredChip(
                  label: locale.startsWith('ar') ? 'كارب' : 'Carbs',
                  value: '${line.carbs.round()}g',
                  color: VMacro.carbs,
                ),
                _MacroColoredChip(
                  label: locale.startsWith('ar') ? 'دهون' : 'Fat',
                  value: '${line.fat.round()}g',
                  color: VMacro.fat,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // ── "إزاي حسبناها" Clean Table ──
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 6),
            title: Text(
              l10n.mealHowCalculated,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textMute),
            ),
            children: [
              _ItemMathTable(
                line: line,
                locale: locale,
                l10n: l10n,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClarificationChips(
    BuildContext context,
    ResolvedMealLine line,
    String locale,
    ValueChanged<ResolvedMealLine> onChanged,
    FoodItem? oil,
  ) {
    final lowerName = '${line.nameEn} ${line.nameAr}'.toLowerCase();
    final chips = <Widget>[];

    // Question 1: Fried vs Grilled / Boiled (Cooking method clarification)
    final isFried = line.cookingMethod == CookingMethod.fried;
    chips.add(
      ActionChip(
        avatar: Icon(isFried ? Icons.check : Icons.local_fire_department, size: 14),
        label: Text(locale == 'ar' ? 'مقلي؟' : 'Fried?'),
        onPressed: () {
          onChanged(
            recomputeWithMethod(
              line.copyWith(isUnsure: false, confidence: 0.95),
              CookingMethod.fried,
              oilFood: oil,
            ),
          );
        },
      ),
    );
    chips.add(
      ActionChip(
        avatar: Icon(line.cookingMethod == CookingMethod.grilled ? Icons.check : Icons.outdoor_grill, size: 14),
        label: Text(locale == 'ar' ? 'مشوي؟' : 'Grilled?'),
        onPressed: () {
          onChanged(
            recomputeWithMethod(
              line.copyWith(isUnsure: false, confidence: 0.95),
              CookingMethod.grilled,
              oilFood: oil,
            ),
          );
        },
      ),
    );

    // Question 2: Rice vs Bulgur / Bread type / Grain clarification
    if (lowerName.contains('rice') || lowerName.contains('أرز') || lowerName.contains('رز') ||
        lowerName.contains('bulgur') || lowerName.contains('برغل')) {
      final isRice = lowerName.contains('rice') || lowerName.contains('أرز') || lowerName.contains('رز');
      chips.add(
        ActionChip(
          avatar: Icon(isRice ? Icons.check : Icons.grain, size: 14),
          label: Text(locale == 'ar' ? 'أرز أبيض' : 'Rice'),
          onPressed: () {
            final food = FoodDbRepository.instance.byId('white_rice_cooked');
            onChanged(
              resolveLine(
                scanned: ScannedFoodItem(
                  nameAr: 'أرز أبيض',
                  nameEn: 'White rice',
                  foodIdGuess: 'white_rice_cooked',
                  estimatedGrams: line.grams,
                  cookingMethod: line.cookingMethod,
                  confidence: 1.0,
                  isUnsure: false,
                ),
                food: food,
                oilFood: oil,
              ),
            );
          },
        ),
      );
      chips.add(
        ActionChip(
          avatar: const Icon(Icons.grain, size: 14),
          label: Text(locale == 'ar' ? 'برغل' : 'Bulgur'),
          onPressed: () {
            final food = FoodDbRepository.instance.byId('bulgur_cooked');
            onChanged(
              resolveLine(
                scanned: ScannedFoodItem(
                  nameAr: 'برغل',
                  nameEn: 'Bulgur',
                  foodIdGuess: 'bulgur_cooked',
                  estimatedGrams: line.grams,
                  cookingMethod: line.cookingMethod,
                  confidence: 1.0,
                  isUnsure: false,
                ),
                food: food,
                oilFood: oil,
              ),
            );
          },
        ),
      );
    }

    // Question 3: Chicken breast vs Chicken thigh
    if (lowerName.contains('chicken') || lowerName.contains('دجاج') || lowerName.contains('فراخ')) {
      chips.add(
        ActionChip(
          label: Text(locale == 'ar' ? 'صدور دجاج' : 'Chicken breast'),
          onPressed: () {
            final food = FoodDbRepository.instance.byId('chicken_breast_cooked');
            onChanged(
              resolveLine(
                scanned: ScannedFoodItem(
                  nameAr: 'صدر دجاج',
                  nameEn: 'Chicken breast',
                  foodIdGuess: 'chicken_breast_cooked',
                  estimatedGrams: line.grams,
                  cookingMethod: line.cookingMethod,
                  confidence: 1.0,
                  isUnsure: false,
                ),
                food: food,
                oilFood: oil,
              ),
            );
          },
        ),
      );
    }

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: chips.take(3).toList(),
    );
  }
}


class _CookingMethodDeltaChip extends StatelessWidget {
  const _CookingMethodDeltaChip({
    required this.label,
    required this.method,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final CookingMethod method;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      visualDensity: VisualDensity.compact,
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _MacroColoredChip extends StatelessWidget {
  const _MacroColoredChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(VRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemMathTable extends StatelessWidget {
  const _ItemMathTable({
    required this.line,
    required this.locale,
    required this.l10n,
  });

  final ResolvedMealLine line;
  final String locale;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final sourceName = line.food?.source.name ?? (line.isEstimated ? 'AI Estimate' : 'Database');
    final confPct = (line.confidence * 100).round();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(VRadius.sm),
        border: Border.all(color: colors.line.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _TableRow(
            title: l10n.mealReviewItemQty,
            value: '${line.grams.round()} g',
            colors: colors,
          ),
          const Divider(height: 12),
          _TableRow(
            title: locale.startsWith('ar') ? 'السعرات' : 'Calories',
            value: l10n.mealReviewCaloriesFormat(line.kcal.round()),
            colors: colors,
            highlightColor: colors.ember,
          ),
          const Divider(height: 12),
          _TableRow(
            title: locale.startsWith('ar') ? 'المغذيات (بروتين / كارب / دهون)' : 'Macros (P / C / F)',
            value: '${line.protein.round()}g / ${line.carbs.round()}g / ${line.fat.round()}g',
            colors: colors,
          ),
          const Divider(height: 12),
          _TableRow(
            title: locale.startsWith('ar') ? 'المصدر والدقة' : 'Source & Confidence',
            value: '$sourceName (${l10n.mealReviewConfidence(confPct)})',
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.title,
    required this.value,
    required this.colors,
    this.highlightColor,
  });

  final String title;
  final String value;
  final VireoColors colors;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11.5,
            color: colors.textMute,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: highlightColor ?? colors.text,
          ),
        ),
      ],
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

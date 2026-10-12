import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
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
import 'package:vireo/features/subscription/feature_gates.dart';

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
  final Set<int> _expandedIndices = {};
  final _scrollController = ScrollController();
  final _resolver = MealResolutionService(FoodDbRepository.instance);

  @override
  void initState() {
    super.initState();
    _lines = List.of(widget.draft.lines);
    _slot = _mealSlotForNow();
    // No interrupting popup: Plate size is configured in Settings
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  String _suggestedMealName(bool isArabic) {
    if (_lines.isEmpty) return isArabic ? 'وجبة فارغة' : 'Empty meal';
    return _lines
        .map((l) => isArabic ? l.nameAr : (l.nameEn.isNotEmpty ? l.nameEn : l.nameAr))
        .where((n) => n.isNotEmpty)
        .join(' + ');
  }

  (int score, String verdict) _evaluateHealth(bool isArabic) {
    if (_lines.isEmpty) return (5, isArabic ? 'أضف أصناف لوجبتك' : 'Add items');
    final total = _kcal;
    if (total == 0) return (5, isArabic ? 'وجبة خفيفة' : 'Light snack');

    final pRatio = (_p * 4) / total;
    final fRatio = (_f * 9) / total;

    if (pRatio >= 0.25 && fRatio <= 0.35) {
      return (9, isArabic ? 'وجبة متوازنة، بروتين عالي ودقيقة 💪' : 'Balanced, high protein');
    } else if (pRatio >= 0.20) {
      return (8, isArabic ? 'وجبة صحية ومغذية وممتازة لهدفك' : 'Nutritious & goal-aligned');
    } else if (fRatio > 0.45) {
      return (6, isArabic ? 'نسبة الدهون مرتفعة نسبيًا في الوجبة' : 'Relatively high fat');
    } else {
      return (7, isArabic ? 'وجبة معتدلة ومتوازنة السعرات' : 'Moderate balanced meal');
    }
  }

  Future<void> _save() async {
    final result = MealScanDraft(
      lines: _lines,
      imageBytes: widget.draft.imageBytes,
      imagesBytes: widget.draft.imagesBytes,
    ).toAnalysisResult();

    await ref.read(aiMealLogProvider.notifier).save(result);
    await recordSuccessfulMealScan();
    await _resolver.rememberLines(_lines);
    await ref.read(mealRecentProvider.notifier).push(_lines);
    ref.read(confirmedMealsProvider.notifier).update((s) => {...s, _slot});
    ref.invalidate(todayNutritionProvider);

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
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
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context).mealFavoriteSaved),
      ),
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
      _expandedIndices.add(_lines.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');
    final nutrition = ref.watch(todayNutritionProvider(locale));
    final remainingAfter = (nutrition.remainingKcal - _kcal.round());

    final mealName = _suggestedMealName(isArabic);
    final (healthScore, healthVerdict) = _evaluateHealth(isArabic);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.mealReviewTitle),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l10n.mealFavoriteSave,
            icon: const Icon(Icons.star_outline),
            onPressed: _lines.isEmpty ? null : _saveFavorite,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP STICKY SUMMARY CARD (MFP-Style, always visible) ──
            _StickyTopSummaryCard(
              mealName: mealName,
              kcal: _kcal.round(),
              proteinG: _p,
              carbsG: _c,
              fatG: _f,
              fatEquivalentG: (_kcal / 8.84).round(),
              remainingAfter: remainingAfter,
              healthScore: healthScore,
              healthVerdict: healthVerdict,
              slot: _slot,
              slotLabel: _slotLabel(l10n, _slot),
              onSlotChanged: (next) => setState(() => _slot = next),
              onSave: _lines.isEmpty ? null : _save,
              onEditDetails: () {
                setState(() {
                  if (_expandedIndices.length == _lines.length) {
                    _expandedIndices.clear();
                  } else {
                    _expandedIndices.addAll(List.generate(_lines.length, (i) => i));
                  }
                });
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    120,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
            ),

            // ── SCROLLABLE DETAILS: Items List & Collapsed Math Table ──
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  // Photo thumbnails if available
                  if (widget.draft.allImages.isNotEmpty) ...[
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.draft.allImages.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (ctx, idx) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            widget.draft.allImages[idx],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Items List Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isArabic ? 'محتويات الوجبة (${_lines.length})' : 'Meal Items (${_lines.length})',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                        onPressed: _addFood,
                        icon: const Icon(Icons.add, size: 16),
                        label: Text(l10n.mealReviewAddItem),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Compact items list
                  for (var i = 0; i < _lines.length; i++) ...[
                    _MfpItemRow(
                      key: ValueKey('${_lines[i].nameEn}_$i'),
                      line: _lines[i],
                      index: i,
                      isExpanded: _expandedIndices.contains(i),
                      isArabic: isArabic,
                      onToggleExpand: () {
                        setState(() {
                          if (_expandedIndices.contains(i)) {
                            _expandedIndices.remove(i);
                          } else {
                            _expandedIndices.add(i);
                          }
                        });
                      },
                      onChanged: (updated) => setState(() => _lines[i] = updated),
                      onDelete: () => setState(() {
                        _lines.removeAt(i);
                        _expandedIndices.remove(i);
                      }),
                    ),
                    const SizedBox(height: 8),
                  ],

                  const SizedBox(height: 16),

                  // Collapsed "إزاي حسبناها" at the bottom
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(VRadius.md),
                      border: Border.all(color: colors.line.withValues(alpha: 0.5)),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: false,
                      tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      title: Text(
                        l10n.mealHowCalculated,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: colors.textMute,
                        ),
                      ),
                      children: [
                        for (final l in _lines) ...[
                          _ItemMathTable(
                            line: l,
                            locale: locale,
                            l10n: l10n,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
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

/// ── TOP STICKY SUMMARY CARD (MFP Style) ──
class _StickyTopSummaryCard extends StatelessWidget {
  const _StickyTopSummaryCard({
    required this.mealName,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fatEquivalentG,
    required this.remainingAfter,
    required this.healthScore,
    required this.healthVerdict,
    required this.slot,
    required this.slotLabel,
    required this.onSlotChanged,
    required this.onSave,
    required this.onEditDetails,
  });

  final String mealName;
  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int fatEquivalentG;
  final int remainingAfter;
  final int healthScore;
  final String healthVerdict;
  final MealType slot;
  final String slotLabel;
  final ValueChanged<MealType> onSlotChanged;
  final VoidCallback? onSave;
  final VoidCallback onEditDetails;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    // Macro percentages
    final totalMacroKcal = (proteinG * 4) + (carbsG * 4) + (fatG * 9);
    final pPct = totalMacroKcal > 0 ? ((proteinG * 4) / totalMacroKcal * 100).round() : 0;
    final cPct = totalMacroKcal > 0 ? ((carbsG * 4) / totalMacroKcal * 100).round() : 0;
    final fPct = totalMacroKcal > 0 ? ((fatG * 9) / totalMacroKcal * 100).round() : 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.line.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Meal Name & Meal Slot Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  mealName,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<MealType>(
                    isDense: true,
                    value: slot,
                    items: MealType.values
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                              switch (m) {
                                MealType.breakfast => isArabic ? 'فطار' : 'Breakfast',
                                MealType.lunch => isArabic ? 'غدا' : 'Lunch',
                                MealType.dinner => isArabic ? 'عشا' : 'Dinner',
                                MealType.snack => isArabic ? 'سناك' : 'Snack',
                              },
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) onSlotChanged(v);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Big Total Kcal & Macro Donut Chart
          Row(
            children: [
              // Macro Donut
              SizedBox(
                width: 72,
                height: 72,
                child: CustomPaint(
                  painter: _MacroDonutPainter(
                    pRatio: totalMacroKcal > 0 ? (proteinG * 4) / totalMacroKcal : 0.33,
                    cRatio: totalMacroKcal > 0 ? (carbsG * 4) / totalMacroKcal : 0.33,
                    fRatio: totalMacroKcal > 0 ? (fatG * 9) / totalMacroKcal : 0.34,
                    pColor: VMacro.protein,
                    cColor: VMacro.carbs,
                    fColor: VMacro.fat,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$kcal',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                        ),
                        Text(
                          isArabic ? 'سعرة' : 'kcal',
                          semanticsLabel: '$kcal kcal',
                          style: TextStyle(
                            color: colors.textMute,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Macro Grams and Percentages
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _MacroBadge(
                            label: isArabic ? 'بروتين' : 'Protein',
                            grams: '${proteinG.round()}g',
                            pct: '$pPct%',
                            color: VMacro.protein,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _MacroBadge(
                            label: isArabic ? 'كارب' : 'Carbs',
                            grams: '${carbsG.round()}g',
                            pct: '$cPct%',
                            color: VMacro.carbs,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _MacroBadge(
                            label: isArabic ? 'دهون' : 'Fat',
                            grams: '${fatG.round()}g',
                            pct: '$fPct%',
                            color: VMacro.fat,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Fat equivalent & Remaining calories
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '≈ $fatEquivalentG جم دهون',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.textMute, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            isArabic ? 'المتبقي: $remainingAfter سعرة' : 'Remaining: $remainingAfter kcal',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: remainingAfter >= 0 ? colors.ember : colors.danger,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Health Score Badge & Verdict
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '★ $healthScore/10',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    healthVerdict,
                    style: TextStyle(color: colors.textMute, fontSize: 11.5, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Primary & Secondary Buttons: "حفظ" (one tap) & "عدّل التفاصيل"
          Row(
            children: [
              Expanded(
                flex: 3,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.ember,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: onSave,
                  child: const Text('حفظ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: onEditDetails,
                  child: const Text('عدّل التفاصيل', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  const _MacroBadge({
    required this.label,
    required this.grams,
    required this.pct,
    required this.color,
  });

  final String label;
  final String grams;
  final String pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '$grams ($pct)',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10.5, color: color, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _MacroDonutPainter extends CustomPainter {
  const _MacroDonutPainter({
    required this.pRatio,
    required this.cRatio,
    required this.fRatio,
    required this.pColor,
    required this.cColor,
    required this.fColor,
  });

  final double pRatio;
  final double cRatio;
  final double fRatio;
  final Color pColor;
  final Color cColor;
  final Color fColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 9.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paintP = Paint()
      ..color = pColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final paintC = Paint()
      ..color = cColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final paintF = Paint()
      ..color = fColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    var start = -math.pi / 2;
    final pAngle = 2 * math.pi * pRatio;
    final cAngle = 2 * math.pi * cRatio;
    final fAngle = 2 * math.pi * fRatio;

    canvas.drawArc(rect, start, pAngle, false, paintP);
    start += pAngle;
    canvas.drawArc(rect, start, cAngle, false, paintC);
    start += cAngle;
    canvas.drawArc(rect, start, fAngle, false, paintF);
  }

  @override
  bool shouldRepaint(covariant _MacroDonutPainter oldDelegate) => true;
}

/// ── COMPACT ITEM ROW (MFP Style) ──
class _MfpItemRow extends StatelessWidget {
  const _MfpItemRow({
    super.key,
    required this.line,
    required this.index,
    required this.isExpanded,
    required this.isArabic,
    required this.onToggleExpand,
    required this.onChanged,
    required this.onDelete,
  });

  final ResolvedMealLine line;
  final int index;
  final bool isExpanded;
  final bool isArabic;
  final VoidCallback onToggleExpand;
  final ValueChanged<ResolvedMealLine> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final name = isArabic ? line.nameAr : (line.nameEn.isNotEmpty ? line.nameEn : line.nameAr);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          // Row: name · grams · kcal
          InkWell(
            onTap: onToggleExpand,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${line.grams.round()} جم  ·  ${line.kcal.round()} سعرة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textMute,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: colors.textMute,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Editor
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: _ExpandedItemEditor(
                line: line,
                isArabic: isArabic,
                onChanged: onChanged,
                onDelete: onDelete,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ── ITEM EDITOR (Expanded only) ──
class _ExpandedItemEditor extends StatelessWidget {
  const _ExpandedItemEditor({
    required this.line,
    required this.isArabic,
    required this.onChanged,
    required this.onDelete,
  });

  final ResolvedMealLine line;
  final bool isArabic;
  final ValueChanged<ResolvedMealLine> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final oil = FoodDbRepository.instance.byId('sunflower_oil');
    final foodNameLower = '${line.nameEn} ${line.nameAr}'.toLowerCase();

    // Specific unit table per food type
    final unitChips = _getUnitsForFood(foodNameLower, isArabic);

    // Cooking methods relevant only where it matters (chicken, meat, eggs, fish, potatoes)
    final showsCookingMethod = foodNameLower.contains('chicken') ||
        foodNameLower.contains('دجاج') ||
        foodNameLower.contains('فراخ') ||
        foodNameLower.contains('meat') ||
        foodNameLower.contains('لحم') ||
        foodNameLower.contains('fish') ||
        foodNameLower.contains('سمك') ||
        foodNameLower.contains('egg') ||
        foodNameLower.contains('بيض') ||
        foodNameLower.contains('potato') ||
        foodNameLower.contains('بطاطس');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Grams stepper and slider
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(VRadius.sm),
                border: Border.all(color: colors.line),
              ),
              child: Text(
                '${line.grams.round()} جم',
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
        const SizedBox(height: 6),

        // Per-Food Unit Chips
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final u in unitChips)
              ActionChip(
                visualDensity: VisualDensity.compact,
                label: Text(u.label),
                onPressed: () => onChanged(rescaleLine(line, u.grams)),
              ),
            ActionChip(
              visualDensity: VisualDensity.compact,
              label: const Text('100 جم'),
              onPressed: () => onChanged(rescaleLine(line, 100)),
            ),
          ],
        ),

        // Cooking Method Chips (Only where relevant)
        if (showsCookingMethod) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _CookingChip(
                label: isArabic ? 'مسلوق' : 'Boiled',
                isSelected: line.cookingMethod == CookingMethod.boiled,
                onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.boiled, oilFood: oil)),
              ),
              _CookingChip(
                label: isArabic ? 'مشوي' : 'Grilled',
                isSelected: line.cookingMethod == CookingMethod.grilled,
                onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.grilled, oilFood: oil)),
              ),
              _CookingChip(
                label: isArabic ? 'مقلي' : 'Fried',
                isSelected: line.cookingMethod == CookingMethod.fried,
                onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.fried, oilFood: oil)),
              ),
              _CookingChip(
                label: isArabic ? 'في الفرن' : 'Baked',
                isSelected: line.cookingMethod == CookingMethod.baked,
                onSelected: () => onChanged(recomputeWithMethod(line, CookingMethod.baked, oilFood: oil)),
              ),
            ],
          ),
        ],

        const SizedBox(height: 10),

        // Row of individual macros + Delete button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${line.kcal.round()} سعرة  ·  P: ${line.protein.round()}g  ·  C: ${line.carbs.round()}g  ·  F: ${line.fat.round()}g',
              style: TextStyle(color: colors.textMute, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            IconButton(
              tooltip: 'حذف الصنف',
              icon: Icon(Icons.delete_outline, size: 18, color: colors.danger),
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }

  List<({String label, double grams})> _getUnitsForFood(String food, bool isArabic) {
    if (food.contains('rice') || food.contains('أرز') || food.contains('رز')) {
      return [
        (label: isArabic ? 'كوب (150 جم)' : 'Cup (150g)', grams: 150),
        (label: isArabic ? 'ملعقة (25 جم)' : 'Tbsp (25g)', grams: 25),
        (label: isArabic ? 'نصف كوب (75 جم)' : '1/2 Cup (75g)', grams: 75),
      ];
    } else if (food.contains('chicken') || food.contains('دجاج') || food.contains('فراخ')) {
      return [
        (label: isArabic ? 'صدر كامل (180 جم)' : 'Breast (180g)', grams: 180),
        (label: isArabic ? 'قطعة (120 جم)' : 'Piece (120g)', grams: 120),
        (label: isArabic ? 'ورك (150 جم)' : 'Thigh (150g)', grams: 150),
      ];
    } else if (food.contains('bread') || food.contains('خبز') || food.contains('عيش')) {
      return [
        (label: isArabic ? 'رغيف بلدي (100 جم)' : 'Loaf (100g)', grams: 100),
        (label: isArabic ? 'نصف رغيف (50 جم)' : '1/2 Loaf (50g)', grams: 50),
        (label: isArabic ? 'شريحة توست (30 جم)' : 'Slice (30g)', grams: 30),
      ];
    } else if (food.contains('egg') || food.contains('بيض')) {
      return [
        (label: isArabic ? 'بيضة واحدة (50 جم)' : '1 Egg (50g)', grams: 50),
        (label: isArabic ? 'بيضتان (100 جم)' : '2 Eggs (100g)', grams: 100),
      ];
    } else if (food.contains('salad') || food.contains('سلطة') || food.contains('خضار')) {
      return [
        (label: isArabic ? 'طبق صغير (100 جم)' : 'Small bowl (100g)', grams: 100),
        (label: isArabic ? 'طبق كبير (200 جم)' : 'Large bowl (200g)', grams: 200),
      ];
    }

    return [
      (label: isArabic ? 'حصة صغيرة (50 جم)' : 'Small (50g)', grams: 50),
      (label: isArabic ? 'حصة متوسطة (100 جم)' : 'Medium (100g)', grams: 100),
      (label: isArabic ? 'حصة كبيرة (150 جم)' : 'Large (150g)', grams: 150),
    ];
  }
}

class _CookingChip extends StatelessWidget {
  const _CookingChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
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
            value: '${line.grams.round()} جم',
            colors: colors,
          ),
          const Divider(height: 10),
          _TableRow(
            title: locale.startsWith('ar') ? 'السعرات' : 'Calories',
            value: l10n.mealReviewCaloriesFormat(line.kcal.round()),
            colors: colors,
            highlightColor: colors.ember,
          ),
          const Divider(height: 10),
          _TableRow(
            title: locale.startsWith('ar') ? 'المغذيات (بروتين / كارب / دهون)' : 'Macros (P / C / F)',
            value: '${line.protein.round()}g / ${line.carbs.round()}g / ${line.fat.round()}g',
            colors: colors,
          ),
          const Divider(height: 10),
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
            fontSize: 11,
            color: colors.textMute,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: highlightColor ?? colors.text,
          ),
        ),
      ],
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

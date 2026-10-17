import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/services/home_widget_sync.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/meal_type.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/domain/i_food_vision_service.dart';
import 'package:vireo/features/ai_nutrition/domain/family_plate_share.dart';
import 'package:vireo/features/ai_nutrition/domain/meal_correction_text.dart';
import 'package:vireo/features/ai_nutrition/domain/meal_health_score.dart';
import 'package:vireo/features/ai_nutrition/domain/meal_review_calibration.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_budget_provider.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_correction_sheet.dart';
import 'package:vireo/features/ai_nutrition/domain/meal_smart_swap.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_meal_log_provider.dart';
import 'package:vireo/features/auth/services/save_progress_prompt.dart';
import 'package:vireo/features/home/providers/today_nutrition_provider.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/data/food_db_repository.dart';
import 'package:vireo/features/nutrition/data/meal_resolution_service.dart';
import 'package:vireo/features/nutrition/providers/confirmed_meals_provider.dart';
import 'package:vireo/features/nutrition/providers/meal_favorites_provider.dart';
import 'package:vireo/features/nutrition/providers/repeat_meal_service.dart';
import 'package:vireo/features/insights/domain/meal_advice.dart';
import 'package:vireo/features/ramadan/providers/ramadan_settings_provider.dart';
import 'package:vireo/features/nutrition/domain/household_measures.dart';
import 'package:vireo/features/nutrition/providers/cup_size_preference_provider.dart';
import 'package:vireo/features/nutrition/widgets/portion_picker_sheet.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/widgets/soft_paywall_after_scan.dart';
import 'package:vireo/features/fasting/providers/fasting_provider.dart';
import 'package:vireo/features/notifications/widgets/post_scan_notification_prompt.dart';

class MealReviewScreen extends ConsumerStatefulWidget {
  const MealReviewScreen({super.key, required this.draft, this.initialSlot});

  final MealScanDraft draft;

  /// Pre-selects the meal slot (e.g. "زي امبارح" repeats into the same slot).
  /// Defaults to the slot for the current time of day.
  final MealType? initialSlot;

  static Future<bool?> open(
    BuildContext context,
    MealScanDraft draft, {
    MealType? slot,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MealReviewScreen(draft: draft, initialSlot: slot),
      ),
    );
  }

  @override
  ConsumerState<MealReviewScreen> createState() => _MealReviewScreenState();
}

class _MealReviewScreenState extends ConsumerState<MealReviewScreen> {
  late List<ResolvedMealLine> _lines;
  late List<ResolvedMealLine> _unsureLines;
  late List<Uint8List> _images;
  late MealType _slot;
  final Set<int> _expandedIndices = {};
  final _scrollController = ScrollController();
  final _resolver = MealResolutionService(FoodDbRepository.instance);
  bool _clarifyingQuestionDismissed = false;

  /// analyze-meal returned its 24 h cached result => offer "حلّل تاني".
  bool _fromCache = false;
  bool _reanalyzing = false;

  double _portionMultiplier = 1.0;
  bool _familyPlateOn = false;
  FamilyPlateShare _familyShare = FamilyPlateShare.half;

  double get _displayShare => _familyPlateOn ? _familyShare.fraction : 1.0;

  double _scaledMacro(double raw) => raw * _displayShare;

  int get _currentOilGrams {
    final idx = _lines.indexWhere((l) =>
        l.food?.id == 'cooking_oil_estimate' ||
        l.nameEn.toLowerCase().contains('cooking oil') ||
        l.nameAr.contains('زيت'));
    if (idx != -1) return _lines[idx].grams.round();
    return 0;
  }

  void _setCookingOilGrams(int grams) {
    HapticFeedback.selectionClick();
    setState(() {
      final idx = _lines.indexWhere((l) =>
          l.food?.id == 'cooking_oil_estimate' ||
          l.nameEn.toLowerCase().contains('cooking oil') ||
          l.nameAr.contains('زيت'));
      if (grams <= 0) {
        if (idx != -1) _lines.removeAt(idx);
      } else {
        final oilLine = MealResolutionService.createCookingOilLine(oilGrams: grams.toDouble());
        if (idx != -1) {
          _lines[idx] = oilLine;
        } else {
          _lines.add(oilLine);
        }
      }
    });
  }

  CookingOilCalibrationLevel? get _currentOilLevel =>
      CookingOilCalibrationLevel.fromGrams(_currentOilGrams);

  void _setOilLevel(CookingOilCalibrationLevel level) {
    _setCookingOilGrams(level.grams);
  }

  void _setPortionPreset(MealPortionPreset preset) {
    final next = preset.multiplier;
    if ((next - _portionMultiplier).abs() < 0.001) return;
    final ratio = next / _portionMultiplier;
    HapticFeedback.selectionClick();
    setState(() {
      _portionMultiplier = next;
      _lines = [
        for (final l in _lines)
          rescaleLine(l, (l.grams * ratio).clamp(0.5, 10000)),
      ];
    });
  }

  List<ResolvedMealLine> _linesForPersist() {
    if (!_familyPlateOn) return List.of(_lines);
    return [
      for (final l in _lines)
        rescaleLine(
          l,
          scaleGrams(totalGrams: l.grams, share: _familyShare.fraction),
        ),
    ];
  }

  void _addQuickAddon(String id, String nameAr, String nameEn, double grams) {
    HapticFeedback.selectionClick();
    final food = FoodDbRepository.instance.byId(id);
    final oil = FoodDbRepository.instance.byId('sunflower_oil');
    setState(() {
      _lines.add(
        resolveLine(
          scanned: ScannedFoodItem(
            nameAr: nameAr,
            nameEn: nameEn,
            foodIdGuess: id,
            estimatedGrams: grams,
            cookingMethod: CookingMethod.raw,
            confidence: 1.0,
          ),
          food: food,
          oilFood: oil,
        ),
      );
    });
  }

  ResolvedMealLine? _findAmbiguousLine() {
    if (_clarifyingQuestionDismissed) return null;
    for (final l in _lines) {
      final n = '${l.nameEn} ${l.nameAr}'.toLowerCase();
      final isRelevant = n.contains('chicken') ||
          n.contains('دجاج') ||
          n.contains('فراخ') ||
          n.contains('meat') ||
          n.contains('لحم') ||
          n.contains('fish') ||
          n.contains('سمك') ||
          n.contains('potato') ||
          n.contains('بطاطس');
      if (isRelevant && (l.confidence < 0.6 || l.cookingMethod == CookingMethod.fried || l.cookingMethod == CookingMethod.grilled)) {
        return l;
      }
    }
    return null;
  }

  void _answerClarifyingQuestion(ResolvedMealLine targetLine, CookingMethod newMethod) {
    HapticFeedback.mediumImpact();
    final oil = FoodDbRepository.instance.byId('sunflower_oil');
    final updated = resolveLine(
      scanned: ScannedFoodItem(
        nameAr: targetLine.nameAr,
        nameEn: targetLine.nameEn,
        foodIdGuess: targetLine.food?.id,
        estimatedGrams: targetLine.grams,
        cookingMethod: newMethod,
        confidence: 0.95,
      ),
      food: targetLine.food,
      oilFood: oil,
      source: targetLine.source,
      methodOverride: newMethod,
    );
    setState(() {
      _clarifyingQuestionDismissed = true;
      final idx = _lines.indexOf(targetLine);
      if (idx != -1) {
        _lines[idx] = updated;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Filter items: high confidence (>= 0.5 and !isUnsure) go to active lines
    _lines = widget.draft.lines.where((l) => !l.isUnsure && l.confidence >= 0.5).toList();
    _unsureLines = widget.draft.lines.where((l) => l.isUnsure || l.confidence < 0.5).toList();
    if (_lines.isEmpty && widget.draft.lines.isNotEmpty) {
      _lines = List.of(widget.draft.lines);
      _unsureLines = [];
    }
    _images = List.of(widget.draft.allImages);
    _slot = widget.initialSlot ?? _mealSlotForNow();
    _fromCache = widget.draft.fromCache;
  }

  String _visionErrorText(Object e, bool isArabic) {
    if (e is FoodVisionDailyLimitException) {
      return isArabic
          ? 'وصلت للحد اليومي للتحليل. جرّب بكرة أو عدّل الأصناف بإيدك.'
          : 'Daily AI limit reached. Try tomorrow or edit items by hand.';
    }
    if (e is FoodVisionOfflineException) {
      return isArabic
          ? 'مفيش اتصال بالنت. اتأكد من الشبكة وجرّب تاني.'
          : 'No connection. Check your network and try again.';
    }
    if (e is FoodVisionTimeoutException) {
      return isArabic
          ? 'التحليل أخد وقت أطول من المتوقع. جرّب تاني.'
          : 'That took too long. Please try again.';
    }
    if (e is FoodVisionParseException || e is FoodVisionNoFoodException) {
      return isArabic
          ? 'مقدرناش نفهم الأكل ده. جرّب تكتبه بشكل تاني.'
          : 'We could not understand that. Try rephrasing.';
    }
    return isArabic
        ? 'حصلت مشكلة. جرّب مرة تانية كمان شوية.'
        : 'Something went wrong. Please try again shortly.';
  }

  /// "حلّل تاني": re-call analyze-meal with forceReanalyze (skips the 24 h cache).
  Future<void> _reanalyze() async {
    if (_reanalyzing) return;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final photos = widget.draft.allImages;
    if (photos.isEmpty) return;
    HapticFeedback.mediumImpact();
    setState(() => _reanalyzing = true);
    try {
      final fresh = await GeminiFoodServiceCore.analyzeImagesToDraft(
        photos,
        ref.read(remainingCaloriesForAiScanProvider),
        ref.read(remainingProteinForAiScanProvider),
        language: widget.draft.language,
        userHint: widget.draft.userHint,
        forceReanalyze: true,
        alreadyCompressed: true,
      );
      if (!mounted) return;
      setState(() {
        _lines = fresh.lines.where((l) => !l.isUnsure && l.confidence >= 0.5).toList();
        _unsureLines = fresh.lines.where((l) => l.isUnsure || l.confidence < 0.5).toList();
        if (_lines.isEmpty && fresh.lines.isNotEmpty) {
          _lines = List.of(fresh.lines);
          _unsureLines = [];
        }
        _expandedIndices.clear();
        _clarifyingQuestionDismissed = false;
        _fromCache = false;
        _reanalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(isArabic ? 'اتحلّلت الصورة من جديد ✅' : 'Photo re-analyzed ✅'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _reanalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(_visionErrorText(e, isArabic)),
        ),
      );
    }
  }

  /// "عدّل النتيجة": parse the typed correction (names + grams only) and
  /// resolve through [MealResolutionService] (food DB). No kcal guessing.
  /// Returns an error message, or null on success.
  Future<String?> _applyCorrection(String text) async {
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final correction = MealCorrectionText.parse(text);
    if (correction.isEmpty) {
      return isArabic ? 'اكتب اسم الأكل الصح (ولو تقدر الوزن بالجرام).' : 'Type the correct food (and grams if you know).';
    }
    try {
      final parsed = await GeminiFoodServiceCore.parseTextToDraft(
        correction.textForParser,
        language: Localizations.localeOf(context).languageCode,
      );
      if (!mounted) return null;
      var newLines = parsed.lines;
      if (newLines.isEmpty) {
        return isArabic ? 'مقدرناش نلاقي الأكل ده. جرّب اسم تاني.' : 'We could not find that food. Try another name.';
      }

      // A single stated amount on a single food: scale the DB-resolved macros.
      final stated = correction.statedGrams;
      if (stated != null && newLines.length == 1 && newLines.first.grams > 0) {
        final l = newLines.first;
        final f = stated / l.grams;
        newLines = [
          l.copyWith(
            grams: stated,
            kcal: l.kcal * f,
            protein: l.protein * f,
            carbs: l.carbs * f,
            fat: l.fat * f,
            confidence: 1,
          ),
        ];
      }

      // Which existing lines did the user mean? Those named in "مش X".
      final replaceIdx = <int>[
        for (var i = 0; i < _lines.length; i++)
          if (correction.negatedTerms.any((t) => MealCorrectionText.lineMatchesTerm(
                nameAr: _lines[i].nameAr,
                nameEn: _lines[i].nameEn,
                term: t,
              )))
            i,
      ];

      // P34 calibration: user-stated grams vs. the AI's estimate for that item.
      final replacedOne = replaceIdx.length == 1 ? _lines[replaceIdx.first] : null;
      if (stated != null && newLines.length == 1 && replacedOne != null) {
        final key = newLines.first.food?.id ?? newLines.first.nameEn.toLowerCase();
        await _resolver.recordCorrection(
          foodKey: key,
          aiGrams: replacedOne.grams,
          userGrams: stated,
        );
      }

      if (!mounted) return null;
      setState(() {
        if (replaceIdx.isEmpty) {
          _lines = List.of(newLines);
          _unsureLines = [];
        } else {
          final first = replaceIdx.first;
          final kept = <ResolvedMealLine>[
            for (var i = 0; i < _lines.length; i++)
              if (!replaceIdx.contains(i)) _lines[i],
          ];
          final insertAt = first.clamp(0, kept.length);
          kept.insertAll(insertAt, newLines);
          _lines = kept;
        }
        _expandedIndices.clear();
        _clarifyingQuestionDismissed = false;
      });
      HapticFeedback.mediumImpact();
      return null;
    } catch (e) {
      return _visionErrorText(e, isArabic);
    }
  }

  Future<void> _openCorrectionSheet() async {
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final ok = await MealCorrectionSheet.show(
      context,
      isArabic: isArabic,
      onSubmit: _applyCorrection,
    );
    if (ok == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(isArabic ? 'اتعدّلت النتيجة ✅' : 'Result updated ✅'),
        ),
      );
    }
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

  double get _kcal => _scaledMacro(_lines.fold(0.0, (s, l) => s + l.kcal));
  double get _p => _scaledMacro(_lines.fold(0.0, (s, l) => s + l.protein));
  double get _c => _scaledMacro(_lines.fold(0.0, (s, l) => s + l.carbs));
  double get _f => _scaledMacro(_lines.fold(0.0, (s, l) => s + l.fat));

  /// Primary meal name: Arabic names when the locale is Arabic (falling back to
  /// English only for lines that have no Arabic name), English otherwise.
  String _suggestedMealName(bool isArabic) {
    if (_lines.isEmpty) return isArabic ? 'وجبة فارغة' : 'Empty meal';
    return _lines
        .map((l) => isArabic
            ? (l.nameAr.isNotEmpty ? l.nameAr : l.nameEn)
            : (l.nameEn.isNotEmpty ? l.nameEn : l.nameAr))
        .where((n) => n.isNotEmpty)
        .join(' + ');
  }

  /// English secondary line, shown only under an Arabic primary name.
  String? _secondaryMealName(bool isArabic) {
    if (!isArabic || _lines.isEmpty) return null;
    final en = _lines.map((l) => l.nameEn).where((n) => n.isNotEmpty).join(' + ');
    if (en.isEmpty || en == _suggestedMealName(true)) return null;
    return en;
  }

  static const _vegKeywords = [
    'salad', 'vegetable', 'broccoli', 'cucumber', 'tomato', 'spinach', 'lettuce',
    'carrot', 'zucchini', 'okra', 'molokhia', 'cabbage', 'pepper', 'eggplant',
    'سلطة', 'خضار', 'بروكلي', 'خيار', 'طماطم', 'سبانخ', 'خس', 'جزر', 'كوسة',
    'بامية', 'ملوخية', 'كرنب', 'فلفل', 'باذنجان',
  ];

  static bool _isOilLine(ResolvedMealLine l) =>
      l.food?.id == 'cooking_oil_estimate' ||
      l.nameEn.toLowerCase().contains('cooking oil') ||
      l.nameAr.contains('زيت') ||
      l.nameAr.contains('سمن');

  /// Added-sugar grams for one line. Food DB has no sugar field, so this is an
  /// estimate from the line identity (typical USDA values per 100 g):
  /// table sugar 100, honey 82, cola/soda 10.6, fruit juice 9.
  static double _estimatedAddedSugarG(ResolvedMealLine l) {
    final id = (l.food?.id ?? '').toLowerCase();
    final n = '${l.nameEn} ${l.nameAr}'.toLowerCase();
    final f = l.grams / 100.0;
    if (id.contains('sugar') || RegExp(r'\bsugar\b').hasMatch(n) || n.contains('سكر ')) {
      if (n.contains('free') || n.contains('بدون')) return 0;
      return 100 * f;
    }
    if (n.contains('honey') || n.contains('عسل')) return 82 * f;
    if (RegExp(r'\b(cola|soda|pepsi)\b').hasMatch(n) ||
        n.contains('بيبسي') ||
        n.contains('كولا') ||
        n.contains('صودا')) {
      return 10.6 * f;
    }
    if (n.contains('juice') || n.contains('عصير')) return 9 * f;
    return 0;
  }

  _MealHealthEval _evaluateHealth(bool isArabic) {
    if (_lines.isEmpty) {
      return _MealHealthEval.placeholder(5, isArabic ? 'أضف أصناف لوجبتك' : 'Add items');
    }
    if (_kcal <= 0) {
      return _MealHealthEval.placeholder(5, isArabic ? 'وجبة خفيفة' : 'Light snack');
    }

    var totalGrams = 0.0;
    var oilGrams = 0.0;
    var vegGrams = 0.0;
    var fiber = 0.0;
    var sugar = 0.0;
    var anyFiberFood = false;
    var fiberEstimated = false;
    var isFried = false;

    for (final l in _lines) {
      totalGrams += l.grams;
      final isOil = _isOilLine(l);
      if (isOil) oilGrams += l.grams;

      if (l.cookingMethod == CookingMethod.fried || l.food?.isAlreadyFried == true) {
        isFried = true;
      }
      // Oil absorbed while cooking (already inside the line's macros).
      if (!isOil && l.food?.isAlreadyFried != true) {
        oilGrams += l.cookingMethod.oilAbsorptionGramsPer100g * l.grams / 100.0;
      }

      final n = '${l.nameEn} ${l.nameAr}'.toLowerCase();
      if (_vegKeywords.any(n.contains)) vegGrams += l.grams;

      final food = l.food;
      if (food != null) {
        anyFiberFood = true;
        fiber += food.per100g.fiber * l.grams / 100.0;
      } else if (!isOil) {
        fiberEstimated = true; // fiber of this line unknown
      }
      sugar += _estimatedAddedSugarG(l);
    }

    final fiberG = anyFiberFood ? fiber : null;
    final score = MealHealthScorer.score(MealNutrientSnapshot(
      kcal: _kcal,
      proteinG: _p,
      carbsG: _c,
      fatG: _f,
      fiberG: fiberG,
      sugarG: sugar, // estimated, see _estimatedAddedSugarG
      sodiumMg: null, // not available in the food DB models
      oilGrams: oilGrams,
      vegGrams: vegGrams,
      totalFoodGrams: totalGrams,
      isFried: isFried,
    ));

    final swap = MealSmartSwap.pick([
      for (final l in _lines)
        SwapCandidateLine(
          nameAr: l.nameAr,
          nameEn: l.nameEn,
          grams: l.grams,
          kcal: l.kcal,
          proteinG: l.protein,
          carbsG: l.carbs,
          fatG: l.fat,
        ),
    ]);

    return _MealHealthEval(
      score: score.score,
      verdict: isArabic ? score.reasonAr : score.reasonEn,
      fiberG: fiberG,
      fiberEstimated: fiberEstimated,
      sugarG: sugar,
      sodiumMg: null,
      swap: swap,
    );
  }

  Future<void> _addPhoto() async {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(isArabic ? 'من المعرض' : 'From Gallery'),
                onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(isArabic ? 'التقاط صورة بالكاميرا' : 'Take Photo'),
                onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      if (mounted) {
        setState(() => _images.add(bytes));
      }
    }
  }

  Future<void> _save(MealAdviceResult advice) async {
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    // Integration: Logging a meal during a fast asks "تنهي الصيام؟"
    final fastingState = ref.read(fastingProvider);
    if (fastingState.isFasting) {
      final shouldEnd = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(isArabic ? 'أنت صائم حالياً — تنهي الصيام؟ ⏱️' : 'Fasting Active — End Fast? ⏱️'),
          content: Text(
            isArabic
                ? 'لديك جلسة صيام نشطة الآن. هل ترغب في إنهائها مع تسجيل هذه الوجبة وبدء نافذة الطعام؟'
                : 'You have an active fast session. Would you like to end it with this meal?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(isArabic ? 'لا، متابعة الصيام' : 'Keep Fasting'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(isArabic ? 'نعم، إنهاء الصيام' : 'End Fast Now'),
            ),
          ],
        ),
      );
      if (shouldEnd == true) {
        await ref.read(fastingProvider.notifier).endFast(isArabic: isArabic);
      }
    }

    final persistLines = _linesForPersist();
    final result = MealScanDraft(
      lines: persistLines,
      imageBytes: _images.isNotEmpty ? _images.first : widget.draft.imageBytes,
      imagesBytes: _images,
    ).toAnalysisResult();

    await ref.read(aiMealLogProvider.notifier).save(result);
    final scanCount = await recordSuccessfulMealScan();
    await _resolver.rememberLines(persistLines, originalScanned: widget.draft.originalScanned);
    await ref.read(mealRecentProvider.notifier).push(persistLines);
    await ref.read(mealSlotHistoryProvider.notifier).record(_slot, persistLines);
    ref.read(confirmedMealsProvider.notifier).update((s) => {...s, _slot});
    ref.invalidate(todayNutritionProvider);

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);

    // Show friendly advice toast with action button
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.aiScanSavedSnack, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(advice.adviceText, style: const TextStyle(fontSize: 12)),
          ],
        ),
        action: advice.suggestedItems.isNotEmpty
            ? SnackBarAction(
                label: isArabic ? 'خطة الوجبة القادمة' : 'Next meal plan',
                onPressed: () {
                  // Pre-load suggested meal
                },
              )
            : null,
      ),
    );
    if (!mounted) return;
    await maybePromptMealRemindersAfterScan(
      context,
      ref,
      scanCountAfterSave: scanCount,
    );
    if (!mounted) return;
    await syncHomeScreenWidget(ref, context: context, force: true);
    if (!mounted) return;
    await maybeShowSoftPaywallAfterFirstScan(
      context,
      ref,
      scanCountAfterSave: scanCount,
    );
    if (!mounted) return;
    final isPro = ref.read(isProUserProvider);
    Navigator.of(context).pop(true);
    await AdService.instance.showInterstitialIfEligible(isPro: isPro);
  }

  Future<void> _saveFavorite() async {
    await ref.read(mealFavoritesProvider.notifier).add(_linesForPersist());
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
    final confirmed = ref.watch(confirmedMealsProvider);
    final isRamadan = ref.watch(ramadanSettingsProvider).isEnabled;

    final mealName = _suggestedMealName(isArabic);
    final mealNameSecondary = _secondaryMealName(isArabic);
    final health = _evaluateHealth(isArabic);

    // Compute rule-based MealAdvice
    final advice = MealAdviceEngine.computeAdvice(
      dailyGoalKcal: nutrition.goalKcal,
      dailyGoalProteinG: nutrition.proteinTarget.toDouble(),
      dailyGoalCarbsG: nutrition.carbsTarget.toDouble(),
      dailyGoalFatG: nutrition.fatTarget.toDouble(),
      eatenKcalBefore: nutrition.eatenKcal,
      eatenProteinBefore: nutrition.proteinG,
      eatenCarbsBefore: nutrition.carbsG,
      eatenFatBefore: nutrition.fatG,
      mealKcal: _kcal.round(),
      mealProteinG: _p,
      mealCarbsG: _c,
      mealFatG: _f,
      currentSlot: _slot,
      confirmedSlots: confirmed,
      isRamadan: isRamadan,
      availableFoods: FoodDbRepository.instance.byId('white_rice_cooked') != null
          ? [
              FoodDbRepository.instance.byId('grilled_chicken_breast')!,
              FoodDbRepository.instance.byId('white_rice_cooked')!,
            ]
          : [],
      isArabic: isArabic,
    );

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
              l10n: l10n,
              mealName: mealName,
              mealNameSecondary: mealNameSecondary,
              thumbnailBytes: widget.draft.allImages.firstOrNull,
              kcal: _kcal.round(),
              proteinG: _p,
              carbsG: _c,
              fatG: _f,
              fatEquivalentG: (_kcal / 8.84).round(),
              advice: advice,
              health: health,
              slot: _slot,
              slotLabel: _slotLabel(l10n, _slot),
              portionMultiplier: _portionMultiplier,
              onPortionChanged: _setPortionPreset,
              oilLevel: _currentOilLevel,
              onOilLevelChanged: _setOilLevel,
              familyPlateOn: _familyPlateOn,
              familyShare: _familyShare,
              onFamilyPlateChanged: (on) => setState(() => _familyPlateOn = on),
              onFamilyShareChanged: (share) => setState(() {
                _familyPlateOn = true;
                _familyShare = share;
              }),
              onSlotChanged: (next) => setState(() => _slot = next),
              onSave: _lines.isEmpty ? null : () => _save(advice),
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
                  // Same photo analysed within 24 h => same result (stable). Offer a fresh run.
                  if (_fromCache) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            isArabic
                                ? 'دي نفس نتيجة تحليل الصورة دي من آخر ٢٤ ساعة. لو شايف إنها مش مظبوطة، حلّلها من جديد.'
                                : 'This is the saved result for this photo (last 24 h). If it looks off, analyze it again.',
                            style: TextStyle(color: colors.textMute, fontSize: 12.5, height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _reanalyzing ? null : _reanalyze,
                            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                            icon: _reanalyzing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.refresh_rounded, size: 18),
                            label: Text(isArabic ? 'حلّل تاني' : 'Analyze again'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // If AI returned unsure items (< 0.5 confidence), show suggestion chip row
                  if (_unsureLines.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.help_outline_rounded, size: 16, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 6),
                              Text(
                                isArabic ? 'ممكن يكون فيه كمان في الوجبة؟' : 'Possible extra items found?',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              for (final unsure in _unsureLines)
                                ActionChip(
                                  avatar: const Icon(Icons.add, size: 14),
                                  label: Text('${unsure.nameAr} (${unsure.grams.round()} جم)'),
                                  onPressed: () {
                                    setState(() {
                                      _unsureLines.remove(unsure);
                                      _lines.add(unsure.copyWith(isUnsure: false, confidence: 0.8));
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Photo thumbnails with "+ صورة" option
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (ctx, idx) {
                        if (idx < _images.length) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              _images[idx],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return InkWell(
                          onTap: _addPhoto,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: colors.surfaceRaised,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: colors.line),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, color: colors.ember, size: 24),
                                const SizedBox(height: 6),
                                Text(
                                  isArabic ? '+ صورة' : '+ Photo',
                                  style: TextStyle(
                                    color: colors.textMute,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── SMART CLARIFYING QUESTION (At most ONE banner) ──
                  if (_findAmbiguousLine() != null) ...[
                    Builder(
                      builder: (context) {
                        final ambiguous = _findAmbiguousLine()!;
                        final itemName = isArabic ? ambiguous.nameAr : ambiguous.nameEn;
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.ember.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.ember.withValues(alpha: 0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.help_center_rounded, color: colors.ember, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      isArabic
                                          ? 'سؤال سريع لدقة أعلى: $itemName مشوية ولا مقلية؟'
                                          : 'Quick check: Is $itemName grilled or fried?',
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                    ),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.close, size: 16),
                                    onPressed: () => setState(() => _clarifyingQuestionDismissed = true),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () => _answerClarifyingQuestion(ambiguous, CookingMethod.grilled),
                                      child: Text(isArabic ? 'مشوية 🍗' : 'Grilled 🍗', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () => _answerClarifyingQuestion(ambiguous, CookingMethod.fried),
                                      child: Text(isArabic ? 'مقلية 🍳' : 'Fried 🍳', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Common extras (oil + portion live in the sticky calibration hero).
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.line.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          isArabic ? 'إضافات شائعة:' : 'Common extras:',
                          style: TextStyle(fontSize: 11, color: colors.textMute, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ActionChip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(isArabic ? '+ طحينة (25 جم)' : '+ Tahini (25g)', style: const TextStyle(fontSize: 10.5)),
                                  onPressed: () => _addQuickAddon('tahini', 'طحينة', 'Tahini dip', 25),
                                ),
                                const SizedBox(width: 6),
                                ActionChip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(isArabic ? '+ صوص/دريسنج (20 جم)' : '+ Dressing (20g)', style: const TextStyle(fontSize: 10.5)),
                                  onPressed: () => _addQuickAddon('salad_dressing', 'صوص وسلطة', 'Salad dressing', 20),
                                ),
                                const SizedBox(width: 6),
                                ActionChip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(isArabic ? '+ سكر بمشروب (10 جم)' : '+ Drink sugar (10g)', style: const TextStyle(fontSize: 10.5)),
                                  onPressed: () => _addQuickAddon('sugar_white_granulated', 'سكر أبيض بالمشروب', 'Sugar in drink', 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Free-text correction ("ده سلمون مش فراخ، 150 جم") → parse → DB resolve
                  OutlinedButton.icon(
                    onPressed: _openCorrectionSheet,
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    icon: const Icon(Icons.edit_note_rounded, size: 20),
                    label: Text(isArabic ? 'عدّل النتيجة' : 'Correct the result'),
                  ),
                  const SizedBox(height: 14),

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

/// Result of [_MealReviewScreenState._evaluateHealth]: score + micro nutrients
/// + optional swap tip. `null` micro values mean "not available".
class _MealHealthEval {
  const _MealHealthEval({
    required this.score,
    required this.verdict,
    required this.fiberG,
    required this.fiberEstimated,
    required this.sugarG,
    required this.sodiumMg,
    required this.swap,
  });

  factory _MealHealthEval.placeholder(int score, String verdict) => _MealHealthEval(
        score: score,
        verdict: verdict,
        fiberG: null,
        fiberEstimated: false,
        sugarG: null,
        sodiumMg: null,
        swap: null,
      );

  final int score;
  final String verdict;
  final double? fiberG;
  final bool fiberEstimated;

  /// Always an estimate: the food DB models carry no sugar field.
  final double? sugarG;

  /// Not available in the food DB models yet.
  final double? sodiumMg;
  final SmartSwapTip? swap;
}

class _MicroChip extends StatelessWidget {
  const _MicroChip({
    required this.label,
    required this.value,
    required this.estimated,
    required this.isArabic,
  });

  final String label;
  final String value;
  final bool estimated;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.line.withValues(alpha: 0.6)),
      ),
      child: Text(
        estimated ? '$label $value · ${isArabic ? 'تقدير' : 'est.'}' : '$label $value',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: colors.textMute),
      ),
    );
  }
}

/// ── TOP STICKY SUMMARY CARD (MFP Style) ──
/// P40 sticky hero: portion stepper, oil chip, family-plate share.
class _MealReviewCalibrationHero extends StatelessWidget {
  const _MealReviewCalibrationHero({
    required this.l10n,
    required this.colors,
    required this.isArabic,
    required this.portionMultiplier,
    required this.onPortionChanged,
    required this.oilLevel,
    required this.onOilLevelChanged,
    required this.familyPlateOn,
    required this.familyShare,
    required this.onFamilyPlateChanged,
    required this.onFamilyShareChanged,
  });

  final AppLocalizations l10n;
  final VireoColors colors;
  final bool isArabic;
  final double portionMultiplier;
  final ValueChanged<MealPortionPreset> onPortionChanged;
  final CookingOilCalibrationLevel? oilLevel;
  final ValueChanged<CookingOilCalibrationLevel> onOilLevelChanged;
  final bool familyPlateOn;
  final FamilyPlateShare familyShare;
  final ValueChanged<bool> onFamilyPlateChanged;
  final ValueChanged<FamilyPlateShare> onFamilyShareChanged;

  String _oilLabel(CookingOilCalibrationLevel level) => switch (level) {
        CookingOilCalibrationLevel.light => l10n.mealReviewOilLight,
        CookingOilCalibrationLevel.normal => l10n.mealReviewOilNormal,
        CookingOilCalibrationLevel.heavy => l10n.mealReviewOilHeavy,
      };

  String _shareChipLabel(FamilyPlateShare share) {
    if (isArabic) return '${share.glyph} ${share.labelAr}';
    return '${share.glyph} (${share.numerator}/${share.denominator})';
  }

  @override
  Widget build(BuildContext context) {
    final selectedPortion = MealPortionPreset.fromMultiplier(portionMultiplier);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line.withValues(alpha: 0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.mealReviewPortionLabel,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: colors.textMute),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final preset in MealPortionPreset.values)
                ChoiceChip(
                  visualDensity: VisualDensity.compact,
                  label: Text(preset.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                  selected: selectedPortion == preset,
                  onSelected: (_) => onPortionChanged(preset),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.mealReviewOilPrefix,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: colors.textMute),
              ),
              for (final level in CookingOilCalibrationLevel.values)
                ChoiceChip(
                  visualDensity: VisualDensity.compact,
                  label: Text(_oilLabel(level), style: const TextStyle(fontSize: 11.5)),
                  selected: oilLevel == level,
                  onSelected: (_) => onOilLevelChanged(level),
                ),
            ],
          ),
          const SizedBox(height: 4),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              l10n.mealReviewFamilyPlateToggle,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
            value: familyPlateOn,
            onChanged: onFamilyPlateChanged,
          ),
          if (familyPlateOn) ...[
            Text(
              l10n.mealReviewMyShare,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: colors.textMute),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final share in FamilyPlateShare.values)
                  ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(_shareChipLabel(share), style: const TextStyle(fontSize: 11.5)),
                    selected: familyShare == share,
                    onSelected: (_) => onFamilyShareChanged(share),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StickyTopSummaryCard extends StatelessWidget {
  const _StickyTopSummaryCard({
    required this.l10n,
    required this.mealName,
    this.mealNameSecondary,
    this.thumbnailBytes,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fatEquivalentG,
    required this.advice,
    required this.health,
    required this.slot,
    required this.slotLabel,
    required this.onSlotChanged,
    required this.portionMultiplier,
    required this.onPortionChanged,
    required this.oilLevel,
    required this.onOilLevelChanged,
    required this.familyPlateOn,
    required this.familyShare,
    required this.onFamilyPlateChanged,
    required this.onFamilyShareChanged,
    required this.onSave,
    required this.onEditDetails,
  });

  final AppLocalizations l10n;
  final String mealName;
  final String? mealNameSecondary;
  final Uint8List? thumbnailBytes;
  final int kcal;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int fatEquivalentG;
  final MealAdviceResult advice;
  final _MealHealthEval health;
  final MealType slot;
  final String slotLabel;
  final ValueChanged<MealType> onSlotChanged;
  final double portionMultiplier;
  final ValueChanged<MealPortionPreset> onPortionChanged;
  final CookingOilCalibrationLevel? oilLevel;
  final ValueChanged<CookingOilCalibrationLevel> onOilLevelChanged;
  final bool familyPlateOn;
  final FamilyPlateShare familyShare;
  final ValueChanged<bool> onFamilyPlateChanged;
  final ValueChanged<FamilyPlateShare> onFamilyShareChanged;
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
          // Header: Thumbnail + Meal Name (max 2 lines) & Meal Slot Dropdown
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (thumbnailBytes != null && thumbnailBytes!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    thumbnailBytes!,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, height: 1.25),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (mealNameSecondary != null)
                      Text(
                        mealNameSecondary!,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: colors.textMute,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
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
          const SizedBox(height: 10),

          _MealReviewCalibrationHero(
            l10n: l10n,
            colors: colors,
            isArabic: isArabic,
            portionMultiplier: portionMultiplier,
            onPortionChanged: onPortionChanged,
            oilLevel: oilLevel,
            onOilLevelChanged: onOilLevelChanged,
            familyPlateOn: familyPlateOn,
            familyShare: familyShare,
            onFamilyPlateChanged: onFamilyPlateChanged,
            onFamilyShareChanged: onFamilyShareChanged,
          ),
          const SizedBox(height: 10),

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
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.mealReviewKcalApprox(kcal),
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            l10n.mealReviewEstimated,
                            semanticsLabel: l10n.mealReviewEstimated,
                            style: TextStyle(
                              color: colors.textMute,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
                    // Fat equivalent
                    Text(
                      '≈ $fatEquivalentG جم دهون مخزنة أو محروقة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.textMute, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Micro chips: sodium, sugar, fiber ("تقدير" when estimated)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _MicroChip(
                label: isArabic ? 'صوديوم' : 'Sodium',
                value: health.sodiumMg == null
                    ? '—'
                    : '${health.sodiumMg!.round()} ${isArabic ? 'مجم' : 'mg'}',
                estimated: health.sodiumMg != null,
                isArabic: isArabic,
              ),
              _MicroChip(
                label: isArabic ? 'سكر' : 'Sugar',
                value: health.sugarG == null
                    ? '—'
                    : '${health.sugarG!.round()} ${isArabic ? 'جم' : 'g'}',
                estimated: health.sugarG != null,
                isArabic: isArabic,
              ),
              _MicroChip(
                label: isArabic ? 'ألياف' : 'Fiber',
                value: health.fiberG == null
                    ? '—'
                    : '${health.fiberG!.toStringAsFixed(1)} ${isArabic ? 'جم' : 'g'}',
                estimated: health.fiberG != null && health.fiberEstimated,
                isArabic: isArabic,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── "After this meal" Smart Block ──
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.line.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isArabic ? 'بعد تسجيل هذه الوجبة:' : 'After this meal today:',
                  style: TextStyle(fontSize: 11, color: colors.textMute, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                // 4 mini chips for remaining calories, protein, carbs, and fat
                Row(
                  children: [
                    Expanded(
                      child: _RemainingChip(
                        label: isArabic ? 'سعرات' : 'Kcal',
                        value: advice.remainingKcalAfter,
                        unit: '',
                        color: colors.ember,
                        isArabic: isArabic,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _RemainingChip(
                        label: isArabic ? 'بروتين' : 'Protein',
                        value: advice.remainingProteinAfter.round(),
                        unit: 'جم',
                        color: VMacro.protein,
                        isArabic: isArabic,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _RemainingChip(
                        label: isArabic ? 'كارب' : 'Carbs',
                        value: advice.remainingCarbsAfter.round(),
                        unit: 'جم',
                        color: VMacro.carbs,
                        isArabic: isArabic,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _RemainingChip(
                        label: isArabic ? 'دهون' : 'Fat',
                        value: advice.remainingFatAfter.round(),
                        unit: 'جم',
                        color: VMacro.fat,
                        isArabic: isArabic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Smart Advice Line
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.tips_and_updates_rounded, size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        advice.adviceText,
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                    '★ ${health.score}/10',
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
                    health.verdict,
                    style: TextStyle(color: colors.textMute, fontSize: 11.5, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Smart swap tip (at most one)
          if (health.swap != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.swap_horiz_rounded, size: 16, color: Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isArabic ? health.swap!.tipAr : health.swap!.tipEn,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

class _RemainingChip extends StatelessWidget {
  const _RemainingChip({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.isArabic,
  });

  final String label;
  final int value;
  final String unit;
  final Color color;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final isOver = value < 0;
    final text = isOver
        ? (isArabic ? 'زيادة ${value.abs()}' : '+${value.abs()}')
        : (isArabic ? 'باقي $value' : '$value left');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isOver ? const Color(0xFFF59E0B).withValues(alpha: 0.15) : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOver ? const Color(0xFFF59E0B) : color.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: isOver ? const Color(0xFFF59E0B) : color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '$text $unit'.trim(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isOver ? const Color(0xFFF59E0B) : Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                        const SizedBox(height: 3),
                        Builder(
                          builder: (context) {
                            final (sourceLabel, sourceColor) = () {
                              if (line.isUnsure) {
                                return (isArabic ? 'مش متأكدين ⚠️' : 'Unsure ⚠️', const Color(0xFFF59E0B));
                              }
                              return switch (line.source) {
                                FoodDatabaseSource.personalCalibrated => (
                                    isArabic ? 'معدّلة على أكلك 💜' : 'Calibrated 💜',
                                    const Color(0xFF8B5CF6)
                                  ),
                                FoodDatabaseSource.egyptianDb => (
                                    isArabic ? 'قاعدة بيانات' : 'Database',
                                    const Color(0xFF10B981)
                                  ),
                                FoodDatabaseSource.usda => (
                                    'USDA',
                                    const Color(0xFF06B6D4)
                                  ),
                                FoodDatabaseSource.estimated => (
                                    isArabic ? 'تقدير' : 'Estimated',
                                    const Color(0xFFF59E0B)
                                  ),
                              };
                            }();

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: sourceColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                sourceLabel,
                                style: TextStyle(
                                  color: sourceColor,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Builder(
                      builder: (context) {
                        final calRange = (line.kcalLow != null && line.kcalHigh != null && (line.kcalHigh! - line.kcalLow! > 5))
                            ? '≈ ${line.kcal.round()} (${line.kcalLow!.round()}–${line.kcalHigh!.round()})'
                            : '${line.kcal.round()} سعرة';
                        return Text(
                          '${line.grams.round()} جم  ·  $calRange',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.textMute,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
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
class _ExpandedItemEditor extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final oil = FoodDbRepository.instance.byId('sunflower_oil');
    final foodNameLower = '${line.nameEn} ${line.nameAr}'.toLowerCase();

    // Specific unit table per food type
    final unitChips = _getUnitsForFood(foodNameLower, isArabic, ref);

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
            ActionChip(
              visualDensity: VisualDensity.compact,
              avatar: const Text('🥣', style: TextStyle(fontSize: 14)),
              label: Text(isArabic ? 'مقاييس البيت' : 'Household portion'),
              onPressed: () async {
                HapticFeedback.selectionClick();
                final pickedGrams = await PortionPickerSheet.show(
                  context,
                  nameAr: line.nameAr,
                  nameEn: line.nameEn,
                  initialGrams: line.grams,
                );
                if (pickedGrams != null) {
                  onChanged(rescaleLine(line, pickedGrams));
                }
              },
            ),
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

  List<({String label, double grams})> _getUnitsForFood(String food, bool isArabic, WidgetRef ref) {
    final cupMl = ref.read(userCupSizeProvider);
    final householdList = HouseholdMeasures.getUnitsForFood(
      nameAr: food,
      nameEn: food,
    );

    return [
      for (final u in householdList)
        (
          label: '${u.label(isArabic)} (${u.gramsWithCupCalibration(cupMl).round()} ${isArabic ? "جم" : "g"})',
          grams: u.gramsWithCupCalibration(cupMl),
        ),
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
          const Divider(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_rounded, size: 14, color: colors.ember),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    locale.startsWith('ar')
                        ? 'خطوات الحساب: 1. التعرّف البصري ➔ 2. الجرامات بمعايرة الطبق ➔ 3. مطابقة قاعدة بيانات معتمدة ➔ 4. امتصاص زيوت الطهي ➔ 5. معايرة مخصصة.'
                        : '5-Step Math: 1. Vision ID ➔ 2. Plate-calibrated grams ➔ 3. Verified DB lookup ➔ 4. Cooking oil absorption ➔ 5. Personal portion learning.',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: colors.textMute,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
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

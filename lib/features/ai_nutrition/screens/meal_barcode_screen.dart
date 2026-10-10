import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';

/// Barcode → Open Food Facts → review screen.
class MealBarcodeScreen extends ConsumerStatefulWidget {
  const MealBarcodeScreen({super.key});

  @override
  ConsumerState<MealBarcodeScreen> createState() => _MealBarcodeScreenState();
}

class _MealBarcodeScreenState extends ConsumerState<MealBarcodeScreen> {
  bool _handled = false;
  String? _error;

  Future<void> _onCode(String code) async {
    if (_handled) return;
    _handled = true;
    final l10n = AppLocalizations.of(context);
    try {
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/api/v2/product/$code.json',
      );
      final res = await http.get(uri, headers: {'User-Agent': 'Vireo/1.0'});
      if (res.statusCode != 200) {
        throw Exception('OFF ${res.statusCode}');
      }
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      final product = decoded['product'] as Map<String, dynamic>?;
      if (product == null) throw Exception('not found');
      final name = product['product_name']?.toString() ??
          product['product_name_en']?.toString() ??
          'Product';
      final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};
      final kcal = (nutriments['energy-kcal_100g'] as num?)?.toDouble() ??
          ((nutriments['energy_100g'] as num?)?.toDouble() ?? 0) / 4.184;
      final protein = (nutriments['proteins_100g'] as num?)?.toDouble() ?? 0;
      final carbs = (nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0;
      final fat = (nutriments['fat_100g'] as num?)?.toDouble() ?? 0;
      final serving = (product['serving_quantity'] as num?)?.toDouble() ?? 100;

      final line = ResolvedMealLine(
        nameAr: name,
        nameEn: name,
        grams: serving,
        cookingMethod: CookingMethod.raw,
        confidence: 0.85,
        kcal: kcal * serving / 100,
        protein: protein * serving / 100,
        carbs: carbs * serving / 100,
        fat: fat * serving / 100,
        isEstimated: true,
        portions: [
          FoodPortion(nameAr: 'حصة', nameEn: 'serving', grams: serving),
          const FoodPortion(nameAr: '100 جم', nameEn: '100 g', grams: 100),
        ],
      );

      if (!mounted) return;
      await MealReviewScreen.open(
        context,
        MealScanDraft(lines: [line], imageBytes: Uint8List(0)),
      );
      if (mounted) Navigator.of(context).maybePop();
    } catch (e) {
      BootLog.warn('barcode OFF lookup failed', e);
      if (mounted) {
        setState(() {
          _error = l10n.mealBarcodeFailed;
          _handled = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mealBarcodeTitle)),
      body: Column(
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _error!,
                style: TextStyle(color: context.vireoColors.danger),
              ),
            ),
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final code = capture.barcodes.firstOrNull?.rawValue;
                if (code != null) _onCode(code);
              },
            ),
          ),
        ],
      ),
    );
  }
}

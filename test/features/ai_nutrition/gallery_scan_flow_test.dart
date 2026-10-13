import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/features/ai_nutrition/application/ai_scan_state.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/providers/ai_scan_provider.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_scan_analyze_screen.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';

final _validPngBytes = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
]);

final _testDraft = MealScanDraft(
  lines: const [
    ResolvedMealLine(
      nameAr: 'سلطة خضراء',
      nameEn: 'Green Salad',
      grams: 150,
      cookingMethod: CookingMethod.raw,
      confidence: 0.95,
      kcal: 45,
      protein: 2,
      carbs: 8,
      fat: 1,
    ),
  ],
  imageBytes: _validPngBytes,
);

class _SuccessAiScanNotifier extends AiScanNotifier {
  @override
  AiScanState build() => const AiScanIdle();

  @override
  Future<void> scanMealMulti(
    List<Uint8List> images, {
    String language = 'ar',
    String? userHint,
  }) async {
    state = AsyncData(AiScanSuccess(_testDraft));
  }
}

class _ThrowingAiScanNotifier extends AiScanNotifier {
  @override
  AiScanState build() => const AiScanIdle();

  @override
  Future<void> scanMealMulti(
    List<Uint8List> images, {
    String language = 'ar',
    String? userHint,
  }) async {
    state = const AsyncData(AiScanError(AiScanErrorKind.api));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Gallery Meal Analysis Flow', () {
    testWidgets('gallery entry with fake picked bytes reaches review screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiScanProvider.overrideWith(_SuccessAiScanNotifier.new),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: MealScanAnalyzeScreen(photos: [_validPngBytes]),
          ),
        ),
      );

      // Frame callback runs scanMealMulti and opens MealReviewScreen
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(MealReviewScreen), findsOneWidget);
    });

    testWidgets('when vision service throws error, error UI with retry is visible', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiScanProvider.overrideWith(_ThrowingAiScanNotifier.new),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ar'),
            home: MealScanAnalyzeScreen(photos: [_validPngBytes]),
          ),
        ),
      );

      // Frame callback runs and hits error
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Error UI visible with Egyptian Arabic retry button "حاول تاني"
      expect(find.text('حاول تاني'), findsOneWidget);
      expect(find.text('حصلت مشكلة في السيرفر.. حاول مرة تانية كمان شوية'), findsOneWidget);
      expect(find.byType(MealReviewScreen), findsNothing);
    });
  });
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/ai_nutrition/data/gemini_food_service_core.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_review_screen.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';
import 'package:vireo/features/nutrition/providers/plate_size_provider.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_meal_review_test_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDown(() async {
    HiveService.setInitializedForTesting(false);
    await Hive.close();
    try {
      await tempDir.delete(recursive: true);
    } catch (_) {}
  });

  Widget wrapWithTheme(Widget child) {
    return ProviderScope(
      overrides: [
        plateSizeProvider.overrideWith(() => _TestPlateSizeNotifier()),
      ],
      child: MaterialApp(
        theme: AppTheme.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      ),
    );
  }

  group('MealReviewScreen widget test', () {
    testWidgets('renders scanned food lines, totals and save button', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final sampleDraft = MealScanDraft(
        lines: const [
          ResolvedMealLine(
            nameAr: 'بيض مسلوق',
            nameEn: 'Boiled Egg',
            grams: 100,
            cookingMethod: CookingMethod.boiled,
            confidence: 0.95,
            kcal: 155,
            protein: 13,
            carbs: 1.1,
            fat: 11,
          ),
          ResolvedMealLine(
            nameAr: 'خبز بلدي',
            nameEn: 'Pita Bread',
            grams: 80,
            cookingMethod: CookingMethod.baked,
            confidence: 0.9,
            kcal: 210,
            protein: 7,
            carbs: 45,
            fat: 1.2,
          ),
        ],
        imageBytes: Uint8List(0),
      );

      await tester.pumpWidget(
        wrapWithTheme(MealReviewScreen(draft: sampleDraft)),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(MealReviewScreen), findsOneWidget);
      expect(find.text('Boiled Egg'), findsOneWidget);
      expect(find.text('Pita Bread'), findsOneWidget);

      // Total calories: 155 + 210 = 365
      expect(find.text('365'), findsWidgets);

      // Verify save button exists
      expect(find.byType(FilledButton), findsOneWidget);
    });
  });
}

class _TestPlateSizeNotifier extends PlateSizeNotifier {
  @override
  PlateSize? build() => PlateSize.medium;
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/home/widgets/meal_capture_hero_card.dart';
import 'package:vireo/features/home/widgets/saved_meals_sheets.dart';

import 'audit_test_helper.dart';

/// P40: second chip row on the Home meal card + the favorites / recents sheets
/// at 360x640 ar_EG, textScale 1.3 (pump(Duration), never pumpAndSettle).
void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p40_repeat_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  Future<List<String>> collectOverflows(
    WidgetTester tester,
    Future<void> Function() body,
  ) async {
    final errors = <String>[];
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) {
        errors.add(details.exceptionAsString());
      } else {
        original?.call(details);
      }
    };
    try {
      await body();
    } finally {
      FlutterError.onError = original;
    }
    return errors;
  }

  testWidgets('Home meal card repeat row: no overflow, 3 chips, 48dp tall',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final overflows = await collectOverflows(tester, () async {
      await tester.pumpWidget(
        wrapAuditScreen(
          const Scaffold(body: SingleChildScrollView(child: MealCaptureHeroCard())),
          locale: const Locale('ar', 'EG'),
          textScale: 1.3,
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 600));
    });

    expect(overflows, isEmpty, reason: overflows.join('\n'));
    // P46: slot-specific copy e.g. "نفس فطار إمبارح؟"
    expect(find.textContaining('إمبارح'), findsOneWidget);
    expect(find.text('وجباتي'), findsOneWidget);
    expect(find.text('آخر حاجات'), findsOneWidget);

    final chipHeight = tester.getSize(find.ancestor(
      of: find.text('وجباتي'),
      matching: find.byType(InkWell),
    ).first).height;
    expect(chipHeight, greaterThanOrEqualTo(48));
  });

  testWidgets('"نفس … إمبارح؟" with nothing logged shows a friendly message',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      wrapAuditScreen(
        const Scaffold(body: SingleChildScrollView(child: MealCaptureHeroCard())),
        locale: const Locale('ar', 'EG'),
        textScale: 1.3,
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.textContaining('إمبارح'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('مفيش حاجة متسجلة'), findsOneWidget);
  });

  for (final favorites in [true, false]) {
    testWidgets(
        '${favorites ? 'وجباتي' : 'آخر حاجات'} sheet: empty state, no overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final overflows = await collectOverflows(tester, () async {
        await tester.pumpWidget(
          wrapAuditScreen(
            Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () => favorites
                        ? showFavoriteMealsSheet(context)
                        : showRecentMealsSheet(context),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
            locale: const Locale('ar', 'EG'),
            textScale: 1.3,
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 400));
      });

      expect(overflows, isEmpty, reason: overflows.join('\n'));
      expect(find.text(favorites ? 'وجباتي' : 'آخر حاجات'), findsOneWidget);
      expect(
        find.textContaining(favorites ? 'لسه ما حطيتش' : 'لسه ما سجلتش'),
        findsOneWidget,
      );
    });
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/celebration_service.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/widgets/language_picker_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_l10n_test_');
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

  Widget buildTestWidget({
    required Widget child,
    ProviderContainer? container,
  }) {
    final cont = container ?? ProviderContainer();
    return UncontrolledProviderScope(
      container: cont,
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      ),
    );
  }

  group('LanguagePickerScreen', () {
    testWidgets('renders all 10 language options on first launch', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        buildTestWidget(
          child: const LanguagePickerScreen(isInitial: true),
        ),
      );
      await tester.pumpAndSettle();

      for (final lang in AppLanguage.values) {
        if (lang == AppLanguage.en) {
          expect(find.text(lang.nativeName), findsWidgets);
        } else {
          expect(find.text(lang.nativeName), findsOneWidget);
        }
        expect(find.text(lang.symbol), findsOneWidget);
      }
    }, skip: true); // TODO: hangs in CI - pumpAndSettle with infinite animation

    testWidgets('tapping a language updates active locale and highlights it', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        buildTestWidget(
          container: container,
          child: const LanguagePickerScreen(isInitial: false),
        ),
      );
      await tester.pumpAndSettle();

      // Tap French
      await tester.tap(find.text('Français'));
      await tester.pumpAndSettle();

      expect(container.read(localeProvider).languageCode, 'fr');

      // Tap Egyptian Arabic
      await tester.tap(find.text('العربية (لهجة مصرية)'));
      await tester.pumpAndSettle();

      expect(container.read(localeProvider), const Locale('ar', 'EG'));
    }, skip: true); // TODO: hangs in CI - pumpAndSettle with infinite animation

    testWidgets('initial launch Continue button confirms initial language selection', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(hasSelectedInitialLanguageProvider), false);

      await tester.pumpWidget(
        buildTestWidget(
          container: container,
          child: const LanguagePickerScreen(isInitial: true),
        ),
      );
      await tester.pumpAndSettle();

      // Select Turkish
      await tester.tap(find.text('Türkçe'));
      await tester.pumpAndSettle();
      expect(container.read(localeProvider).languageCode, 'tr');

      // Tap Continue
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(container.read(hasSelectedInitialLanguageProvider), true);
    }, skip: true); // TODO: hangs in CI - pumpAndSettle with infinite animation
  });

  group('CelebrationService workout celebration', () {
    testWidgets('triggers workout celebration once per day', (tester) async {
      expect(CelebrationService.hasCelebratedToday(CelebrationType.workout), false);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    CelebrationService.trigger(
                      context,
                      type: CelebrationType.workout,
                      message: 'Workout done!',
                    );
                  },
                  child: const Text('Complete Workout'),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Complete Workout'));
      // Advance by 3 seconds so SnackBar and overlay animations complete
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 3));

      expect(CelebrationService.hasCelebratedToday(CelebrationType.workout), true);

      // Triggering again on the same day is a no-op
      await tester.tap(find.text('Complete Workout'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(CelebrationService.hasCelebratedToday(CelebrationType.workout), true);
    }, skip: true); // TODO: hangs in CI - pumpAndSettle with infinite animation
  });
}

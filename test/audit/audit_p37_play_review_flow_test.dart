import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/constants/legal_urls.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/fasting/screens/fasting_screen.dart';
import 'package:vireo/features/measurements/screens/body_composition_screen.dart';
import 'package:vireo/features/nutrition/screens/manual_food_entry_screen.dart';
import 'package:vireo/features/onboarding/steps/step_welcome_screen.dart';
import 'package:vireo/features/profile/settings_screen.dart';

import 'audit_test_helper.dart';

/// Widget-test twin of `integration_test/play_review_flow_test.dart`
/// (no device / nuget required). pump(Duration) only.
void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p37_flow_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  testWidgets(
    'play review: onboarding → meal → fasting → body → settings privacy',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 640));

      Future<void> mount(Widget child) async {
        await tester.pumpWidget(
          wrapAuditScreen(child, locale: const Locale('ar', 'EG'), textScale: 1.0),
        );
        await tester.pump(const Duration(milliseconds: 400));
      }

      await mount(const StepWelcomeScreen());
      expect(find.byType(StepWelcomeScreen), findsOneWidget);

      await mount(const ManualFoodEntryScreen());
      expect(find.byType(ManualFoodEntryScreen), findsOneWidget);

      await mount(const FastingScreen());
      expect(find.byType(FastingScreen), findsOneWidget);

      await mount(const BodyCompositionScreen());
      expect(find.byType(BodyCompositionScreen), findsOneWidget);

      await mount(const SettingsScreen());
      expect(find.byType(SettingsScreen), findsOneWidget);

      final ctx = tester.element(find.byType(SettingsScreen));
      final l10n = AppLocalizations.of(ctx);
      await tester.scrollUntilVisible(
        find.text(l10n.settingsAboutTitle),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text(l10n.settingsAboutTitle), findsWidgets);
      expect(LegalUrls.privacyUrl(ctx), contains('privacy'));
      expect(LegalUrls.termsUrl(ctx), contains('terms'));
      expect(LegalUrls.deleteAccountUrl(), contains('delete-account'));
    },
  );
}

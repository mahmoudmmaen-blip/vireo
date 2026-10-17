import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vireo/core/constants/legal_urls.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/features/fasting/screens/fasting_screen.dart';
import 'package:vireo/features/measurements/screens/body_composition_screen.dart';
import 'package:vireo/features/nutrition/screens/manual_food_entry_screen.dart';
import 'package:vireo/features/onboarding/steps/step_welcome_screen.dart';
import 'package:vireo/features/profile/settings_screen.dart';

import 'ux_capture_helper.dart';

/// Play-review smoke path: onboarding → meal log (manual) → fasting →
/// body card → settings → privacy links.
///
/// Uses pump(Duration), never pumpAndSettle. Home is covered by dedicated
/// home audit tests (heavy google_fonts layout can hang flutter-tester).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await ensureUxHive();
  });

  testWidgets('play review flow mounts core screens and privacy links', (tester) async {
    const variant = UxCaptureVariant(
      locale: Locale('ar', 'EG'),
      themeKey: 'calm_gold_dark',
      variant: AppThemeVariant.calmGold,
      brightness: Brightness.dark,
      size: Size(360, 640),
      textScale: 1.0,
    );

    Future<void> mount(Widget child) async {
      await tester.binding.setSurfaceSize(variant.size);
      await tester.pumpWidget(wrapUxCapture(child: child, variant: variant));
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
    expect(LegalUrls.baseUrl.isNotEmpty, isTrue);
    expect(LegalUrls.privacyUrl(ctx), contains('privacy'));
    expect(LegalUrls.termsUrl(ctx), contains('terms'));
  });
}

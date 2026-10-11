import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/onboarding/steps/step_welcome_screen.dart';

void main() {
  Widget wrapWithTheme(Widget child) {
    return ProviderScope(
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

  group('StepWelcomeScreen (Onboarding first screen) widget test', () {
    testWidgets('renders title, branding, Continue button, and legal links', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(wrapWithTheme(const StepWelcomeScreen()));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(StepWelcomeScreen), findsOneWidget);

      // Verify branding and value prop
      expect(find.text('VIREO'), findsOneWidget);
      expect(
        find.text('Smart nutrition & intelligent fitness built specifically for men.'),
        findsOneWidget,
      );

      // Verify Continue button
      expect(find.text('Continue'), findsOneWidget);

      // Verify legal compliance links
      expect(find.text('Terms'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Medical Disclaimer'), findsOneWidget);
    });
  });
}

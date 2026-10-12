import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/onboarding/steps/step_body_screen.dart';

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
        home: Scaffold(body: child),
      ),
    );
  }

  group('StepBodyScreen widget test', () {
    testWidgets('pumps StepBodyScreen inside ProviderScope without provider modification crash', (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(wrapWithTheme(const StepBodyScreen()));
      // Allow post-frame callbacks and animations to run
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(StepBodyScreen), findsOneWidget);
      expect(find.text('Your Body Profile'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Height'), findsOneWidget);
      expect(find.text('Current Weight'), findsOneWidget);
      expect(find.text('Target Weight'), findsOneWidget);
    });
  });
}

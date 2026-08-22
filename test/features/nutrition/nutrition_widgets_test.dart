import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/nutrition/widgets/ingredient_editor.dart';
import 'package:vireo/features/nutrition/widgets/scan_quota_banner.dart';

void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  group('ScanQuotaBanner §2.6 rate-limit display', () {
    testWidgets('shows remaining scans for basic tier', (tester) async {
      await tester.pumpWidget(wrap(const ScanQuotaBanner(remaining: 3)));
      await tester.pumpAndSettle();

      expect(find.textContaining('3'), findsOneWidget);
    });
  });

  group('IngredientEditor §2.6 detected item chips', () {
    testWidgets('renders ingredient chips with delete affordance', (tester) async {
      var ingredients = ['Eggs', 'Tomatoes'];

      await tester.pumpWidget(
        wrap(
          IngredientEditor(
            ingredients: ingredients,
            onChanged: (items) => ingredients = items,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Eggs'), findsOneWidget);
      expect(find.text('Tomatoes'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(2));
    });
  });
}

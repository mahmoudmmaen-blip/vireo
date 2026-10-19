import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_component_chips.dart';
import 'package:vireo/features/nutrition/data/food_db_models.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('ar', 'EG'),
      theme: AppTheme.dark,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)),
    );
  }

  testWidgets('P54 chips show name grams kcal and add chip', (tester) async {
    var lines = <ResolvedMealLine>[
      const ResolvedMealLine(
        nameAr: 'صدر فراخ',
        nameEn: 'Chicken breast',
        grams: 120,
        cookingMethod: CookingMethod.grilled,
        confidence: 0.9,
        kcal: 198,
        protein: 36,
        carbs: 0,
        fat: 4,
      ),
    ];

    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return MealComponentChips(
              lines: lines,
              isArabic: true,
              onChanged: (i, updated) => setState(() => lines[i] = updated),
              onRemove: (i) => setState(() => lines.removeAt(i)),
              onAdd: () {},
            );
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('صدر فراخ'), findsOneWidget);
    expect(find.textContaining('120جم'), findsOneWidget);
    expect(find.textContaining('≈198'), findsOneWidget);
    expect(find.text('إضافة مكوّن'), findsOneWidget);
  });

  testWidgets('P54 remove chip X clears the component', (tester) async {
    var lines = <ResolvedMealLine>[
      const ResolvedMealLine(
        nameAr: 'أرز مطبوخ',
        nameEn: 'Cooked rice',
        grams: 150,
        cookingMethod: CookingMethod.boiled,
        confidence: 0.9,
        kcal: 195,
        protein: 4,
        carbs: 42,
        fat: 0.5,
      ),
    ];

    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return MealComponentChips(
              lines: lines,
              isArabic: true,
              onChanged: (i, updated) => setState(() => lines[i] = updated),
              onRemove: (i) => setState(() => lines.removeAt(i)),
              onAdd: () {},
            );
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(lines, isEmpty);
    expect(find.textContaining('مفيش مكوّنات'), findsOneWidget);
  });
}

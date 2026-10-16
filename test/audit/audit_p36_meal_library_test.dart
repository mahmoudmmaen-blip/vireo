import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/ai_nutrition/widgets/meal_correction_sheet.dart';
import 'package:vireo/features/diet_programs/domain/diet_program.dart';
import 'package:vireo/features/diet_programs/screens/program_meal_library_screen.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';
import 'package:vireo/features/measurements/providers/body_composition_provider.dart';
import 'package:vireo/features/profile/widgets/profile_body_composition_card.dart';

Widget _wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.dark,
      locale: const Locale('ar', 'EG'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, w) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.3)),
        child: w!,
      ),
      home: Material(child: child),
    ),
  );
}

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
}

void main() {
  testWidgets('program meal library: all slots + filters, no overflow',
      (tester) async {
    _phone(tester);
    await tester.pumpWidget(
      _wrap(
        const ProgramMealLibraryScreen(
          programId: DietProgramId.keto,
          programName: L10nText('الكيتو', 'Keto'),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);

    for (final slot in ['lunch', 'dinner', 'snack', 'breakfast']) {
      await tester.tap(find.byKey(ValueKey('slot_$slot')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull, reason: slot);
    }

    await tester.tap(find.text('من غير طبخ'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('سحور'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile body card: empty state and with data', (tester) async {
    _phone(tester);
    await tester.pumpWidget(
      _wrap(
        const ProfileBodyCompositionCard(),
        overrides: [latestBodyCompositionProvider.overrideWithValue(null)],
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('صوّر تقرير InBody'), findsOneWidget);
    expect(find.text('قيس بالشريط'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _wrap(
        const ProfileBodyCompositionCard(),
        overrides: [
          latestBodyCompositionProvider.overrideWithValue(
            BodyCompositionReport(
              id: 'r1',
              testDate: DateTime(2026, 10, 1),
              weightKg: 82,
              skeletalMuscleMassKg: 36.4,
              percentBodyFat: 24.5,
              visceralFatLevel: 8,
            ),
          ),
        ],
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('24.5%'), findsOneWidget);
    expect(find.textContaining('36.4'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('correction sheet: submit success closes, error is shown',
      (tester) async {
    _phone(tester);
    var calls = 0;
    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (ctx) => Center(
            child: ElevatedButton(
              onPressed: () => MealCorrectionSheet.show(
                ctx,
                isArabic: true,
                onSubmit: (text) async => ++calls == 1 ? 'فيه مشكلة' : null,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('عدّل النتيجة'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'ده سلمون مش فراخ، 150 جم');
    await tester.tap(find.text('طبّق التعديل'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('فيه مشكلة'), findsOneWidget);

    await tester.tap(find.text('طبّق التعديل'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('عدّل النتيجة'), findsNothing);
    expect(calls, 2);
    expect(tester.takeException(), isNull);
  });
}

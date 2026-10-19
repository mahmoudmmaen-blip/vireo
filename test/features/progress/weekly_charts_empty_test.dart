import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/core/theme/app_theme_variant.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/progress/models/daily_deficit_entry.dart';
import 'package:vireo/features/progress/widgets/weekly_calories_intake_chart.dart';
import 'package:vireo/features/progress/widgets/weekly_steps_fl_chart.dart';

void main() {
  Widget wrap(Widget child, {Locale locale = const Locale('ar', 'EG')}) {
    return MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.buildThemeForVariant(
        variant: AppThemeVariant.ember,
        brightness: Brightness.dark,
        languageCode: locale.languageCode,
      ),
      home: Scaffold(body: child),
    );
  }

  testWidgets('P53 steps empty state shows friendly Arabic copy', (tester) async {
    final today = DateTime.now();
    final days = List.generate(
      7,
      (i) => DailyStepCount(
        date: DateTime(today.year, today.month, today.day)
            .subtract(Duration(days: 6 - i)),
        steps: 0,
      ),
    );

    await tester.pumpWidget(
      wrap(WeeklyStepsFlChart(days: days, goal: 8000)),
    );
    await tester.pump();

    expect(find.textContaining('لسه مفيش خطوات'), findsOneWidget);
    expect(find.byType(WeeklyStepsFlChart), findsOneWidget);
  });

  testWidgets('P53 calories empty state shows friendly Arabic copy', (tester) async {
    final today = DateTime.now();
    final days = List.generate(
      7,
      (i) => DailyDeficitEntry(
        date: DateTime(today.year, today.month, today.day)
            .subtract(Duration(days: 6 - i)),
        tdee: 2000,
        consumed: 0,
        burned: 0,
        isToday: i == 6,
      ),
    );

    await tester.pumpWidget(
      wrap(
        WeeklyCaloriesIntakeChart(
          summary: WeeklyDeficitSummary(
            days: days,
            totalNetKcal: 0,
            hasData: false,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('لسه ما سجلتش وجبات'), findsOneWidget);
  });
}

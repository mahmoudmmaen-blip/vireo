import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/data/models/daily_step_count.dart';
import 'package:vireo/features/walking/widgets/step_ring_indicator.dart';
import 'package:vireo/features/walking/widgets/weekly_steps_chart.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: child),
    );
  }

  group('StepRingIndicator §2.5 circular progress ring', () {
    testWidgets('displays today steps and goal label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const StepRingIndicator(
            steps: 4200,
            goal: 7500,
            stepsLabel: 'steps today',
            goalLabel: 'Goal: 7,500 steps',
          ),
        ),
      );

      expect(find.text('4,200'), findsOneWidget);
      expect(find.text('steps today'), findsOneWidget);
      expect(find.text('Goal: 7,500 steps'), findsOneWidget);
      expect(find.byType(StepRingIndicator), findsOneWidget);
    });
  });

  group('WeeklyStepsChart §2.5 seven-day bar chart', () {
    testWidgets('renders 7 day bars', (tester) async {
      final days = List.generate(
        7,
        (i) => DailyStepCount(
          date: DateTime(2026, 8, 16 + i),
          steps: 500 * (i + 1),
        ),
      );

      await tester.pumpWidget(
        wrap(
          WeeklyStepsChart(
            days: days,
            title: 'Last 7 days',
            goal: 7500,
          ),
        ),
      );

      expect(find.text('Last 7 days'), findsOneWidget);
      expect(find.byType(FractionallySizedBox), findsNWidgets(7));
    });
  });
}

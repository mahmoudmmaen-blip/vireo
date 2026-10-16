import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/home/mascot/domain/mascot_companion.dart';
import 'package:vireo/features/home/mascot/widgets/calorie_mascot_wave.dart';

void main() {
  testWidgets('off-screen / TickerMode.pause stops wave animation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: TickerMode(
            enabled: false,
            child: CalorieMascotWave(
              consumedKcal: 1000,
              targetKcal: 2000,
              companion: MascotCompanion.panda,
              showCaption: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    final state = tester.state<CalorieMascotWaveState>(find.byType(CalorieMascotWave));
    expect(state.isAnimationPaused, isTrue);
  });

  testWidgets('reduce motion keeps static fill', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: CalorieMascotWave(
              consumedKcal: 500,
              targetKcal: 2000,
              companion: MascotCompanion.cat,
              showCaption: true,
              isFemale: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(CalorieMascotWave), findsOneWidget);
    final state = tester.state<CalorieMascotWaveState>(find.byType(CalorieMascotWave));
    expect(state.isAnimationPaused, isTrue);
  });

  testWidgets('over badge shows when >105%', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: CalorieMascotWave(
            consumedKcal: 2400,
            targetKcal: 2000,
            companion: MascotCompanion.owl,
            showCaption: false,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byKey(const ValueKey('mascot_over_badge')), findsOneWidget);
  });
}

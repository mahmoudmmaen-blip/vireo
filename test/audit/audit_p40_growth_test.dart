import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/features/home/widgets/home_widget_preview.dart';
import 'package:vireo/features/progress/screens/weekly_burn_share_screen.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

import 'audit_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testScreenOverflow('PaywallScreen P40', () => const PaywallScreen());

  testWidgets('HomeWidgetPreview @ 360x640 ar_EG 1.3', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      wrapAuditScreen(
        const Center(child: HomeWidgetPreview(fastingCountdown: '⏳ 2:15 للإفطار')),
        locale: const Locale('ar', 'EG'),
        textScale: 1.3,
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(HomeWidgetPreview), findsOneWidget);
  });

  testWidgets('WeeklyBurnShareCard @ 360x640 ar_EG 1.3', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      wrapAuditScreen(
        const Center(
          child: WeeklyBurnShareCard(
            title: 'رصيد حرقك الأسبوع ده',
            stepsTotal: 42000,
            streakDays: 5,
            mascotEmoji: '😊',
            includeWeight: false,
            weightDeltaKg: -0.3,
          ),
        ),
        locale: const Locale('ar', 'EG'),
        textScale: 1.3,
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('42000'), findsOneWidget);
  });
}

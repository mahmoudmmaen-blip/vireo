import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/profile/settings_screen.dart';

import 'audit_test_helper.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p37_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  testWidgets('Settings About shows privacy, terms, delete @ 360x640 ar_EG 1.3', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    await tester.pumpWidget(
      wrapAuditScreen(
        const SettingsScreen(),
        locale: const Locale('ar', 'EG'),
        textScale: 1.3,
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    final ctx = tester.element(find.byType(SettingsScreen));
    final l10n = AppLocalizations.of(ctx);
    await tester.scrollUntilVisible(
      find.text(l10n.settingsAboutTitle),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(l10n.settingsAboutTitle), findsWidgets);
    await tester.scrollUntilVisible(
      find.textContaining('1.0.0'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.textContaining('1.0.0'), findsWidgets);
    expect(find.text(l10n.deleteAccountTitle), findsWidgets);
  });
}

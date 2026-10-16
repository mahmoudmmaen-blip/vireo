import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/home/widgets/today_plan_section.dart';

import 'audit_test_helper.dart';

const _allowedLatin = {'Vireo', 'InBody', 'Pro', 'BMI', 'HIIT', 'RPE'};
final _latinWord = RegExp(r'[A-Za-z]{3,}');

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('vireo_p36_latin_');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(HiveService.settingsBoxName);
    await Hive.openBox<dynamic>(HiveService.cacheBoxName);
    await Hive.openBox<dynamic>(HiveService.bodyMeasurementsBoxName);
    HiveService.setInitializedForTesting(true);
  });

  tearDownAll(() async {
    HiveService.setInitializedForTesting(false);
  });

  testWidgets(
    'ar_EG Today Plan does not render Latin words except brand names',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        wrapAuditScreen(
          const Scaffold(
            body: SingleChildScrollView(child: TodayPlanSection()),
          ),
          locale: const Locale('ar', 'EG'),
          textScale: 1.3,
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      final texts = <String>[];
      void walk(Element el) {
        final w = el.widget;
        if (w is Text && w.data != null) texts.add(w.data!);
        if (w is RichText) texts.add(w.text.toPlainText());
        el.visitChildren(walk);
      }

      final root = find.byType(TodayPlanSection);
      if (root.evaluate().isEmpty) return;
      tester.element(root).visitChildren(walk);

      final offenders = <String>[];
      for (final t in texts) {
        for (final m in _latinWord.allMatches(t)) {
          final word = m.group(0)!;
          if (_allowedLatin.any((b) => word.toLowerCase() == b.toLowerCase())) {
            continue;
          }
          offenders.add('$word in "$t"');
        }
      }

      expect(
        offenders,
        isEmpty,
        reason: 'Latin words in ar_EG Today Plan: $offenders',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}

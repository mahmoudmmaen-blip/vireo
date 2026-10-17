import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// COPY RULE: never use shame/blame words in any ARB locale.
void main() {
  test('ARB files never contain blame words', () {
    const banned = ['عقاب', 'عقوبة', 'غلطت', 'فشلت', 'ذنب'];
    final dir = Directory('lib/core/l10n');
    final arbs = dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .toList();
    expect(arbs, isNotEmpty);
    for (final file in arbs) {
      final text = file.readAsStringSync();
      for (final word in banned) {
        expect(
          text.contains(word),
          isFalse,
          reason: '${file.path} contains banned word "$word"',
        );
      }
    }
  });
}

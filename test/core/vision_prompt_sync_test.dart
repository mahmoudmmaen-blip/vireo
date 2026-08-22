import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/config/fridge_vision_prompt.dart';

String _normalize(String text) =>
    text.replaceAll(RegExp(r'\s+'), ' ').trim();

String _extractTsConst(String source, String constName) {
  final backtickMarker = 'export const $constName = `';
  final backtickStart = source.indexOf(backtickMarker);
  if (backtickStart >= 0) {
    final from = backtickStart + backtickMarker.length;
    final end = source.indexOf('`;', from);
    expect(end, greaterThan(from));
    return source.substring(from, end);
  }

  final quoteMarker = "export const $constName = '";
  final quoteStart = source.indexOf(quoteMarker);
  expect(quoteStart, greaterThanOrEqualTo(0), reason: '$constName missing');
  final from = quoteStart + quoteMarker.length;
  final end = source.indexOf("';", from);
  expect(end, greaterThan(from));
  return source.substring(from, end);
}

void main() {
  group('§4 Fridge vision prompt sync', () {
    late String tsSource;

    setUpAll(() {
      tsSource = File(
        'supabase/functions/_shared/prompts/fridge-vision.ts',
      ).readAsStringSync();
    });

    test('Dart system prompt matches TypeScript canonical source', () {
      expect(
        _normalize(FridgeVisionPrompt.system),
        _normalize(_extractTsConst(tsSource, 'FRIDGE_VISION_SYSTEM_PROMPT')),
      );
    });

    test('Dart user message matches TypeScript canonical source', () {
      expect(
        tsSource,
        contains(FridgeVisionPrompt.userMessage),
      );
    });

    test('prompt requires Arabic ingredient array only', () {
      expect(FridgeVisionPrompt.system, contains('JSON array'));
      expect(FridgeVisionPrompt.system, contains('Arabic'));
    });
  });
}

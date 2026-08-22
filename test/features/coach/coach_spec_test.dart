import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/config/ai_coach_prompt.dart';
import 'package:vireo/core/config/app_config.dart';

String _normalize(String text) =>
    text.replaceAll(RegExp(r'\s+'), ' ').trim();

String _extractTsPrompt(String source) {
  const marker = 'export const AI_COACH_SYSTEM_PROMPT = `';
  final start = source.indexOf(marker);
  expect(start, greaterThanOrEqualTo(0), reason: 'TS prompt marker missing');
  final from = start + marker.length;
  final end = source.indexOf('`;', from);
  expect(end, greaterThan(from), reason: 'TS prompt closing backtick missing');
  return source.substring(from, end);
}

void main() {
  group('§3 AI Coach prompt sync', () {
    late String tsSource;

    setUpAll(() {
      tsSource = File(
        'supabase/functions/_shared/prompts/ai-coach.ts',
      ).readAsStringSync();
    });

    test('Dart mirror matches canonical TypeScript system prompt', () {
      expect(
        _normalize(AiCoachPrompt.system),
        _normalize(_extractTsPrompt(tsSource)),
      );
    });

    test('prompt requires strict JSON output contract', () {
      expect(AiCoachPrompt.system, contains('Output ONLY valid JSON'));
      expect(AiCoachPrompt.system, contains('training_environment'));
    });
  });

  group('§3 generate-program edge function', () {
    test('function name matches Supabase deployment', () {
      expect(AppConfig.generateProgramFunctionName, 'generate-program');
    });
  });
}

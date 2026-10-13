import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/app_theme.dart';
import 'package:vireo/features/home/widgets/premium_steps_hero_card.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

void main() {
  testWidgets('Rapid double-tap on step start/pause button ends in consistent state without crashing', (tester) async {
    // TODO: Foreground task platform channel calls hang in headless test runner without mock platform interface
  }, skip: true);
}

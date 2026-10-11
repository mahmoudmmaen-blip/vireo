import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/home/widgets/home_dashboard_body.dart';

import 'package:vireo/features/progress/providers/progress_extended_provider.dart';
import 'package:vireo/features/progress/widgets/adaptive_calorie_suggestion_card.dart';

/// "Today" — the daily command centre.
///
/// No AppBar: the dashboard renders its own header (greeting, streak,
/// profile avatar). Logging lives in the shell's centre "+" button, and the
/// AI coach is one tap away in the quick actions row.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final showAdaptive = ref.watch(showAdaptiveCalorieCardProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (showAdaptive)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: AdaptiveCalorieSuggestionCard(),
              ),
            const Expanded(child: HomeDashboardBody()),
          ],
        ),
      ),
    );
  }
}

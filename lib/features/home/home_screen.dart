import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/home/widgets/home_dashboard_body.dart';

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

    return Scaffold(
      backgroundColor: colors.background,
      body: const SafeArea(bottom: false, child: HomeDashboardBody()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/widgets/language_selector.dart';
import 'package:vireo/core/widgets/vireo_app_bar_title.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ai_coach/widgets/ai_coach_fab.dart';
import 'package:vireo/features/home/widgets/home_dashboard_body.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const VireoAppBarTitle(),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: LanguageSelector(compact: true),
          ),
        ],
      ),
      body: const HomeDashboardBody(),
      floatingActionButton: const AiCoachFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

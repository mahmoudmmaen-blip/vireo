import 'package:flutter/material.dart';
import 'package:vireo/core/animations/vireo_animations.dart';
import 'package:vireo/core/navigation/vireo_page_routes.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/vireo_fab.dart';
import 'package:vireo/features/ai_coach/screens/ai_coach_screen.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class AiCoachFab extends StatelessWidget {
  const AiCoachFab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return BounceLoop(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              VBridge.cFF7C3AED,
              colors.ember,
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: VBridge.cFF7C3AED.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: VireoExtendedFab(
          onPressed: () {
            Navigator.of(context).push(
              SlideUpRoute<void>(page: const AiCoachScreen()),
            );
          },
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.support_agent_outlined),
          label: Text(l10n.aiCoachFabLabel),
        ),
      ),
    );
  }
}

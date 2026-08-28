import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';

class QuickAiScannerCard extends StatelessWidget {
  const QuickAiScannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colors.surfaceGradientStart,
            colors.ember.withValues(alpha: 0.25),
            colors.surfaceGradientEnd,
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        border: Border.all(color: colors.ember.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: colors.ember),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.aiScanCardTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.aiScanCardSubtitle,
            style: TextStyle(color: colors.textMute, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => AiScanScreen.open(context, fromCamera: true),
                  icon: const Icon(Icons.camera_alt_outlined, size: 20),
                  label: Text(l10n.aiScanCamera),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => AiScanScreen.open(context, fromCamera: false),
                  icon: const Icon(Icons.photo_library_outlined, size: 20),
                  label: Text(l10n.aiScanGallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

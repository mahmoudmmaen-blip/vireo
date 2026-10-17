import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

/// In-app preview of the 2×2 home widget for audit tests.
class HomeWidgetPreview extends StatelessWidget {
  const HomeWidgetPreview({
    super.key,
    this.caloriesRemaining = 820,
    this.mascotEmoji = '😊',
    this.fastingCountdown,
    this.isDark = true,
  });

  final int caloriesRemaining;
  final String mascotEmoji;
  final String? fastingCountdown;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bg = isDark ? const Color(0xFF121826) : const Color(0xFFF9FAFB);
    final mute = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final accent = context.vireoColors.success;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 160,
        height: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: mute.withValues(alpha: 0.35)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mascotEmoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                l10n.widgetCaloriesLeftLabel,
                style: TextStyle(color: mute, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                '$caloriesRemaining',
                style: TextStyle(
                  color: accent,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (fastingCountdown != null) ...[
                const SizedBox(height: 6),
                SizedBox(
                  width: 130,
                  child: Text(
                    fastingCountdown!,
                    style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text('Vireo', style: TextStyle(color: mute, fontSize: 9, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }
}

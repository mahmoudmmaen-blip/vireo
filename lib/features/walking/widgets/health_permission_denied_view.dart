import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

class HealthPermissionDeniedView extends StatelessWidget {
  const HealthPermissionDeniedView({
    super.key,
    required this.onOpenSettings,
    this.onRetry,
    this.isUnavailable = false,
  });

  final VoidCallback onOpenSettings;
  final VoidCallback? onRetry;
  final bool isUnavailable;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnavailable ? Icons.devices_other : Icons.health_and_safety_outlined,
            size: 64,
            color: colors.textMute,
          ),
          const SizedBox(height: 24),
          Text(
            isUnavailable
                ? l10n.walkingUnavailableTitle
                : l10n.walkingPermissionTitle,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isUnavailable
                ? l10n.walkingUnavailableBody
                : l10n.walkingPermissionBody,
            style: TextStyle(color: colors.textMute, height: 1.45),
            textAlign: TextAlign.center,
          ),
          if (!isUnavailable) ...[
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onOpenSettings,
              child: Text(l10n.walkingOpenSettings),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRetry,
                child: Text(l10n.walkingTryAgain),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/profile/delete_account_confirm_screen.dart';

class DeleteAccountWarningScreen extends StatelessWidget {
  const DeleteAccountWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.deleteAccountTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.warning_amber_rounded, size: 64, color: colors.danger),
            const SizedBox(height: 24),
            Text(
              l10n.deleteAccountWarningTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(l10n.deleteAccountWarningBody),
            const Spacer(),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.deleteAccountCancel),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colors.danger),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const DeleteAccountConfirmScreen(),
                ),
              ),
              child: Text(l10n.deleteAccountContinue),
            ),
          ],
        ),
      ),
    );
  }
}

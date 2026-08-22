import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';

class DeleteAccountConfirmScreen extends ConsumerStatefulWidget {
  const DeleteAccountConfirmScreen({super.key});

  @override
  ConsumerState<DeleteAccountConfirmScreen> createState() =>
      _DeleteAccountConfirmScreenState();
}

class _DeleteAccountConfirmScreenState
    extends ConsumerState<DeleteAccountConfirmScreen> {
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authProvider.notifier).deleteAccount();
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).deleteAccountSuccess)),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final expected = l10n.deleteConfirmationWord;
    final matches = _confirmCtrl.text == expected;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.deleteAccountConfirmTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.deleteAccountConfirmInstructions),
            const SizedBox(height: 8),
            Text(
              expected,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.danger,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.deleteAccountTypeHint,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: colors.danger)),
            ],
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.danger,
                disabledBackgroundColor: colors.surfaceRaised,
              ),
              onPressed: matches && !_loading ? _delete : null,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.deleteAccountConfirmButton),
            ),
          ],
        ),
      ),
    );
  }
}

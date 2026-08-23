import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/language_selector.dart';
import 'package:vireo/core/widgets/vireo_logo.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isSignUp = false;
  bool _showEmailForm = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) Navigator.of(context).maybePop();
    } catch (e) {
      setState(() => _error = AppLocalizations.of(context).authErrorGeneric);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LanguageSelector(),
              const SizedBox(height: 24),
              const Center(child: VireoLogo(size: 56)),
              const SizedBox(height: 20),
              Text(
                l10n.authWelcomeTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.authWelcomeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_error!, style: TextStyle(color: colors.danger)),
                ),
              if (Platform.isIOS || Platform.isMacOS)
                _SocialButton(
                  label: l10n.signInWithApple,
                  icon: Icons.apple,
                  onPressed: _loading
                      ? null
                      : () => _run(
                            () => ref.read(authProvider.notifier).signInWithApple(),
                          ),
                ),
              if (Platform.isIOS || Platform.isMacOS) const SizedBox(height: 12),
              _SocialButton(
                label: l10n.signInWithGoogle,
                icon: Icons.g_mobiledata,
                onPressed: _loading
                    ? null
                    : () => _run(
                          () => ref.read(authProvider.notifier).signInWithGoogle(),
                        ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _loading
                    ? null
                    : () => setState(() => _showEmailForm = !_showEmailForm),
                child: Text(l10n.signInWithEmail),
              ),
              if (_showEmailForm) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: l10n.authEmail),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: l10n.authPassword),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(_isSignUp ? l10n.authHasAccount : l10n.authNoAccount),
                    TextButton(
                      onPressed: () => setState(() => _isSignUp = !_isSignUp),
                      child: Text(_isSignUp ? l10n.authSignIn : l10n.authSignUp),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () => _run(() {
                            if (_isSignUp) {
                              return ref.read(authProvider.notifier).signUpWithEmail(
                                    email: _emailCtrl.text,
                                    password: _passwordCtrl.text,
                                  );
                            }
                            return ref.read(authProvider.notifier).signInWithEmail(
                                  email: _emailCtrl.text,
                                  password: _passwordCtrl.text,
                                );
                          }),
                  child: Text(_isSignUp ? l10n.authSignUp : l10n.authSignIn),
                ),
              ],
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _loading
                    ? null
                    : () => _run(
                          () => ref.read(authProvider.notifier).continueAsGuest(),
                        ),
                child: Text(l10n.continueAsGuest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
      ),
    );
  }
}

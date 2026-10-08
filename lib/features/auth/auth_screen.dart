import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/utils/platform_utils.dart';
import 'package:vireo/core/widgets/language_selector.dart';
import 'package:vireo/core/widgets/vireo_logo.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/auth/utils/auth_error_mapper.dart';

enum _AuthView { main, email, otp, password }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  _AuthView _view = _AuthView.main;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _otpCtrls = List.generate(6, (_) => TextEditingController());
  final _otpFocus = List.generate(6, (_) => FocusNode());

  bool _loading = false;
  String? _error;
  int _resendSeconds = 0;
  Timer? _resendTimer;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    for (final f in _otpFocus) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendSeconds <= 1) {
        t.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  Future<void> _run(Future<void> Function() action, {bool popOnSuccess = true}) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await action();
      if (mounted && popOnSuccess) Navigator.of(context).maybePop();
    } catch (e) {
      if (mounted) {
        setState(() => _error = mapAuthError(e, l10n));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String get _otpCode => _otpCtrls.map((c) => c.text).join();

  Future<void> _sendOtp() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _error = AppLocalizations.of(context).authErrorInvalidEmail);
      return;
    }
    await _run(() async {
      await ref.read(authProvider.notifier).sendEmailCode(email);
      if (!mounted) return;
      setState(() => _view = _AuthView.otp);
      _startResendCooldown();
      _otpFocus.first.requestFocus();
    }, popOnSuccess: false);
  }

  Future<void> _verifyOtp() async {
    final code = _otpCode;
    if (code.length != 6) {
      setState(() => _error = AppLocalizations.of(context).authErrorWrongCode);
      return;
    }
    await _run(
      () => ref.read(authProvider.notifier).verifyEmailCode(
            email: _emailCtrl.text.trim(),
            token: code,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: canPop
          ? AppBar(
              backgroundColor: colors.background,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(VSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LanguageSelector(),
              const SizedBox(height: VSpace.xl),
              const Center(child: VireoLogo(size: 56)),
              const SizedBox(height: VSpace.md),
              Text(
                l10n.authSaveProgressTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: VSpace.sm),
              Text(
                l10n.authSaveProgressSubtitle,
                style: TextStyle(color: colors.textMute, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: VSpace.xl),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: VSpace.md),
                  child: VireoCard(
                    color: colors.danger.withValues(alpha: 0.1),
                    borderColor: colors.danger.withValues(alpha: 0.35),
                    child: Text(
                      _error!,
                      style: TextStyle(color: colors.danger, height: 1.35),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              switch (_view) {
                _AuthView.main => _buildMain(l10n),
                _AuthView.email => _buildEmail(l10n),
                _AuthView.otp => _buildOtp(l10n, colors),
                _AuthView.password => _buildPassword(l10n),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMain(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (PlatformUtils.isIOS || PlatformUtils.isWeb) ...[
          FilledButton.icon(
            onPressed: _loading
                ? null
                : () => _run(() => ref.read(authProvider.notifier).signInWithApple()),
            icon: const Icon(Icons.apple),
            label: Text(l10n.authContinueApple),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          ),
          const SizedBox(height: VSpace.sm),
        ],
        FilledButton.tonalIcon(
          onPressed: _loading
              ? null
              : () => _run(() => ref.read(authProvider.notifier).signInWithGoogle()),
          icon: const Icon(Icons.g_mobiledata, size: 28),
          label: Text(l10n.authContinueGoogle),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
        const SizedBox(height: VSpace.sm),
        OutlinedButton.icon(
          onPressed: _loading
              ? null
              : () => setState(() {
                    _view = _AuthView.email;
                    _error = null;
                  }),
          icon: const Icon(Icons.mail_outline),
          label: Text(l10n.authContinueEmail),
          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
        const SizedBox(height: VSpace.lg),
        TextButton(
          onPressed: _loading
              ? null
              : () => setState(() {
                    _view = _AuthView.password;
                    _error = null;
                  }),
          child: Text(l10n.authSignInWithPassword),
        ),
        if (!Navigator.of(context).canPop()) ...[
          const SizedBox(height: VSpace.sm),
          TextButton(
            onPressed: _loading
                ? null
                : () => _run(() => ref.read(authProvider.notifier).continueAsGuest()),
            child: Text(l10n.continueAsGuest),
          ),
        ],
      ],
    );
  }

  Widget _buildEmail(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: InputDecoration(
            labelText: l10n.authEmail,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: VSpace.md),
        FilledButton(
          onPressed: _loading ? null : _sendOtp,
          child: Text(l10n.authSendCode),
        ),
        TextButton(
          onPressed: _loading
              ? null
              : () => setState(() {
                    _view = _AuthView.main;
                    _error = null;
                  }),
          child: Text(l10n.authBack),
        ),
      ],
    );
  }

  Widget _buildOtp(AppLocalizations l10n, VireoColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.authOtpSentTo(_emailCtrl.text.trim()),
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.textMute),
        ),
        const SizedBox(height: VSpace.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) {
            return SizedBox(
              width: 46,
              child: TextField(
                controller: _otpCtrls[i],
                focusNode: _otpFocus[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: VType.number(size: 22),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {
                  if (v.isNotEmpty && i < 5) {
                    _otpFocus[i + 1].requestFocus();
                  }
                  if (v.isEmpty && i > 0) {
                    _otpFocus[i - 1].requestFocus();
                  }
                  if (_otpCode.length == 6) {
                    _verifyOtp();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: VSpace.lg),
        FilledButton(
          onPressed: _loading ? null : _verifyOtp,
          child: Text(l10n.authVerifyCode),
        ),
        const SizedBox(height: VSpace.sm),
        TextButton(
          onPressed: (_loading || _resendSeconds > 0)
              ? null
              : () async {
                  await _run(() async {
                    await ref
                        .read(authProvider.notifier)
                        .sendEmailCode(_emailCtrl.text.trim());
                    _startResendCooldown();
                  }, popOnSuccess: false);
                },
          child: Text(
            _resendSeconds > 0
                ? l10n.authResendIn(_resendSeconds)
                : l10n.authResendCode,
          ),
        ),
        TextButton(
          onPressed: _loading
              ? null
              : () => setState(() {
                    _view = _AuthView.email;
                    _error = null;
                  }),
          child: Text(l10n.authBack),
        ),
      ],
    );
  }

  Widget _buildPassword(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: l10n.authEmail,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: VSpace.sm),
        TextField(
          controller: _passwordCtrl,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.authPassword,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: VSpace.md),
        FilledButton(
          onPressed: _loading
              ? null
              : () => _run(
                    () => ref.read(authProvider.notifier).signInWithEmail(
                          email: _emailCtrl.text,
                          password: _passwordCtrl.text,
                        ),
                  ),
          child: Text(l10n.authSignIn),
        ),
        TextButton(
          onPressed: _loading
              ? null
              : () => setState(() {
                    _view = _AuthView.main;
                    _error = null;
                  }),
          child: Text(l10n.authBack),
        ),
      ],
    );
  }
}

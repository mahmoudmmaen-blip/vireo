import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/services/app_init_provider.dart';
import 'package:vireo/core/widgets/app_loading.dart';
import 'package:vireo/core/widgets/main_shell.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/auth_screen.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/onboarding/onboarding_screen.dart';
import 'package:vireo/features/onboarding/providers/onboarding_provider.dart';

/// Routes through auth → onboarding → main app.
class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(appInitProvider);
    final onboardingComplete = ref.watch(onboardingCompleteProvider);

    return _MinSplash(
      child: init.when(
        loading: () => const AppLoading(),
        error: (_, _) => _InitError(onRetry: () {
          ref.read(appInitProvider.notifier).retry();
        }),
        data: (status) {
          if (status == AppInitStatus.error) {
            return _InitError(onRetry: () {
              ref.read(appInitProvider.notifier).retry();
            });
          }

          final auth = ref.watch(authProvider);

          return auth.when(
            loading: () => const AppLoading(),
            error: (_, __) => const AuthScreen(),
            data: (authState) {
              if (authState is AppAuthUnauthenticated) {
                return const AuthScreen();
              }
              if (!onboardingComplete) {
                return const OnboardingScreen();
              }
              return const MainShell();
            },
          );
        },
      ),
    );
  }
}

/// Keeps branded splash visible for at least 1.5s on cold start.
class _MinSplash extends StatefulWidget {
  const _MinSplash({required this.child});

  final Widget child;

  @override
  State<_MinSplash> createState() => _MinSplashState();
}

class _MinSplashState extends State<_MinSplash> {
  bool _minElapsed = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _minElapsed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_minElapsed) {
      return const AppLoading();
    }
    return widget.child;
  }
}

class _InitError extends StatelessWidget {
  const _InitError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Failed to initialize app services.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

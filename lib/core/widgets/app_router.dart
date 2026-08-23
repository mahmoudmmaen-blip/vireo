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

    return init.when(
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

        // Watch auth only after services (including Supabase) are ready.
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
    );
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
          children: [
            const Text('Failed to initialize app services.'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

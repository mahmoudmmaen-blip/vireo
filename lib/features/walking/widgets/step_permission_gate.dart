import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/walking/data/step_permission.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

final _stepPermissionGrantedProvider = FutureProvider<bool>((ref) async {
  ref.watch(stepCounterBootstrapProvider);
  return StepPermission.isGranted();
});

/// Friendly explanation shown **before** the system permission dialog.
class StepPermissionGate extends ConsumerWidget {
  const StepPermissionGate({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!StepPermission.isSupported) return child;

    final grantedAsync = ref.watch(_stepPermissionGrantedProvider);
    return grantedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _Explanation(
        onEnable: () => _enable(ref),
      ),
      data: (granted) {
        if (granted) return child;
        return _Explanation(onEnable: () => _enable(ref));
      },
    );
  }

  Future<void> _enable(WidgetRef ref) async {
    final enable = ref.read(enableStepCountingProvider);
    await enable();
    ref.invalidate(_stepPermissionGrantedProvider);
    ref.invalidate(stepCounterBootstrapProvider);
  }
}

class _Explanation extends StatefulWidget {
  const _Explanation({required this.onEnable});

  final Future<void> Function() onEnable;

  @override
  State<_Explanation> createState() => _ExplanationState();
}

class _ExplanationState extends State<_Explanation> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Padding(
      padding: const EdgeInsets.all(VSpace.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_walk_rounded, size: 72, color: colors.ember),
          const SizedBox(height: VSpace.md),
          Text(
            l10n.walkingEnableTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: VSpace.sm),
          Text(
            l10n.walkingEnableBody,
            style: TextStyle(color: colors.textMute, height: 1.45),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: VSpace.xl),
          FilledButton.icon(
            onPressed: _busy
                ? null
                : () async {
                    setState(() => _busy = true);
                    try {
                      await widget.onEnable();
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sensors),
            label: Text(l10n.walkingEnableCta),
          ),
        ],
      ),
    );
  }
}

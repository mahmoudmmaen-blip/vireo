import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/screens/trial_ended_screen.dart';

/// Redirects to the trial-ended flow when the trial lapses without conversion.
class SubscriptionShellGate extends ConsumerStatefulWidget {
  const SubscriptionShellGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SubscriptionShellGate> createState() =>
      _SubscriptionShellGateState();
}

class _SubscriptionShellGateState extends ConsumerState<SubscriptionShellGate> {
  var _checked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowTrialEnded());
  }

  Future<void> _maybeShowTrialEnded() async {
    if (_checked || !mounted) return;
    _checked = true;

    final snapshot = await ref.read(subscriptionProvider.future);
    if (!snapshot.shouldShowTrialEndedGate || !mounted) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => const TrialEndedScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

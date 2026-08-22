import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/features/progress/providers/progress_provider.dart';
import 'package:vireo/features/progress/reassessment_flow_screen.dart';

/// Checks on app open whether a monthly re-assessment is due (28+ days).
class ReassessmentGate extends ConsumerStatefulWidget {
  const ReassessmentGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReassessmentGate> createState() => _ReassessmentGateState();
}

class _ReassessmentGateState extends ConsumerState<ReassessmentGate> {
  var _checkedThisSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybePrompt());
  }

  Future<void> _maybePrompt() async {
    if (_checkedThisSession || !mounted) return;
    _checkedThisSession = true;

    final due = await ref.read(reassessmentDueProvider.future);
    if (!due || !mounted) return;

    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (_) => const ReassessmentFlowScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

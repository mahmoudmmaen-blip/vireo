import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:vireo/features/activity/screens/outdoor_live_screen.dart';

class OutdoorCountdownScreen extends StatefulWidget {
  const OutdoorCountdownScreen({super.key, required this.type});

  final OutdoorWorkoutType type;

  @override
  State<OutdoorCountdownScreen> createState() => _OutdoorCountdownScreenState();
}

class _OutdoorCountdownScreenState extends State<OutdoorCountdownScreen> {
  int _n = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_n <= 1) {
        t.cancel();
        HapticFeedback.heavyImpact();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => OutdoorLiveScreen(type: widget.type),
          ),
        );
      } else {
        setState(() => _n--);
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Text(
          _n > 0 ? '$_n' : l10n.outdoorGo,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colors.ember,
              ),
        ),
      ),
    );
  }
}

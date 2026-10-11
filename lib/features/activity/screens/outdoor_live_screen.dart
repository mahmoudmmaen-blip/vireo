import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/activity/domain/outdoor_workout_models.dart';
import 'package:vireo/features/activity/providers/outdoor_session_actions.dart';
import 'package:vireo/features/activity/services/outdoor_gps_tracker.dart';
import 'package:vireo/features/activity/services/outdoor_voice_cues.dart';
import 'package:vireo/features/activity/widgets/outdoor_map_view.dart';
import 'package:vireo/core/utils/fat_equivalent.dart';
import 'package:vireo/features/activity/screens/outdoor_detail_screen.dart';
import 'package:vireo/features/walking/data/body_metrics.dart';
import 'package:vireo/features/walking/providers/live_steps_provider.dart';

class OutdoorLiveScreen extends ConsumerStatefulWidget {
  const OutdoorLiveScreen({super.key, required this.type});

  final OutdoorWorkoutType type;

  @override
  ConsumerState<OutdoorLiveScreen> createState() => _OutdoorLiveScreenState();
}

class _OutdoorLiveScreenState extends ConsumerState<OutdoorLiveScreen> {
  OutdoorGpsTracker? _tracker;
  StreamSubscription<OutdoorLiveStats>? _sub;
  OutdoorLiveStats _stats = OutdoorLiveStats.initial;
  int _stepsAtStart = 0;
  int _lastVoiceKm = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _stepsAtStart = ref.read(todayStepsProvider);
      _boot();
    });
  }

  Future<void> _boot() async {
    final locale = Localizations.localeOf(context).languageCode;
    await OutdoorVoiceCues.configure(locale);
    final body = readBodyMetrics();
    _tracker = OutdoorGpsTracker(
      type: widget.type,
      weightKg: body.weightKg,
    );
    final ok = await _tracker!.ensureLocationPermission(forWorkout: true);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 3), persist: false, content: Text(AppLocalizations.of(context).outdoorLocationDenied)),
      );
      Navigator.of(context).pop();
      return;
    }
    await _tracker!.start();
    _sub = _tracker!.stream.listen((s) {
      if (!mounted) return;
      setState(() => _stats = s);
      final km = (s.distanceMeters / 1000).floor();
      if (km > _lastVoiceKm) {
        _lastVoiceKm = km;
        OutdoorVoiceCues.speakKm(
          km: km,
          elapsedSeconds: s.activeSeconds,
          type: widget.type,
          paceMinPerKm: s.paceMinPerKm,
          languageCode: locale,
        );
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _tracker?.dispose();
    super.dispose();
  }

  Future<void> _confirmStop() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.outdoorStopTitle),
        content: Text(l10n.outdoorStopBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.reassessmentLater)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.outdoorStopConfirm)),
        ],
      ),
    );
    if (ok == true) await _finish();
  }

  Future<void> _finish() async {
    final stepsEnd = ref.read(todayStepsProvider);
    final session = await _tracker?.stop(
      stepsAtStart: _stepsAtStart,
      stepsAtEnd: stepsEnd,
    );
    if (session != null) {
      await persistOutdoorSession(ref, session);
    }
    if (mounted) {
      Navigator.of(context).popUntil((r) => r.isFirst);
      if (session != null) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => OutdoorDetailScreen(sessionId: session.id),
          ),
        );
      }
    }
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _paceOrSpeed(AppLocalizations l10n) {
    if (_stats.currentType == OutdoorWorkoutType.cycle) {
      return l10n.outdoorSpeedKmh(_stats.speedKmh.toStringAsFixed(1));
    }
    final p = _stats.paceMinPerKm;
    if (p == null) return '—';
    final min = p.floor();
    final sec = ((p - min) * 60).round();
    return l10n.outdoorPaceMinKm(min, sec);
  }

  void _showManualOverrideDialog() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in OutdoorWorkoutType.values)
              ListTile(
                title: Text(_typeLabel(l10n, t)),
                leading: Icon(
                  t == OutdoorWorkoutType.walk
                      ? Icons.directions_walk
                      : t == OutdoorWorkoutType.run
                          ? Icons.directions_run
                          : Icons.directions_bike,
                ),
                trailing: _stats.currentType == t
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  Navigator.pop(ctx);
                  _tracker?.manualOverrideType(t);
                },
              ),
            if (_stats.isManuallyOverridden)
              ListTile(
                title: Text(l10n.themeModeSystem),
                leading: const Icon(Icons.auto_mode),
                onTap: () {
                  Navigator.pop(ctx);
                  _tracker?.resetManualOverride();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(_typeLabel(l10n, _stats.currentType)),
        actions: [
          IconButton(
            tooltip: l10n.manualOverride,
            icon: const Icon(Icons.tune),
            onPressed: _showManualOverrideDialog,
          ),
          IconButton(
            tooltip: l10n.outdoorAutoPause,
            onPressed: () {
              _tracker?.setAutoPause(!_stats.autoPauseEnabled);
            },
            icon: Icon(
              _stats.autoPauseEnabled ? Icons.pause_circle_outline : Icons.pause_circle_filled,
              color: _stats.autoPauseEnabled ? colors.ember : colors.textMute,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: OutdoorMapView(route: _stats.route, followLatest: true),
          ),
          Padding(
            padding: const EdgeInsets.all(VSpace.md),
            child: Column(
              children: [
                if (_stats.detectedType != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: VSpace.xs),
                    child: InkWell(
                      onTap: _showManualOverrideDialog,
                      borderRadius: BorderRadius.circular(VRadius.pill),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.ember.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(VRadius.pill),
                          border: Border.all(color: colors.ember.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome, size: 14, color: colors.ember),
                            const SizedBox(width: 6),
                            Text(
                              l10n.detectedActivity(_typeLabel(l10n, _stats.detectedType!)),
                              style: TextStyle(
                                color: colors.ember,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            if (_stats.isManuallyOverridden) ...[
                              const SizedBox(width: 4),
                              Text(' (${l10n.manualOverride})',
                                  style: TextStyle(color: colors.textMute, fontSize: 11)),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(l10n.outdoorDistance, '${(_stats.distanceMeters / 1000).toStringAsFixed(2)} km'),
                    _Stat(l10n.outdoorDuration, _formatDuration(_stats.activeSeconds)),
                    _Stat(
                      _stats.currentType == OutdoorWorkoutType.cycle
                          ? l10n.outdoorSpeed
                          : l10n.outdoorPace,
                      _paceOrSpeed(l10n),
                    ),
                  ],
                ),
                const SizedBox(height: VSpace.md),
                Text(
                  l10n.outdoorCalories(_stats.calories),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.ember,
                      ),
                ),
                if (FatEquivalent.hasEquivalent(_stats.calories)) ...[
                  const SizedBox(height: 4),
                  FatEquivalentBadge(
                    kcal: _stats.calories,
                    isBurned: true,
                  ),
                ],
                if (_stats.isPaused)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(l10n.outdoorPaused, style: TextStyle(color: colors.gold)),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(VSpace.md, 0, VSpace.md, VSpace.lg),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      _tracker?.togglePause();
                    },
                    child: Text(_stats.isPaused ? l10n.outdoorResume : l10n.outdoorPause),
                  ),
                ),
                const SizedBox(width: VSpace.sm),
                Expanded(
                  child: GestureDetector(
                    onLongPress: () {
                      HapticFeedback.heavyImpact();
                      _confirmStop();
                    },
                    child: FilledButton(
                      onPressed: null,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.danger,
                        disabledBackgroundColor: colors.danger,
                        disabledForegroundColor: Colors.white,
                      ),
                      child: Text(l10n.outdoorHoldToStop),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, OutdoorWorkoutType t) => switch (t) {
        OutdoorWorkoutType.walk => l10n.outdoorTypeWalk,
        OutdoorWorkoutType.run => l10n.outdoorTypeRun,
        OutdoorWorkoutType.cycle => l10n.outdoorTypeCycle,
      };
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: context.vireoColors.textMute, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      ],
    );
  }
}

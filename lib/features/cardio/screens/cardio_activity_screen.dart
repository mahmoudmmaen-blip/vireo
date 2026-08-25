import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/core/utils/cardio_calorie_calculator.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/cardio/providers/cardio_log_provider.dart';

class CardioActivityScreen extends ConsumerStatefulWidget {
  const CardioActivityScreen({super.key});

  @override
  ConsumerState<CardioActivityScreen> createState() =>
      _CardioActivityScreenState();
}

class _CardioActivityScreenState extends ConsumerState<CardioActivityScreen> {
  CardioActivityType _activity = CardioActivityType.briskWalking;
  int _minutes = 30;
  bool _saving = false;

  double get _weightKg {
    final profile = HiveService.isInitialized
        ? HiveService.cacheBox.get('guest_profile')
        : null;
    if (profile is Map) {
      return (profile['weight_kg'] as num?)?.toDouble() ?? 75.0;
    }
    return 75.0;
  }

  int get _previewBurn => CardioCalorieCalculator.burn(
        activity: _activity,
        durationMinutes: _minutes,
        weightKg: _weightKg,
      );

  Future<void> _log() async {
    setState(() => _saving = true);
    try {
      await ref.read(cardioLogProvider.notifier).logActivity(
            activity: _activity,
            durationMinutes: _minutes,
            weightKg: _weightKg,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).cardioLoggedSnack)),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).authErrorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final logs = ref.watch(cardioLogProvider);
    final todayBurn = ref.watch(todayCardioCaloriesProvider);

    return FeatureScaffold(
      title: l10n.cardioTitle,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.cardioSubtitle, style: TextStyle(color: colors.textMute)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: VireoDecorations.premiumCard(colors),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.cardioSelectActivity, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CardioActivityType.values.map((type) {
                    final selected = _activity == type;
                    return ChoiceChip(
                      label: Text(_activityLabel(l10n, type)),
                      selected: selected,
                      onSelected: (_) => setState(() => _activity = type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.cardioDuration(_minutes),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Slider(
                  value: _minutes.toDouble(),
                  min: 5,
                  max: 120,
                  divisions: 23,
                  label: '$_minutes min',
                  onChanged: (v) => setState(() => _minutes = v.round()),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: colors.ember),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.cardioEstimatedBurn(_previewBurn),
                        style: TextStyle(
                          color: colors.ember,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.cardioMetHint(_activity.met.toStringAsFixed(1)),
                  style: TextStyle(color: colors.textMute, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saving ? null : _log,
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.cardioLogButton),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.cardioTodayTotal(todayBurn),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (logs.isEmpty)
            Text(l10n.cardioEmpty, style: TextStyle(color: colors.textMute))
          else
            ...logs.take(12).map((entry) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.directions_run, color: colors.ember),
                  title: Text(_activityLabel(l10n, entry.activity)),
                  subtitle: Text(
                    l10n.cardioLogSubtitle(
                      entry.durationMinutes,
                      entry.caloriesBurned,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: colors.textMute),
                    onPressed: () =>
                        ref.read(cardioLogProvider.notifier).remove(entry.id),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  String _activityLabel(AppLocalizations l10n, CardioActivityType type) {
    return switch (type) {
      CardioActivityType.briskWalking => l10n.cardioBriskWalking,
      CardioActivityType.running => l10n.cardioRunning,
      CardioActivityType.cycling => l10n.cardioCycling,
      CardioActivityType.swimming => l10n.cardioSwimming,
      CardioActivityType.jumpRope => l10n.cardioJumpRope,
      CardioActivityType.hiit => l10n.cardioHiit,
      CardioActivityType.elliptical => l10n.cardioElliptical,
    };
  }
}

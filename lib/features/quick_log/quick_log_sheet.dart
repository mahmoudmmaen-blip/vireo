import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/motion.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/ai_coach/screens/ai_coach_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/ai_scan_screen.dart';
import 'package:vireo/features/activity/screens/outdoor_pick_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_barcode_screen.dart';
import 'package:vireo/features/ai_nutrition/screens/meal_log_text_screen.dart';
import 'package:vireo/features/cardio/screens/cardio_activity_screen.dart';
import 'package:vireo/features/measurements/screens/inbody_scan_screen.dart';
import 'package:vireo/features/progress/widgets/weight_log_sheet.dart';
import 'package:vireo/core/services/shell_navigation_provider.dart';
import 'package:vireo/features/water/providers/water_tracker_provider.dart';

import 'package:vireo/features/home/widgets/sleep_log_sheet.dart';
import 'package:vireo/features/workout/screens/workout_flow_screen.dart';

/// One-tap logging hub opened from the centre "+" of the bottom bar.
///
/// [hostContext] / [ref] belong to the long-lived shell so actions can run
/// after the sheet itself is dismissed.
Future<void> showQuickLogSheet(BuildContext hostContext, WidgetRef ref) {
  HapticFeedback.mediumImpact();
  return showModalBottomSheet<void>(
    context: hostContext,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (sheetContext) => _QuickLogSheet(
      onAction: (action) {
        Navigator.of(sheetContext).pop();
        _run(action, hostContext, ref);
      },
    ),
  );
}

enum QuickLogAction {
  scanCamera,
  scanGallery,
  mealVoice,
  mealText,
  mealBarcode,
  inbody,
  water,
  weight,
  workout,
  sleep,
  cardio,
  outdoor,
  coach,
  profile,
}

Future<void> _run(
  QuickLogAction action,
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context);
  switch (action) {
    case QuickLogAction.scanCamera:
      await AiScanScreen.open(context, ref, fromCamera: true);
    case QuickLogAction.scanGallery:
      await AiScanScreen.open(context, ref, fromCamera: false);
    case QuickLogAction.mealVoice:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const MealLogTextScreen(startListeningOnInit: true),
        ),
      );
    case QuickLogAction.water:
      await _logWater(context, ref, l10n);
    case QuickLogAction.weight:
      await showWeightLogSheet(context, ref);
    case QuickLogAction.workout:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const WorkoutFlowScreen()),
      );
    case QuickLogAction.sleep:
      await showSleepLogSheet(context, ref);
    case QuickLogAction.cardio:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CardioActivityScreen()),
      );
    case QuickLogAction.mealText:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const MealLogTextScreen()),
      );
    case QuickLogAction.mealBarcode:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const MealBarcodeScreen()),
      );
    case QuickLogAction.inbody:
      await InBodyScanScreen.open(context);
    case QuickLogAction.outdoor:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const OutdoorPickScreen()),
      );
    case QuickLogAction.coach:
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const AiCoachScreen()),
      );
    case QuickLogAction.profile:
      ref.read(shellTabIndexProvider.notifier).goProfile();
  }
}

Future<void> _logWater(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) async {
  final added = await ref.read(waterTrackerProvider.notifier).addGlass();
  if (!context.mounted) return;
  final ml = ref.read(waterTrackerProvider);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        persist: false,
        content: Text(
          added
              ? l10n.uxWaterAdded((ml / 1000).toStringAsFixed(2))
              : l10n.uxWaterGoalDone,
        ),
      ),
    );
}

class _QuickLogSheet extends StatelessWidget {
  const _QuickLogSheet({required this.onAction});

  final ValueChanged<QuickLogAction> onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    final tiles = <_TileData>[
      _TileData(QuickLogAction.water, Icons.water_drop_rounded, l10n.uxQuickWater,
          l10n.uxQuickWaterSub, VMacro.water),
      _TileData(QuickLogAction.weight, Icons.monitor_weight_outlined,
          l10n.uxQuickWeight, l10n.uxQuickWeightSub, colors.gold),
      _TileData(QuickLogAction.workout, Icons.fitness_center_rounded,
          l10n.workoutTitle, l10n.homeTodayWorkoutTitle, colors.ember),
      _TileData(QuickLogAction.sleep, Icons.bedtime_outlined,
          l10n.vitalitySleepLog, l10n.vitalitySleepHint, VMacro.ai),
      _TileData(QuickLogAction.mealVoice, Icons.mic_rounded,
          l10n.mealVoiceStart, l10n.uxQuickMealTextSub, colors.success),
      _TileData(QuickLogAction.mealText, Icons.keyboard_alt_outlined,
          l10n.uxQuickMealText, l10n.uxQuickMealTextSub, colors.ember),
      _TileData(QuickLogAction.mealBarcode, Icons.qr_code_scanner,
          l10n.uxQuickBarcode, l10n.uxQuickBarcodeSub, colors.ember),
      _TileData(QuickLogAction.inbody, Icons.accessibility_new,
          l10n.uxQuickInbody, l10n.uxQuickInbodySub, colors.gold),
      _TileData(QuickLogAction.cardio, Icons.directions_run_rounded,
          l10n.uxQuickCardio, l10n.uxQuickCardioSub, VMacro.steps),
      _TileData(QuickLogAction.outdoor, Icons.map_outlined, l10n.uxQuickOutdoor,
          l10n.uxQuickOutdoorSub, VMacro.steps),
      _TileData(QuickLogAction.coach, Icons.auto_awesome_rounded,
          l10n.uxQuickCoach, l10n.uxQuickCoachSub, VMacro.ai),
      _TileData(QuickLogAction.profile, Icons.person_outline_rounded,
          l10n.profileTitle, l10n.settingsTitle, colors.textMute),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(VSpace.gutter, 0, VSpace.gutter, VSpace.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.uxQuickLogTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.uxQuickLogSubtitle,
            style: TextStyle(color: colors.textMute),
          ),
          const SizedBox(height: VSpace.md),
          FadeSlideIn(
            child: _ScanHero(
              onCamera: () => onAction(QuickLogAction.scanCamera),
              onGallery: () => onAction(QuickLogAction.scanGallery),
              onVoice: () => onAction(QuickLogAction.mealVoice),
            ),
          ),
          const SizedBox(height: VSpace.sm),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: VSpace.sm,
            crossAxisSpacing: VSpace.sm,
            childAspectRatio: 1.75,
            children: [
              for (var i = 0; i < tiles.length; i++)
                FadeSlideIn(
                  index: i + 1,
                  child: _ActionTile(
                    data: tiles[i],
                    onTap: () => onAction(tiles[i].action),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TileData {
  const _TileData(this.action, this.icon, this.title, this.subtitle, this.color);

  final QuickLogAction action;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
}

class _ScanHero extends StatelessWidget {
  const _ScanHero({
    required this.onCamera,
    required this.onGallery,
    required this.onVoice,
  });

  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onVoice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Pressable(
      onTap: onCamera,
      semanticLabel: l10n.uxQuickScanTitle,
      child: Container(
        padding: const EdgeInsets.all(VSpace.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VRadius.lg),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [colors.ember, Color.lerp(colors.ember, VMacro.ai, 0.55)!],
          ),
          boxShadow: [
            BoxShadow(
              color: colors.ember.withValues(alpha: 0.35),
              blurRadius: 24,
              spreadRadius: -6,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(VRadius.md),
              ),
              child: const Icon(Icons.photo_camera_rounded,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(width: VSpace.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.uxQuickScanTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.uxQuickScanSub,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: VSpace.xs),
            Material(
              color: Colors.white.withValues(alpha: 0.18),
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: l10n.mealVoiceStart,
                onPressed: onVoice,
                icon: const Icon(Icons.mic_rounded, color: Colors.white),
              ),
            ),
            const SizedBox(width: 4),
            Material(
              color: Colors.white.withValues(alpha: 0.18),
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: l10n.aiScanGallery,
                onPressed: onGallery,
                icon: const Icon(Icons.photo_library_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.data, required this.onTap});

  final _TileData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return VireoCard(
      onTap: onTap,
      semanticLabel: data.title,
      radius: VRadius.md,
      color: colors.surfaceRaised,
      padding: const EdgeInsets.all(VSpace.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(VRadius.sm),
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(width: VSpace.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: colors.textMute, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

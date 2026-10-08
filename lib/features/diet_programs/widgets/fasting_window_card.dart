import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/ring_progress.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/diet_programs/providers/diet_programs_provider.dart';
import 'package:vireo/features/diet_programs/screens/diet_program_detail_screen.dart';

class FastingWindowCard extends ConsumerWidget {
  const FastingWindowCard({super.key});

  static String _fmt(int totalMinutes) {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(fastingWindowStatusProvider);
    final program = ref.watch(activeDietProgramProvider);
    if (status == null || program == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final title = status.isEating
        ? l10n.dietEatingWindowLeft(_fmt(status.minutesRemaining))
        : l10n.dietFastingLeft(_fmt(status.minutesRemaining));

    return VireoCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DietProgramDetailScreen(programId: program.id),
        ),
      ),
      glow: colors.ember,
      child: Row(
        children: [
          RingProgress(
            progress: status.progress,
            color: status.isEating ? colors.success : colors.ember,
            size: 64,
            stroke: 7,
            child: Icon(
              status.isEating ? Icons.restaurant : Icons.nightlight_round,
              size: 22,
              color: colors.text,
            ),
          ),
          const SizedBox(width: VSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.dietWindowStartsAt(status.startHour),
                  style: TextStyle(color: colors.textMute, fontSize: 12.5),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.dietEditWindow,
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: () => _editHour(context, ref, status.startHour),
          ),
        ],
      ),
    );
  }

  Future<void> _editHour(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current, minute: 0),
    );
    if (picked == null) return;
    await ref.read(dietPlanActionsProvider).setEatingWindowStartHour(picked.hour);
  }
}

class ChooseDietPlanCard extends StatelessWidget {
  const ChooseDietPlanCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    return VireoCard(
      onTap: onTap,
      glow: colors.gold,
      child: Row(
        children: [
          Icon(Icons.restaurant_menu_rounded, color: colors.ember),
          const SizedBox(width: VSpace.sm),
          Expanded(
            child: Text(
              l10n.dietChoosePlanCard,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Icon(Icons.chevron_right, color: colors.textMute),
        ],
      ),
    );
  }
}

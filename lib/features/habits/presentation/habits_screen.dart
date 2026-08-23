import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/habits/application/habit_controller.dart';
import 'package:vireo/features/habits/presentation/widgets/habit_tile.dart';
import 'package:vireo/features/habits/presentation/widgets/habits_error_view.dart';
import 'package:vireo/features/habits/presentation/widgets/habits_loading_view.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final habitsAsync = ref.watch(habitControllerProvider);

    return FeatureScaffold(
      title: l10n.habitsTitle,
      body: Stack(
        children: [
          habitsAsync.when(
            loading: () => const HabitsLoadingView(),
            error: (_, __) => HabitsErrorView(
              onRetry: () => ref.invalidate(habitControllerProvider),
            ),
            data: (habits) {
              if (habits.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      l10n.habitsEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.textMute),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return HabitTile(
                    habit: habit,
                    onToggle: () => ref
                        .read(habitControllerProvider.notifier)
                        .toggleHabit(habit.id),
                  );
                },
              );
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () => _showAddHabitDialog(context, ref),
              backgroundColor: colors.ember,
              foregroundColor: colors.text,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddHabitDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.habitsAddTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.habitsAddHint),
          onSubmitted: (_) => Navigator.of(ctx).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.deleteAccountCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.habitsAddConfirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref
          .read(habitControllerProvider.notifier)
          .addHabit(controller.text);
    }

    controller.dispose();
  }
}

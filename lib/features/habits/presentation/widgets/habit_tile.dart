import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';
import 'package:vireo/features/habits/domain/entities/habit.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.onToggle,
  });

  final Habit habit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(VireoDecorations.cardRadius),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Checkbox(
                value: habit.isCompletedToday,
                onChanged: (_) => onToggle(),
                activeColor: colors.ember,
                checkColor: colors.text,
                side: BorderSide(color: colors.line),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: habit.isCompletedToday
                                ? TextDecoration.lineThrough
                                : null,
                            color: habit.isCompletedToday
                                ? colors.textMute
                                : colors.text,
                          ),
                    ),
                    if (habit.streak > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        l10n.habitsStreak(habit.streak),
                        style: TextStyle(
                          color: colors.ember,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.local_fire_department_outlined,
                color: habit.streak > 0 ? colors.ember : colors.textMute,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

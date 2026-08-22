import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/progress_models.dart';

class AdherenceBarChart extends StatelessWidget {
  const AdherenceBarChart({super.key, required this.weeks});

  final List<AdherenceWeek> weeks;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    if (weeks.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(child: Text('—', style: TextStyle(color: colors.textMute))),
      );
    }

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: weeks.map((week) {
          final fraction = (week.completionPct / 100).clamp(0.0, 1.0);
          final hitTarget = week.completionPct >= 70;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${week.completionPct}%',
                    style: TextStyle(fontSize: 9, color: colors.textMute),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: fraction < 0.05 ? 0.05 : fraction,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: hitTarget ? colors.success : colors.ember,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('MMM d').format(week.weekStart),
                    style: TextStyle(fontSize: 9, color: colors.textMute),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

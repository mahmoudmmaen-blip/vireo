import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/daily_step_count.dart';

class WeeklyStepsChart extends StatelessWidget {
  const WeeklyStepsChart({
    super.key,
    required this.days,
    required this.title,
    required this.goal,
  });

  final List<DailyStepCount> days;
  final String title;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final maxSteps = days.fold<int>(
      goal,
      (max, day) => day.steps > max ? day.steps : max,
    );
    final chartMax = maxSteps <= 0 ? goal : maxSteps;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: days.map((day) {
                  final fraction =
                      chartMax <= 0 ? 0.0 : (day.steps / chartMax).clamp(0.0, 1.0);
                  final hitGoal = day.steps >= goal;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (day.steps > 0)
                            Text(
                              _compactSteps(day.steps),
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.textMute,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: fraction < 0.04 && day.steps > 0
                                    ? 0.04
                                    : fraction,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: hitGoal ? colors.success : colors.ember,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _dayLabel(day.date),
                            style: TextStyle(
                              fontSize: 11,
                              color: _isToday(day.date)
                                  ? colors.ember
                                  : colors.textMute,
                              fontWeight: _isToday(day.date)
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dayLabel(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _compactSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k'.replaceAll('.0k', 'k');
    }
    return '$steps';
  }
}

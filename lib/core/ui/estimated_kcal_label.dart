import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

/// Formats an integer with locale-aware thousands separators (Western digits).
String formatCount(int value, {String? locale}) {
  return NumberFormat.decimalPattern(locale ?? 'en').format(value);
}

/// Primary calorie number + honest "estimated / تقديري" chip.
class EstimatedKcalLabel extends StatelessWidget {
  const EstimatedKcalLabel({
    super.key,
    required this.kcal,
    this.style,
    this.showUnit = true,
    this.compact = false,
  });

  final int kcal;
  final TextStyle? style;
  final bool showUnit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final number = formatCount(kcal);
    final unit = showUnit ? (isAr ? ' سعرة' : ' kcal') : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$number$unit', style: style ?? VType.number(size: 28, color: colors.text)),
        SizedBox(height: compact ? 2 : 4),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 8,
            vertical: compact ? 2 : 3,
          ),
          decoration: BoxDecoration(
            color: colors.gold.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(VRadius.sm),
            border: Border.all(color: colors.gold.withValues(alpha: 0.35)),
          ),
          child: Text(
            l10n.mealReviewEstimated,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w700,
              color: colors.gold,
            ),
          ),
        ),
      ],
    );
  }
}

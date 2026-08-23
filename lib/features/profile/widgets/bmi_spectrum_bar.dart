import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/utils/bmi_calculator.dart';

/// Color-coded BMI spectrum with a marker for the user's value.
class BmiSpectrumBar extends StatelessWidget {
  const BmiSpectrumBar({
    super.key,
    required this.bmi,
    required this.category,
  });

  final double bmi;
  final BmiCategory category;

  static const _min = 15.0;
  static const _max = 40.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final clamped = bmi.clamp(_min, _max);
    final fraction = (clamped - _min) / (_max - _min);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.profileBmiExplainShort,
                style: TextStyle(color: colors.textMute, fontSize: 13),
              ),
            ),
            IconButton(
              tooltip: l10n.profileBmiTooltip,
              icon: Icon(Icons.info_outline, color: colors.ember),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profileCurrentBmi,
                        style: Theme.of(ctx).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(l10n.profileBmiExplainFull),
                      const SizedBox(height: 12),
                      Text(
                        l10n.profileBmiTooltip,
                        style: TextStyle(color: colors.textMute),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final markerX = fraction * width;
            return SizedBox(
              height: 48,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 35, // 15–18.5
                            child: Container(height: 12, color: colors.recovery),
                          ),
                          Expanded(
                            flex: 65, // 18.5–25
                            child: Container(height: 12, color: colors.success),
                          ),
                          Expanded(
                            flex: 50, // 25–30
                            child: Container(height: 12, color: colors.gold),
                          ),
                          Expanded(
                            flex: 100, // 30–40
                            child: Container(height: 12, color: colors.danger),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: (markerX - 8).clamp(0.0, width - 16),
                    top: 4,
                    child: Column(
                      children: [
                        Icon(Icons.arrow_drop_down, color: colors.ember, size: 20),
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colors.ember,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Label(l10n.profileBmiUnderweight, colors.recovery),
            _Label(l10n.profileBmiHealthy, colors.success),
            _Label(l10n.profileBmiOverweight, colors.gold),
            _Label(l10n.profileBmiObese, colors.danger),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${bmi.toStringAsFixed(1)} — ${_categoryLabel(l10n)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: switch (category) {
              BmiCategory.underweight => colors.recovery,
              BmiCategory.healthy => colors.success,
              BmiCategory.overweight => colors.gold,
              BmiCategory.obese => colors.danger,
            },
          ),
        ),
      ],
    );
  }

  String _categoryLabel(AppLocalizations l10n) => switch (category) {
        BmiCategory.underweight => l10n.profileBmiUnderweight,
        BmiCategory.healthy => l10n.profileBmiHealthy,
        BmiCategory.overweight => l10n.profileBmiOverweight,
        BmiCategory.obese => l10n.profileBmiObese,
      };
}

class _Label extends StatelessWidget {
  const _Label(this.text, this.color);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 9, color: color));
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/async_state_view.dart';
import 'package:vireo/core/ui/estimated_kcal_label.dart';
import 'package:vireo/core/ui/vireo_icon_button.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

/// Debug-only gallery of design tokens, type scale, buttons, cards, chips, states.
class DesignSystemPage extends StatelessWidget {
  const DesignSystemPage({super.key});

  static Future<void> open(BuildContext context) {
    assert(kDebugMode, 'DesignSystemPage is debug-only');
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const DesignSystemPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(kDebugMode);
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(l10n.designSystemTitle),
        backgroundColor: colors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(VSpace.md),
        children: [
          _Section(
            title: 'Colors',
            child: Wrap(
              spacing: VSpace.xs,
              runSpacing: VSpace.xs,
              children: [
                _Swatch('background', colors.background),
                _Swatch('surface', colors.surface),
                _Swatch('surfaceRaised', colors.surfaceRaised),
                _Swatch('ember', colors.ember),
                _Swatch('gold', colors.gold),
                _Swatch('success', colors.success),
                _Swatch('danger', colors.danger),
                _Swatch('recovery', colors.recovery),
                _Swatch('text', colors.text),
                _Swatch('textMute', colors.textMute),
                _Swatch('line', colors.line),
              ],
            ),
          ),
          _Section(
            title: 'Type scale (6)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Display', style: textTheme.displaySmall),
                Text('Headline', style: textTheme.headlineSmall),
                Text('Title', style: textTheme.titleLarge),
                Text('Body', style: textTheme.bodyLarge),
                Text('Label', style: textTheme.labelLarge),
                Text('Mute', style: textTheme.bodySmall),
                const SizedBox(height: VSpace.xs),
                Text('1234', style: VType.number(size: 32, color: colors.ember)),
              ],
            ),
          ),
          _Section(
            title: 'Buttons',
            child: Wrap(
              spacing: VSpace.sm,
              runSpacing: VSpace.sm,
              children: [
                FilledButton(onPressed: () {}, child: const Text('Filled')),
                OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                TextButton(onPressed: () {}, child: const Text('Text')),
                VireoIconButton(
                  icon: Icons.close_rounded,
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          _Section(
            title: 'Cards & chips',
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(VSpace.md),
                  decoration: BoxDecoration(
                    color: colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(VRadius.md),
                    border: Border.all(color: colors.line),
                  ),
                  child: Text('Card · VRadius.md (18)', style: textTheme.titleSmall),
                ),
                const SizedBox(height: VSpace.sm),
                Wrap(
                  spacing: VSpace.xs,
                  children: [
                    Chip(label: Text(l10n.mealReviewEstimated), backgroundColor: colors.surface),
                    Chip(
                      label: const Text('Ember'),
                      backgroundColor: colors.ember.withValues(alpha: 0.2),
                      labelStyle: TextStyle(color: colors.ember),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _Section(
            title: 'Estimated kcal',
            child: EstimatedKcalLabel(kcal: 1850, style: VType.number(size: 36, color: colors.text)),
          ),
          _Section(
            title: 'States',
            child: Column(
              children: [
                SizedBox(height: 120, child: AsyncStateView.loading(skeletonRows: 2)),
                SizedBox(
                  height: 160,
                  child: AsyncStateView.empty(
                    title: l10n.uxStateEmptyTitle,
                    message: l10n.uxStateEmptyMessage,
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: AsyncStateView.error(onRetry: () {}),
                ),
                SizedBox(
                  height: 180,
                  child: AsyncStateView.offline(onRetry: () {}),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Spacing (4/8 grid)',
            child: Wrap(
              spacing: VSpace.xs,
              children: const [
                _SpaceBox(VSpace.xxs),
                _SpaceBox(VSpace.xs),
                _SpaceBox(VSpace.sm),
                _SpaceBox(VSpace.md),
                _SpaceBox(VSpace.lg),
                _SpaceBox(VSpace.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: VSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.ember,
                ),
          ),
          const SizedBox(height: VSpace.sm),
          child,
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(VRadius.sm),
            border: Border.all(color: colors.line),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: TextStyle(fontSize: 10, color: colors.textMute)),
      ],
    );
  }
}

class _SpaceBox extends StatelessWidget {
  const _SpaceBox(this.size);

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          color: colors.ember.withValues(alpha: 0.5),
        ),
        Text('${size.toInt()}', style: TextStyle(fontSize: 10, color: colors.textMute)),
      ],
    );
  }
}

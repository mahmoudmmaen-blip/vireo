import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

/// Shared empty / loading (skeleton) / error / offline body for lists & screens.
enum AsyncViewKind { loading, empty, error, offline }

class AsyncStateView extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.kind,
    this.title,
    this.message,
    this.onRetry,
    this.icon,
    this.skeletonRows = 4,
  });

  final AsyncViewKind kind;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final int skeletonRows;

  factory AsyncStateView.loading({Key? key, int skeletonRows = 4}) =>
      AsyncStateView(key: key, kind: AsyncViewKind.loading, skeletonRows: skeletonRows);

  factory AsyncStateView.empty({
    Key? key,
    required String title,
    String? message,
    IconData icon = Icons.inbox_outlined,
  }) =>
      AsyncStateView(
        key: key,
        kind: AsyncViewKind.empty,
        title: title,
        message: message,
        icon: icon,
      );

  factory AsyncStateView.error({
    Key? key,
    String? title,
    String? message,
    VoidCallback? onRetry,
  }) =>
      AsyncStateView(
        key: key,
        kind: AsyncViewKind.error,
        title: title,
        message: message,
        onRetry: onRetry,
        icon: Icons.error_outline_rounded,
      );

  factory AsyncStateView.offline({
    Key? key,
    String? title,
    String? message,
    VoidCallback? onRetry,
  }) =>
      AsyncStateView(
        key: key,
        kind: AsyncViewKind.offline,
        title: title,
        message: message,
        onRetry: onRetry,
        icon: Icons.wifi_off_rounded,
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);

    if (kind == AsyncViewKind.loading) {
      return _SkeletonList(rows: skeletonRows, colors: colors);
    }

    final resolvedTitle = title ??
        switch (kind) {
          AsyncViewKind.empty => l10n.uxStateEmptyTitle,
          AsyncViewKind.error => l10n.uxStateErrorTitle,
          AsyncViewKind.offline => l10n.uxStateOfflineTitle,
          AsyncViewKind.loading => '',
        };
    final resolvedMessage = message ??
        switch (kind) {
          AsyncViewKind.empty => l10n.uxStateEmptyMessage,
          AsyncViewKind.error => l10n.uxStateErrorMessage,
          AsyncViewKind.offline => l10n.uxStateOfflineMessage,
          AsyncViewKind.loading => '',
        };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.info_outline,
              size: 48,
              color: colors.textMute,
            ),
            const SizedBox(height: VSpace.md),
            Text(
              resolvedTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.text,
                  ),
            ),
            const SizedBox(height: VSpace.xs),
            Text(
              resolvedMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMute, fontSize: 14, height: 1.4),
            ),
            if (onRetry != null &&
                (kind == AsyncViewKind.error || kind == AsyncViewKind.offline)) ...[
              const SizedBox(height: VSpace.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(l10n.uxStateRetry),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  backgroundColor: colors.ember,
                  foregroundColor: colors.background,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList({required this.rows, required this.colors});

  final int rows;
  final VireoColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(VSpace.md),
      child: Column(
        children: List.generate(rows, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: VSpace.sm),
            child: _SkeletonCard(colors: colors, tall: i == 0),
          );
        }),
      ),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard({required this.colors, this.tall = false});

  final VireoColors colors;
  final bool tall;

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = reduce ? 0.35 : _c.value;
        final base = widget.colors.surfaceRaised;
        final highlight = Color.lerp(base, widget.colors.line, 0.35 + t * 0.35)!;
        return Container(
          height: widget.tall ? 96 : 64,
          decoration: BoxDecoration(
            color: highlight,
            borderRadius: BorderRadius.circular(VRadius.md),
            border: Border.all(color: widget.colors.line.withValues(alpha: 0.5)),
          ),
        );
      },
    );
  }
}

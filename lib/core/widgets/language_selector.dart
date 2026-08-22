import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/theme/vireo_decorations.dart';

/// Segmented Arabic / English picker — Arabic selected by default.
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isAr = locale.languageCode == 'ar';

    final arChip = _LangChip(
      label: l10n.languageArabic,
      selected: isAr,
      onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('ar')),
    );
    final enChip = _LangChip(
      label: l10n.languageEnglish,
      selected: !isAr,
      onTap: () => ref.read(localeProvider.notifier).setLocale(const Locale('en')),
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(VireoDecorations.chipRadius),
        border: Border.all(color: colors.line),
      ),
      child: compact
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [arChip, const SizedBox(width: 4), enChip],
            )
          : Row(
              children: [
                Expanded(child: arChip),
                const SizedBox(width: 4),
                Expanded(child: enChip),
              ],
            ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Material(
      color: selected ? colors.ember : Colors.transparent,
      borderRadius: BorderRadius.circular(VireoDecorations.chipRadius - 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(VireoDecorations.chipRadius - 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? colors.text : colors.textMute,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

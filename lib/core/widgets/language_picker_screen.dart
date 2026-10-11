import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/locale_provider.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/core/widgets/vireo_logo.dart';

/// Full-screen clean language picker for first launch and Settings.
class LanguagePickerScreen extends ConsumerWidget {
  const LanguagePickerScreen({
    super.key,
    this.isInitial = false,
  });

  final bool isInitial;

  static Route<void> route({bool isInitial = false}) {
    return MaterialPageRoute(
      builder: (_) => LanguagePickerScreen(isInitial: isInitial),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLocale = ref.watch(localeProvider);
    final activeLang = AppLanguage.fromLocale(activeLocale);
    final colors = context.vireoColors;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: isInitial
          ? null
          : AppBar(
              backgroundColor: colors.background,
              title: Text(_appBarTitle(activeLang)),
              centerTitle: true,
            ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: VSpace.lg,
                  vertical: VSpace.md,
                ),
                children: [
                  if (isInitial) ...[
                    const SizedBox(height: VSpace.lg),
                    const Center(child: VireoLogo(size: 64)),
                    const SizedBox(height: VSpace.lg),
                    Text(
                      _pickerTitle(activeLang),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: VSpace.xs),
                    Text(
                      _pickerSubtitle(activeLang),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.textMute,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: VSpace.xl),
                  ],
                  ...AppLanguage.values.map((lang) {
                    final selected = lang == activeLang;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _LanguageTile(
                        lang: lang,
                        selected: selected,
                        onTap: () {
                          ref.read(localeProvider.notifier).setLanguage(lang);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (isInitial)
              Container(
                padding: const EdgeInsets.all(VSpace.lg),
                decoration: BoxDecoration(
                  color: colors.background,
                  border: Border(
                    top: BorderSide(color: colors.line.withValues(alpha: 0.5)),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      ref
                          .read(hasSelectedInitialLanguageProvider.notifier)
                          .confirmInitialSelection();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.ember,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.continueButton,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _appBarTitle(AppLanguage lang) {
    return switch (lang) {
      AppLanguage.ar ||
      AppLanguage.arEG ||
      AppLanguage.arSA =>
        'اللغة',
      AppLanguage.fr => 'Langue',
      AppLanguage.es => 'Idioma',
      AppLanguage.tr => 'Dil',
      AppLanguage.ur => 'زبان',
      AppLanguage.hi => 'भाषा',
      AppLanguage.id => 'Bahasa',
      AppLanguage.en => 'Language',
    };
  }

  String _pickerTitle(AppLanguage lang) {
    return switch (lang) {
      AppLanguage.ar ||
      AppLanguage.arEG ||
      AppLanguage.arSA =>
        'اختر لغة التطبيق',
      AppLanguage.fr => 'Choisissez votre langue',
      AppLanguage.es => 'Elige tu idioma',
      AppLanguage.tr => 'Dilinizi seçin',
      AppLanguage.ur => 'اپنی زبان منتخب کریں',
      AppLanguage.hi => 'अपनी भाषा चुनें',
      AppLanguage.id => 'Pilih bahasa Anda',
      AppLanguage.en => 'Choose your language',
    };
  }

  String _pickerSubtitle(AppLanguage lang) {
    return switch (lang) {
      AppLanguage.ar ||
      AppLanguage.arEG ||
      AppLanguage.arSA =>
        'يمكنك تغيير اللغة في أي وقت من الإعدادات',
      AppLanguage.fr =>
        'Vous pouvez modifier la langue à tout moment dans les Paramètres.',
      AppLanguage.es =>
        'Puedes cambiar el idioma en cualquier momento en Ajustes.',
      AppLanguage.tr =>
        'Bu ayarı daha sonra Ayarlar bölümünden değiştirebilirsiniz.',
      AppLanguage.ur => 'آپ ترتیبات میں کسی بھی وقت زبان تبدیل کر سکتے ہیں۔',
      AppLanguage.hi => 'आप सेटिंग्स में कभी भी भाषा बदल सकते हैं।',
      AppLanguage.id =>
        'Anda dapat mengubah bahasa kapan saja di Pengaturan.',
      AppLanguage.en =>
        'You can change your language anytime from Settings.',
    };
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.lang,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage lang;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? colors.ember.withValues(alpha: 0.12)
              : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? colors.ember : colors.line,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag-free glyph emblem
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? colors.ember
                    : colors.line.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                lang.symbol,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: selected ? Colors.white : colors.text,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.nativeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lang.englishName,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMute,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colors.ember : colors.textMute.withValues(alpha: 0.4),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

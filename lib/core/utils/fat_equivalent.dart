import 'package:flutter/material.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';

/// Single source of truth for body fat equivalent calculations and formatting.
///
/// Rule:
/// - 1 g body fat ≈ 7.7 kcal (7700 kcal ≈ 1 kg).
/// - gramsFat = kcal / 7.7, rounded to whole grams (≥ 1000 g → show kg with 1 decimal).
/// - Always label it as an estimate ("≈", "تقريبًا") with a one-tap info sheet.
/// - Never show negative values; 0 kcal → hide.
abstract final class FatEquivalent {
  /// 7.7 kcal ≈ 1 g body fat (7700 kcal ≈ 1 kg body fat).
  static const double kcalPerGramFat = 7.7;
  static const double kcalPerKgFat = 7700.0;

  /// Returns body fat in grams (rounded to whole grams).
  /// Never returns negative values; returns 0 if [kcal] <= 0.
  static int gramsFromKcal(num kcal) {
    if (kcal <= 0) return 0;
    return (kcal / kcalPerGramFat).round();
  }

  /// Weekly grams from DietPlanEngine's weeklyLossKg (consistent with 7700 kcal / kg).
  /// weeklyGrams = (weeklyLossKg * 1000).round()
  static int weeklyGramsFromWeeklyLossKg(double weeklyLossKg) {
    if (weeklyLossKg <= 0) return 0;
    return (weeklyLossKg * 1000).round();
  }

  /// Returns true if [kcal] is positive and equals at least 1 whole gram of fat.
  static bool hasEquivalent(num? kcal) {
    if (kcal == null || kcal <= 0) return false;
    return gramsFromKcal(kcal) > 0;
  }

  /// Formats the weight amount string (e.g. "45 g", "1.2 kg", "45 جرام", "1.2 كجم").
  /// ≥ 1000 g → show kg with 1 decimal.
  static String formatAmount(int grams, {String? languageCode}) {
    if (grams <= 0) return '';
    final isAr = languageCode != null && languageCode.startsWith('ar');
    if (grams >= 1000) {
      final kg = (grams / 1000.0).toStringAsFixed(1);
      return isAr ? '$kg كجم' : '$kg kg';
    }
    return isAr ? '$grams جرام' : '$grams g';
  }

  /// Convenience formatting from kcal to amount string.
  static String formatAmountFromKcal(num kcal, {String? languageCode}) {
    return formatAmount(gramsFromKcal(kcal), languageCode: languageCode);
  }

  /// Formats an estimate string using [AppLocalizations].
  static String approxText(
    num kcal, {
    required AppLocalizations l10n,
    String? lang,
  }) {
    if (!hasEquivalent(kcal)) return '';
    final grams = gramsFromKcal(kcal);
    final amount = formatAmount(grams, languageCode: lang);
    return l10n.fatEquivalentApprox(amount);
  }

  /// Formats burned effort estimate string using [AppLocalizations] (supports ar_EG / ar_SA dialect copy).
  static String burnedText(
    num kcal, {
    required AppLocalizations l10n,
    String? lang,
  }) {
    if (!hasEquivalent(kcal)) return '';
    final grams = gramsFromKcal(kcal);
    final amount = formatAmount(grams, languageCode: lang);
    return l10n.fatEquivalentBurned(amount);
  }

  /// Formats planned diet program deficit rate ("≈ X g fat/day • ≈ Y g/week").
  static String dietPlanRateText({
    required int dailyDeficitKcal,
    required double weeklyLossKg,
    required AppLocalizations l10n,
    String? lang,
  }) {
    final dailyGrams = gramsFromKcal(dailyDeficitKcal);
    final weeklyGrams = weeklyGramsFromWeeklyLossKg(weeklyLossKg);
    if (dailyGrams <= 0 && weeklyGrams <= 0) return '';

    final dailyAmount = formatAmount(dailyGrams, languageCode: lang);
    final weeklyAmount = formatAmount(weeklyGrams, languageCode: lang);
    return l10n.fatEquivalentDietPlanRate(dailyAmount, weeklyAmount);
  }
}

/// Displays a one-tap info sheet explaining the fat equivalent estimate.
Future<void> showFatEquivalentInfoSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  final colors = context.vireoColors;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(VRadius.lg)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(VSpace.lg, VSpace.md, VSpace.lg, VSpace.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: VSpace.md),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.ember.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.info_outline, color: colors.ember, size: 20),
                ),
                const SizedBox(width: VSpace.sm),
                Expanded(
                  child: Text(
                    l10n.fatEquivalentInfoTitle,
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: VSpace.sm),
            Text(
              l10n.fatEquivalentInfoBody,
              style: TextStyle(
                color: colors.textMute,
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: VSpace.lg),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.fatEquivalentInfoDismiss),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Tappable badge / label that renders the fat equivalent and opens the info sheet on tap.
class FatEquivalentBadge extends StatelessWidget {
  const FatEquivalentBadge({
    super.key,
    this.kcal,
    this.grams,
    this.isBurned = false,
    this.customText,
    this.style,
    this.showIcon = true,
  });

  final num? kcal;
  final int? grams;
  final bool isBurned;
  final String? customText;
  final TextStyle? style;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final effectiveGrams =
        grams ?? (kcal != null ? FatEquivalent.gramsFromKcal(kcal!) : 0);
    if (customText == null && effectiveGrams <= 0) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final lang = Localizations.localeOf(context).languageCode;
    final amount = FatEquivalent.formatAmount(effectiveGrams, languageCode: lang);

    final text = customText ??
        (isBurned
            ? l10n.fatEquivalentBurned(amount)
            : l10n.fatEquivalentApprox(amount));

    return InkWell(
      onTap: () => showFatEquivalentInfoSheet(context),
      borderRadius: BorderRadius.circular(VRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                style: style ??
                    TextStyle(
                      color: colors.ember,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (showIcon) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.info_outline,
                size: 13,
                color: colors.textMute.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

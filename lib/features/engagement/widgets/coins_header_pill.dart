import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/engagement/providers/coins_provider.dart';

class CoinsHeaderPill extends ConsumerWidget {
  const CoinsHeaderPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final coins = ref.watch(coinsBalanceProvider);

    return Tooltip(
      message: isArabic ? '$coins عملة رحلة اليوم' : '$coins Journey Coins',
      child: Pressable(
        onTap: () {
          HapticFeedback.selectionClick();
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: colors.surfaceRaised,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
            ),
            builder: (ctx) => const _CoinsDetailSheet(),
          );
        },
        child: VireoPill(
          icon: Icons.stars_rounded,
          label: '$coins',
          color: colors.gold,
        ),
      ),
    );
  }
}

class _CoinsDetailSheet extends ConsumerWidget {
  const _CoinsDetailSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');
    final coins = ref.watch(coinsBalanceProvider);
    final isProActive = ref.watch(isCoinsProActiveProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.stars_rounded, color: colors.gold, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'عملات رحلة اليوم' : 'Daily Journey Coins',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                    ),
                    Text(
                      isArabic ? 'رصيدك الحالي: $coins عملة' : 'Current Balance: $coins Coins',
                      style: TextStyle(color: colors.textMute, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.line.withValues(alpha: 0.6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'كيف تكسب العملات يومياً؟' : 'How to earn coins daily:',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                ),
                const SizedBox(height: 8),
                _TaskRow(title: isArabic ? 'تسجيل وجبة' : 'Log a meal', points: '+10'),
                _TaskRow(title: isArabic ? 'إكمال هدف المشي' : 'Walk goal', points: '+25'),
                _TaskRow(title: isArabic ? 'شرب الماء' : 'Hydration', points: '+5'),
                _TaskRow(title: isArabic ? 'إكمال تمرين اليوم' : 'Workout', points: '+25'),
                _TaskRow(title: isArabic ? 'تسجيل الوزن' : 'Weigh-in', points: '+5'),
                _TaskRow(title: isArabic ? 'فحص المزاج/الراحة' : 'Mood check', points: '+5'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (isProActive) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'Vireo Pro مفعّل حالياً بحسابك لمدة ٢٤ ساعة ✨'
                          : 'Vireo Pro is currently active for 24h ✨',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: coins >= 500 ? colors.ember : colors.surfaceRaised,
                foregroundColor: coins >= 500 ? Colors.white : colors.textMute,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: coins >= 500
                  ? () async {
                      HapticFeedback.heavyImpact();
                      final ok = await ref.read(coinsBalanceProvider.notifier).spendForPro();
                      if (context.mounted && ok) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isArabic
                                  ? '🎉 مبروك! تم تفعيل Vireo Pro لمدة ٢٤ ساعة بنجاح.'
                                  : '🎉 Pro unlocked for 24 hours!',
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.lock_open_rounded, size: 18),
              label: Text(
                coins >= 500
                    ? (isArabic ? 'استبدل ٥٠٠ عملة بيوم Pro مجاناً' : 'Redeem 500 Coins for 1 Pro Day')
                    : (isArabic
                        ? 'باقي لك ${500 - coins} عملة لفتح Pro'
                        : '${500 - coins} coins left to unlock Pro'),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.title, required this.points});
  final String title;
  final String points;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 12.5, color: colors.text, fontWeight: FontWeight.w600)),
          Text(
            points,
            style: TextStyle(fontSize: 12.5, color: colors.gold, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

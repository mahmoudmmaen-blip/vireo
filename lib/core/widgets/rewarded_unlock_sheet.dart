import 'package:flutter/material.dart';
import 'package:vireo/core/services/ad_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

/// Shows a bottom sheet offering temporary feature unlock via a rewarded ad vs Pro subscription.
/// "شاهد إعلان قصير وافتح الميزة دي 24 ساعة" vs "اشترك Pro بدون إعلانات".
Future<bool> showRewardedUnlockSheet({
  required BuildContext context,
  required String featureTitle,
  required String featureDescription,
  required Future<void> Function() onUnlockGranted,
}) async {
  final colors = context.vireoColors;
  final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

  final canWatch = AdService.canWatchRewardedToday();

  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(VRadius.xl)),
    ),
    builder: (ctx) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🎁', style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      featureTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                featureDescription,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.textMute, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Option 1: Rewarded Ad Unlock
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.ember,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: canWatch
                    ? () async {
                        Navigator.pop(ctx);
                        await AdService.instance.showRewardedAd(
                          onRewarded: () async {
                            await onUnlockGranted();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  persist: false,
                                  content: Text(
                                    isArabic
                                        ? 'تم فتح الميزة بنجاح! 🎉'
                                        : 'Feature unlocked successfully! 🎉',
                                  ),
                                ),
                              );
                            }
                          },
                          onFailed: () {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  persist: false,
                                  content: Text(
                                    isArabic
                                        ? 'تعذر تحميل الإعلان، يرجى المحاولة لاحقاً'
                                        : 'Ad failed to load, please try again later',
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }
                    : null,
                icon: const Icon(Icons.play_circle_outline, size: 20),
                label: Text(
                  canWatch
                      ? (isArabic
                          ? 'شاهد إعلان قصير وافتح الميزة 24 ساعة'
                          : 'Watch a short ad to unlock for 24 hours')
                      : (isArabic
                          ? 'وصلت للحد الأقصى للإعلانات اليوم (5/5)'
                          : 'Daily rewarded ads limit reached (5/5)'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // Option 2: Pro Subscription
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: colors.gold, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  openPaywall(context);
                },
                icon: Icon(Icons.workspace_premium_rounded, color: colors.gold, size: 20),
                label: Text(
                  isArabic ? 'اشترك Pro بدون إعلانات 👑' : 'Subscribe to Pro Ad-Free 👑',
                  style: TextStyle(fontWeight: FontWeight.bold, color: colors.gold),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}

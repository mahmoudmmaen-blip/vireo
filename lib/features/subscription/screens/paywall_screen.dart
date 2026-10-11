import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/core/services/revenue_cat_service.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/core/ui/pressable.dart';
import 'package:vireo/core/ui/vireo_tokens.dart';
import 'package:vireo/data/models/subscription_state.dart';
import 'package:vireo/features/nutrition/providers/calorie_goal_provider.dart';
import 'package:vireo/features/subscription/providers/subscription_provider.dart';
import 'package:vireo/features/subscription/subscription_gate.dart';

Future<void> openPaywall(
  BuildContext context, {
  PaywallContext paywallContext = PaywallContext.standard,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => PaywallScreen(paywallContext: paywallContext),
    ),
  );
}

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.paywallContext = PaywallContext.standard});

  final PaywallContext paywallContext;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  SubscriptionPlanId _selected = SubscriptionPlanId.annual;
  var _purchasing = false;
  var _restoring = false;

  static const _termsUrl = 'https://vireo.app/terms';
  static const _privacyUrl = 'https://vireo.app/privacy';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _purchase() async {
    final l10n = AppLocalizations.of(context);
    final sub = ref.read(subscriptionProvider).valueOrNull;
    if (sub == null || !sub.isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          persist: false,
          content: Text(l10n.paywallNotConfigured),
        ),
      );
      return;
    }

    final package = RevenueCatService.findPackage(
      (await RevenueCatService.getOfferings())?.current,
      _selected,
    );
    if (!mounted) return;
    if (package == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          persist: false,
          content: Text(l10n.authErrorGeneric),
        ),
      );
      return;
    }

    setState(() => _purchasing = true);
    try {
      final info = await purchaseWithAccountGate(context, ref, package);
      if (!mounted) return;
      if (info != null) {
        await ref.read(subscriptionProvider.notifier).refresh();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            persist: false,
            content: Text(l10n.paywallPurchaseSuccess),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            persist: false,
            content: Text(l10n.paywallPurchaseError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _restore() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _restoring = true);
    try {
      final info = await restoreWithAccountGate(context, ref);
      if (!mounted) return;
      if (info == null) return;

      await ref.read(subscriptionProvider.notifier).refresh();
      if (!mounted) return;
      final snapshot = ref.read(subscriptionProvider).valueOrNull;
      if (snapshot?.hasPremiumAccess == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            persist: false,
            content: Text(l10n.paywallRestoreSuccess),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            persist: false,
            content: Text(l10n.paywallRestoreEmpty),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            persist: false,
            content: Text(l10n.paywallRestoreError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  String _computeHeroHeadline(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');

    try {
      final target = ref.watch(calorieGoalProvider);
      final profile = HiveService.isInitialized
          ? HiveService.cacheBox.get('guest_profile')
          : null;

      double weightKg = 75.0;
      double heightCm = 175.0;
      int age = 28;

      if (profile is Map) {
        if (profile['weight_kg'] != null) {
          weightKg = (profile['weight_kg'] as num).toDouble();
        }
        if (profile['height_cm'] != null) {
          heightCm = (profile['height_cm'] as num).toDouble();
        }
        if (profile['age'] != null) {
          age = (profile['age'] as num).toInt();
        }
      }

      final bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
      final maintenance = (bmr * 1.4).round();
      final diff = target.calories - maintenance;
      final weeklyChangeKg = (diff.abs() * 7 / 7700.0);

      final roundedRate = weeklyChangeKg > 0.1
          ? weeklyChangeKg.toStringAsFixed(1)
          : '0.5';

      if (diff <= 0) {
        return isAr
          ? 'اخسر ~$roundedRate كجم/أسبوع مع خطتك المخصصة'
          : 'Lose ~$roundedRate kg/week with your plan';
      } else {
        return isAr
          ? 'ابنِ ~$roundedRate كجم/أسبوع مع خطتك المخصصة'
          : 'Build ~$roundedRate kg/week with your plan';
      }
    } catch (_) {
      return isAr
        ? 'اخسر ~0.5 كجم/أسبوع مع خطتك المخصصة'
        : 'Lose ~0.5 kg/week with your plan';
    }
  }

  int _computeSavingsPercent(SubscriptionPlan? annual, SubscriptionPlan? monthly) {
    if (annual == null || monthly == null) return 50;
    if (monthly.rawPrice <= 0 || annual.rawPrice <= 0) return 50;

    final annualizedMonthly = monthly.rawPrice * 12.0;
    if (annualizedMonthly <= annual.rawPrice) return 0;

    final diff = annualizedMonthly - annual.rawPrice;
    final pct = ((diff / annualizedMonthly) * 100).round();
    return pct > 0 ? pct : 50;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.vireoColors;
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final subAsync = ref.watch(subscriptionProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: isAr ? 'إغلاق' : 'Close',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: (_purchasing || _restoring) ? null : _restore,
            child: _restoring
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    isAr ? 'استعادة' : 'Restore',
                    style: TextStyle(
                      color: colors.textMute,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: subAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(l10n.authErrorGeneric)),
        data: (snapshot) {
          final plans = snapshot.plans.isNotEmpty
              ? snapshot.plans
              : SubscriptionSnapshot.demoFree.plans;

          final annualPlan = plans.firstWhere(
            (p) => p.id == SubscriptionPlanId.annual,
            orElse: () => plans.first,
          );
          final monthlyPlan = plans.firstWhere(
            (p) => p.id == SubscriptionPlanId.monthly,
            orElse: () => plans.last,
          );

          final savingsPct = _computeSavingsPercent(annualPlan, monthlyPlan);
          final heroHeadline = _computeHeroHeadline(context);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              if (widget.paywallContext == PaywallContext.trialEnded) ...[
                _ContextBanner(
                  icon: Icons.hourglass_disabled,
                  message: l10n.trialEndedTitle,
                  color: colors.ember,
                ),
                const SizedBox(height: 16),
              ] else if (widget.paywallContext == PaywallContext.subscriptionExpired) ...[
                _ContextBanner(
                  icon: Icons.lock_clock,
                  message: l10n.paywallSubscriptionExpiredMessage,
                  color: colors.danger,
                ),
                const SizedBox(height: 16),
              ],

              // ── HERO: User's Own Numbers ──
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.gold.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(VRadius.pill),
                    border: Border.all(color: colors.gold.withValues(alpha: 0.45)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded, size: 16, color: colors.gold),
                      const SizedBox(width: 6),
                      Text(
                        'VIREO PRO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: colors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                heroHeadline,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isAr
                    ? 'وصول غير محدود لكل برامج التغذية والتدريب وذكاء ڤيريو المتقدم'
                    : 'Unlimited access to all diet programs, workouts, and advanced AI',
                style: TextStyle(color: colors.textMute, fontSize: 13.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ── 4 BENEFIT ROWS ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(VRadius.lg),
                  border: Border.all(color: colors.line),
                ),
                child: Column(
                  children: [
                    _BenefitRow(
                      icon: Icons.camera_alt_outlined,
                      title: isAr
                          ? 'مسح غير محدود للوجبات (50 مسح/يوم)'
                          : '50 Plate Scans / Day & Macro Swaps',
                      subtitle: isAr
                          ? 'تحليل ذكي فوري لكل الأكلات والمطاعم'
                          : 'Instant visual breakdown for meals & recipes',
                    ),
                    const Divider(height: 20),
                    _BenefitRow(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: isAr
                          ? 'مدرب ذكاء اصطناعي متاح دائماً (200 رسالة/يوم)'
                          : '200 AI Coach Messages / Day',
                      subtitle: isAr
                          ? 'توجيهات غذائية وبرامج تمرين متكيفة لحظياً'
                          : 'Daily answers, guidance, and motivation',
                    ),
                    const Divider(height: 20),
                    _BenefitRow(
                      icon: Icons.restaurant_menu_rounded,
                      title: isAr
                          ? 'كافة برامج التغذية السبعة + سعرات متكيفة'
                          : 'All 7 Diet Programs & Adaptive Calories',
                      subtitle: isAr
                          ? 'كيتو، لوكارب، صيام متقطع، عالي بروتين، والمزيد'
                          : 'Keto, low-carb, fasting, high-protein & more',
                    ),
                    const Divider(height: 20),
                    _BenefitRow(
                      icon: Icons.insights_rounded,
                      title: isAr
                          ? 'تقرير أسبوعي شامل + مسار GPS وبروتوكول Pro'
                          : 'Weekly Deep Reports & GPS Activity',
                      subtitle: isAr
                          ? 'تحليل اتجاهات الوزن وخرائط التمارين وبدون أي إعلانات'
                          : 'Full trend analysis, wearable health, zero banners',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── PRODUCT SELECTION (Annual Pre-selected with Save X%) ──
              ...plans.map((plan) {
                final isSelected = _selected == plan.id;
                final isAnnual = plan.id == SubscriptionPlanId.annual;
                final title = isAnnual
                    ? (isAr ? 'الاشتراك السنوي' : 'Annual')
                    : (isAr ? 'الاشتراك الشهري' : 'Monthly');

                final subtext = isAnnual
                    ? (isAr
                        ? 'تجربة مجانية 7 أيام · ثم ${plan.priceString}'
                        : '7-day free trial · then ${plan.priceString}')
                    : (isAr
                        ? 'تجديد شهري · ${plan.priceString}'
                        : 'Billed monthly · ${plan.priceString}');

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Pressable(
                    onTap: () => setState(() => _selected = plan.id),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.ember.withValues(alpha: 0.12)
                            : colors.surfaceRaised,
                        borderRadius: BorderRadius.circular(VRadius.lg),
                        border: Border.all(
                          color: isSelected ? colors.ember : colors.line,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected ? colors.ember : colors.textMute,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    if (isAnnual) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.ember,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isAr
                                              ? 'وفر $savingsPct%'
                                              : 'SAVE $savingsPct%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plan.priceString,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: colors.text,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtext,
                                  style: TextStyle(
                                    color: colors.textMute,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 18),

              // ── 7-DAY TRIAL TIMELINE (Today / Day 5 reminder / Day 7 billing) ──
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(VRadius.lg),
                  border: Border.all(color: colors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'كيف تعمل التجربة المجانية:' : 'How your free trial works:',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TimelineStep(
                      stepNumber: '1',
                      title: isAr ? 'اليوم: تجربة مجانية فورية' : 'Today: Instant Free Access',
                      subtitle: isAr
                          ? 'افتح كل ميزات Pro فوراً بدون دفع أي مليم اليوم'
                          : 'Unlock all Pro features immediately. No charge today.',
                      isFirst: true,
                    ),
                    _TimelineStep(
                      stepNumber: '2',
                      title: isAr ? 'اليوم الخامس: تنبيه مسبق' : 'Day 5: Friendly Reminder',
                      subtitle: isAr
                          ? 'هنفكرك بإشعار قبل انتهاء التجربة بيومين — إلغاء سهل في أي وقت'
                          : "We'll notify you 2 days before trial ends. Cancel anytime.",
                    ),
                    _TimelineStep(
                      stepNumber: '3',
                      title: isAr ? 'اليوم السابع: بدء الاشتراك' : 'Day 7: Billing Starts',
                      subtitle: isAr
                          ? 'يبدأ الاشتراك تلقائياً فقط إذا قررت الاستمرار'
                          : 'Your plan starts automatically only if you choose to stay.',
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── CTA BUTTON ──
              ElevatedButton(
                onPressed: (_purchasing || _restoring) ? null : _purchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.ember,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(VRadius.md),
                  ),
                ),
                child: _purchasing
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _selected == SubscriptionPlanId.annual
                            ? (isAr ? 'ابدأ تجربة الـ 7 أيام مجاناً' : 'Start 7-Day Free Trial')
                            : (isAr ? 'اشترك الآن' : 'Subscribe Now'),
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
              const SizedBox(height: 14),

              // ── RESTORE PURCHASES ──
              Center(
                child: TextButton(
                  onPressed: (_purchasing || _restoring) ? null : _restore,
                  child: _restoring
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          l10n.paywallRestorePurchases,
                          style: TextStyle(
                            color: colors.textMute,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),

              // ── TERMS + PRIVACY LINKS ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _openUrl(_termsUrl),
                    child: Text(
                      isAr ? 'الشروط والأحكام' : 'Terms of Service',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colors.textMute,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('·', style: TextStyle(color: colors.textMute)),
                  ),
                  GestureDetector(
                    onTap: () => _openUrl(_privacyUrl),
                    child: Text(
                      isAr ? 'سياسة الخصوصية' : 'Privacy Policy',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colors.textMute,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: colors.ember.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colors.ember, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  color: colors.textMute,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    this.isFirst = false,
    this.isLast = false,
  });

  final String stepNumber;
  final String title;
  final String subtitle;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.ember.withValues(alpha: 0.18),
                border: Border.all(color: colors.ember),
              ),
              alignment: Alignment.center,
              child: Text(
                stepNumber,
                style: TextStyle(
                  color: colors.ember,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 26,
                color: colors.line,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMute,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContextBanner extends StatelessWidget {
  const _ContextBanner({
    required this.icon,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

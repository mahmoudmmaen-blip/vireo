import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/features/subscription/feature_gates.dart';
import 'package:vireo/features/subscription/screens/paywall_screen.dart';

/// Standard adaptive banner widget displayed at the bottom of non-critical screens
/// (Diet programs list, Progress, Recipes). NEVER displayed for Pro users or on web.
class VireoBannerAdWidget extends ConsumerStatefulWidget {
  const VireoBannerAdWidget({super.key});

  @override
  ConsumerState<VireoBannerAdWidget> createState() => _VireoBannerAdWidgetState();
}

class _VireoBannerAdWidgetState extends ConsumerState<VireoBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() {
    final isPro = ref.read(isProUserProvider);
    if (isPro || kIsWeb) return;
    if (_bannerAd != null) return;

    _bannerAd = BannerAd(
      adUnitId: AppConfig.admobBannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProUserProvider);
    if (isPro || kIsWeb || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        color: Colors.transparent,
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}

/// Native ad card styled exactly like application cards, labeled "إعلان"
/// with an "إزالة الإعلانات" link leading directly to the paywall.
/// NEVER displayed for Pro users.
class VireoNativeAdCard extends ConsumerStatefulWidget {
  const VireoNativeAdCard({super.key});

  @override
  ConsumerState<VireoNativeAdCard> createState() => _VireoNativeAdCardState();
}

class _VireoNativeAdCardState extends ConsumerState<VireoNativeAdCard> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    final isPro = ref.read(isProUserProvider);
    if (isPro || kIsWeb) return;
    if (_nativeAd != null) return;

    _nativeAd = NativeAd(
      adUnitId: AppConfig.admobNativeId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Colors.transparent,
        cornerRadius: 16.0,
      ),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = ref.watch(isProUserProvider);
    if (isPro || kIsWeb) {
      return const SizedBox.shrink();
    }

    final colors = context.vireoColors;
    final isArabic = Localizations.localeOf(context).languageCode.startsWith('ar');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.line),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isArabic ? 'إعلان' : 'Ad',
                    style: TextStyle(fontSize: 10, color: colors.textMute, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () => openPaywall(context),
                  child: Text(
                    isArabic ? 'إزالة الإعلانات ✨' : 'Remove Ads ✨',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colors.gold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isLoaded && _nativeAd != null)
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 320,
                  minHeight: 90,
                  maxWidth: 400,
                  maxHeight: 100,
                ),
                child: AdWidget(ad: _nativeAd!),
              )
            else
              Container(
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.workspace_premium_rounded, color: colors.gold, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      isArabic ? 'استمتع بتجربة هادئة وسريعة بدون إعلانات مع Pro' : 'Enjoy an ad-free experience with Vireo Pro',
                      style: TextStyle(fontSize: 12, color: colors.textMute),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

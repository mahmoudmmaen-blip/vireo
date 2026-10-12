import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/hive_service.dart';
import 'package:vireo/features/ramadan/services/ramadan_schedule_service.dart';

/// Handles MobileAds initialization, UMP user consent, ad loading,
/// interstitial frequency capping, and rewarded ad unlock logic.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static const String _lastInterstitialTimeKey = 'ad_last_interstitial_time';
  static const String _dailyInterstitialCountKey = 'ad_daily_interstitial_count';
  static const String _dailyRewardedCountKey = 'ad_daily_rewarded_count';
  static const String _installDateKey = 'app_install_date';

  static const int minMinutesBetweenInterstitials = 10;
  static const int maxInterstitialsPerDay = 3;
  static const int minDaysAfterInstallForInterstitial = 3;
  static const int maxRewardedAdsPerDay = 5;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;

  /// Initialize MobileAds SDK after first frame for non-Pro users.
  Future<void> initialize({required bool isPro}) async {
    if (isPro || kIsWeb) return;
    if (_initialized) return;

    try {
      _recordInstallDateIfNeeded();

      // Configure strictly family-safe content filter: Max rating G
      // ignore: deprecated_member_use
      await MobileAds.instance.updateRequestConfiguration(
        // ignore: deprecated_member_use
        RequestConfiguration(
          maxAdContentRating: MaxAdContentRating.g,
          // ignore: deprecated_member_use
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
          // ignore: deprecated_member_use
          tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
        ),
      );

      // Check / request UMP consent (EEA/UK requirement)
      await _requestConsent();

      // Initialize SDK
      await MobileAds.instance.initialize();
      _initialized = true;
      BootLog.ok('AdService.initialize: MobileAds initialized with MaxAdContentRating.g');

      // Preload interstitial
      preloadInterstitial();
    } catch (e) {
      BootLog.warn('AdService.initialize failed', e);
    }
  }

  void _recordInstallDateIfNeeded() {
    if (!HiveService.isInitialized) return;
    final box = HiveService.settingsBox;
    if (!box.containsKey(_installDateKey)) {
      box.put(_installDateKey, DateTime.now().toIso8601String());
    }
  }

  /// Request Google UMP Consent Information
  Future<void> _requestConsent() async {
    final completer = Completer<void>();
    final params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((formError) {
          if (formError != null) {
            BootLog.warn('UMP ConsentForm error: ${formError.message}');
          }
          completer.complete();
        });
      },
      (formError) {
        BootLog.warn('UMP ConsentInfo error: ${formError.message}');
        completer.complete();
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 4),
      onTimeout: () {
        BootLog.warn('AdService UMP consent timed out');
      },
    );
  }

  /// Check if Privacy Options form is available to show in Settings (EEA/UK)
  Future<bool> isPrivacyOptionsRequired() async {
    if (kIsWeb) return false;
    try {
      final status = await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (_) {
      return false;
    }
  }

  /// Show privacy options form when requested from Settings
  Future<void> showPrivacyOptionsForm() async {
    if (kIsWeb) return;
    ConsentForm.showPrivacyOptionsForm((formError) {
      if (formError != null) {
        BootLog.warn('Error showing privacy options form: ${formError.message}');
      }
    });
  }

  // ─────────────────────────────────────────────────────────────
  // Interstitial Management
  // ─────────────────────────────────────────────────────────────

  /// Preloads an interstitial ad if not already loading or loaded.
  void preloadInterstitial() {
    if (kIsWeb || _interstitialAd != null || _isInterstitialLoading) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: AppConfig.admobInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
          BootLog.warn('Interstitial failed to load: ${error.message}');
        },
      ),
    );
  }

  /// Checks if an interstitial ad is eligible to be shown right now:
  /// 1. Not Pro user
  /// 2. Installed >= 3 days ago
  /// 3. At least 10 minutes since last interstitial
  /// 4. Max 3 interstitials per day
  bool canShowInterstitial({
    required bool isPro,
    DateTime? nowOverride,
  }) {
    if (isPro || kIsWeb) return false;
    if (!HiveService.isInitialized) return false;

    final now = nowOverride ?? DateTime.now();
    final box = HiveService.settingsBox;
    // Suppress ads during Ramadan fasting hours if Ramadan mode is enabled
    final ramadanEnabled = box.get('ramadan_mode_enabled') as bool? ?? false;
    if (ramadanEnabled) {
      final methodKey = box.get('ramadan_calculation_method') as String?;
      final method = RamadanCalculationMethod.fromKey(methodKey);
      final lat = (box.get('ramadan_lat') as num?)?.toDouble() ?? method.defaultLat;
      final lng = (box.get('ramadan_lng') as num?)?.toDouble() ?? method.defaultLng;
      final prayer = RamadanPrayerTimes.calculate(lat: lat, lng: lng, method: method, date: now);
      if (prayer.isFasting) {
        return false;
      }
    }

    // Check 3 days post-install grace period
    final installStr = box.get(_installDateKey) as String?;
    if (installStr != null) {
      final installDate = DateTime.tryParse(installStr);
      if (installDate != null &&
          now.difference(installDate).inDays < minDaysAfterInstallForInterstitial) {
        return false;
      }
    }

    // Check daily cap
    final today = _dateKey(now);
    final countData = box.get('${_dailyInterstitialCountKey}_$today') as int? ?? 0;
    if (countData >= maxInterstitialsPerDay) {
      return false;
    }

    // Check 10-minute cooldown
    final lastTimeStr = box.get(_lastInterstitialTimeKey) as String?;
    if (lastTimeStr != null) {
      final lastTime = DateTime.tryParse(lastTimeStr);
      if (lastTime != null &&
          now.difference(lastTime).inMinutes < minMinutesBetweenInterstitials) {
        return false;
      }
    }

    return true;
  }

  /// Shows an interstitial ad if eligible after a natural break.
  Future<bool> showInterstitialIfEligible({
    required bool isPro,
    VoidCallback? onDismissed,
  }) async {
    if (!canShowInterstitial(isPro: isPro)) {
      onDismissed?.call();
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      preloadInterstitial();
      onDismissed?.call();
      return false;
    }

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial();
        onDismissed?.call();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitial();
        onDismissed?.call();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    // Record usage
    final now = DateTime.now();
    final box = HiveService.settingsBox;
    final today = _dateKey(now);
    final count = (box.get('${_dailyInterstitialCountKey}_$today') as int? ?? 0) + 1;
    await box.put('${_dailyInterstitialCountKey}_$today', count);
    await box.put(_lastInterstitialTimeKey, now.toIso8601String());

    await ad.show();
    return completer.future;
  }

  // ─────────────────────────────────────────────────────────────
  // Rewarded Ads & Unlocks
  // ─────────────────────────────────────────────────────────────

  /// Checks if user can watch another rewarded ad today (max 5/day).
  static bool canWatchRewardedToday({DateTime? nowOverride}) {
    if (!HiveService.isInitialized) return true;
    final now = nowOverride ?? DateTime.now();
    final today = _dateKey(now);
    final count = HiveService.settingsBox.get('${_dailyRewardedCountKey}_$today') as int? ?? 0;
    return count < maxRewardedAdsPerDay;
  }

  /// Increments daily rewarded ad count.
  static Future<void> incrementRewardedCountToday({DateTime? nowOverride}) async {
    if (!HiveService.isInitialized) return;
    final now = nowOverride ?? DateTime.now();
    final today = _dateKey(now);
    final count = (HiveService.settingsBox.get('${_dailyRewardedCountKey}_$today') as int? ?? 0) + 1;
    await HiveService.settingsBox.put('${_dailyRewardedCountKey}_$today', count);
  }

  /// Loads and presents a rewarded ad, invoking [onRewarded] only upon completion.
  Future<bool> showRewardedAd({
    required VoidCallback onRewarded,
    VoidCallback? onFailed,
  }) async {
    if (kIsWeb) {
      // In web, grant reward directly for testing or fail gracefully
      onRewarded();
      return true;
    }

    if (!canWatchRewardedToday()) {
      onFailed?.call();
      return false;
    }

    final completer = Completer<bool>();

    RewardedAd.load(
      adUnitId: AppConfig.admobRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(true);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onFailed?.call();
              if (!completer.isCompleted) completer.complete(false);
            },
          );

          ad.show(
            onUserEarnedReward: (adWithoutView, reward) async {
              await incrementRewardedCountToday();
              onRewarded();
            },
          );
        },
        onAdFailedToLoad: (error) {
          BootLog.warn('Rewarded ad failed to load: ${error.message}');
          onFailed?.call();
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    return completer.future;
  }

  static String _dateKey(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}

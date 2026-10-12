Act as a Senior Flutter monetization engineer on Vireo (branch ux-v2). Add family-safe ads for FREE users only, plus rewarded ads that temporarily unlock some Pro features. Pro subscribers never see ads. Work autonomously.

1. SDK + config
   - Add google_mobile_ads (latest stable).
   - Android manifest: com.google.android.gms.ads.APPLICATION_ID meta-data via manifestPlaceholders from a gradle property ADMOB_APP_ID. Default to the Google TEST app id ca-app-pub-3940256099942544~3347511713 so the app never crashes.
   - Ad unit ids come from dart-defines: ADMOB_BANNER_ID, ADMOB_NATIVE_ID, ADMOB_INTERSTITIAL_ID, ADMOB_REWARDED_ID. Default to Google's official TEST unit ids. Add them to AppConfig and docs/RELEASE.md.
   - Initialize MobileAds only when the user is not Pro, after first frame (not in main before runApp).
   - Consent: Google UMP (ConsentInformation / ConsentForm) before loading ads; show the form only where required (EEA/UK). Add "Privacy options" entry in Settings when required.

2. Content safety. The owner requires the strictest possible filtering: no women imagery, no sexual or dating content, no lingerie or women's clothing.
   - Code: MobileAds.instance.updateRequestConfiguration(RequestConfiguration(maxAdContentRating: MaxAdContentRating.g, tagForChildDirectedTreatment: unspecified, tagForUnderAgeOfConsent: unspecified)).
   - Write docs/ADMOB_SAFETY.md: a step-by-step checklist for the owner in the AdMob dashboard (Blocking controls → Content → max rating G; Sensitive categories → block ALL possible incl. Dating, Sexual & reproductive health, References to sex, Gambling, Alcohol, Sensational & shocking, Get-rich-quick, Religion/Politics; General categories → block Apparel (Women's clothing, Lingerie & underwear, Swimwear), Beauty & personal care, Fashion; Ad review center → turn on manual review/block by advertiser; disable Personalized ads optional). Note honestly that no filter is 100% and the Ad review center lets him block any ad he sees.

3. Placements (respectful UX, never during a workout, GPS walk, meal scan or onboarding):
   - One native ad card styled like app cards, labeled "إعلان", in Home feed below the main cards, and one in the nutrition log list.
   - Adaptive banner at the bottom of: diet programs list, progress, recipes. Never on the Today Plan, workout player or paywall.
   - Interstitial: at most once every 10 minutes and max 3/day, only after a natural break (after saving a meal, after finishing a workout summary). Never in the first 3 days after install.
   - "إزالة الإعلانات" link on ad cards → paywall.

4. Rewarded ads unlock some Pro features temporarily:
   - Watch an ad → +2 extra AI meal scans today (beyond the free daily limit).
   - Watch an ad → unlock one Pro diet program or the AI coach for 24 hours.
   - Watch an ad → unlock today's Pro vitality protocol item.
   - Track unlocks in Hive with an expiry and integrate them with the existing Pro feature gates (lib/features/subscription). Max 5 rewarded ads/day. Show a clear sheet: "شاهد إعلان قصير وافتح الميزة دي 24 ساعة" vs "اشترك Pro بدون إعلانات".

5. Privacy and store docs
   - Add the AD_ID permission (AdMob needs it).
   - Update web/legal/privacy_en.html and privacy_ar.html: AdMob, device advertising ID, consent, how to opt out. Replace support@vireo.app with mahmoud.mma.en@gmail.com in all web/legal pages. Remove vireo.app URLs.
   - Update docs/store/DATA_SAFETY.md: Device or other IDs collected and shared with Google AdMob for advertising/analytics; approximate location shared for ads only if AdMob collects it.
   - Update the "Contains ads" answer to Yes.

6. Tests and wrap-up
   - Unit tests: interstitial frequency cap, rewarded unlock expiry, Pro users get no ad widgets.
   - flutter gen-l10n (all 10 locales).
   - flutter analyze must show 0 errors.
   - Run affected tests with --timeout 2m.
   - flutter build apk --debug.
   - git add -A && git commit -m "feat(ads): AdMob for free users, strict safety, rewarded Pro unlocks". Do not push.

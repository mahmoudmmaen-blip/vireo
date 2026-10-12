# Google Play Data Safety Form Answers for Vireo

This document outlines the exact responses required for the Google Play Data Safety declaration, based directly on the actual Vireo source code.

## 1. Overview
- **Does your app collect or share any of the required user data types?** Yes.
- **Is all of the user data collected by your app encrypted in transit?** Yes, via HTTPS/TLS.
- **Do you provide a way for users to request that their data is deleted?** Yes, both directly in the app (in &le; 3 taps: `Profile -> Settings -> Delete Account`) and via email (`mahmoud.mma.en@gmail.com`).
- **Does your app contain ads?** **Yes** (Google AdMob for free tier users; Pro users are 100% ad-free).

---

## 2. Data Types Collected & Shared

### Device or Other IDs
- **Data Type:** Device or other IDs (Advertising ID / AD_ID).
- **Collected:** Yes (via Google Mobile Ads SDK for free tier users).
- **Shared:** Yes (shared with Google AdMob for advertising and analytics).
- **Ephemeral:** Handled according to Google Advertising standards.
- **Purpose:** Advertising & Marketing, Analytics.
- **Opt-out:** Users can opt out via OS settings (Reset/Delete Advertising ID) and via in-app UMP Privacy Options.

### Location
- **Data Type:** Approximate Location & Precise Location
- **Collected:** Yes (during outdoor GPS walking/running workouts only).
- **Shared:** Approximate location may be shared with Google AdMob for ad delivery only if AdMob collects network-derived location for non-Pro users. Precise GPS is never shared with third parties.
- **Background Location:** **NO**. Vireo uses foreground service only during active tracking.
- **Ephemeral:** Yes, converted to workout routes saved in the user's private database.
- **Purpose:** App functionality (recording workout route, distance, and pace) and Advertising (approximate location for free users).

### Health & Fitness
- **Data Type:** Health info (weight, body measurements) & Fitness info (steps, workout exercise records).
- **Collected:** Yes.
- **Shared:** No. (Only steps and streak are optionally shared in user-initiated friend challenges; never weight or health metrics).
- **Purpose:** App functionality, personal wellness analytics.
- **Health Connect:** Step count data read with user consent.

### Photos and Videos
- **Data Type:** Photos (food scans and optional progress photos).
- **Collected:** Yes.
- **Shared:** No.
- **Purpose:** App functionality (AI food identification via Google Gemini API).
- **Ephemeral Processing:** Food photos are analyzed ephemerally to estimate ingredients and macros. Progress photos are never backed up unless user opts in.

### Personal Info
- **Data Type:** Email address & User IDs.
- **Collected:** Yes (via Supabase authentication).
- **Shared:** No.
- **Purpose:** Account management, secure cross-device sync.

### Financial Info
- **Data Type:** Purchase history.
- **Collected:** Yes (via RevenueCat / Google Play Billing).
- **Shared:** No.
- **Purpose:** Subscription entitlement and premium feature unlocking. Credit card data is never handled directly.

### Audio (Voice Logging)
- **Data Type:** Voice recordings / audio data (`RECORD_AUDIO`).
- **Collected:** No (processed ephemerally on-device; never saved or stored).
- **Shared:** No.
- **Ephemeral Processing:** Yes. Audio is converted to text on-device using platform speech recognition (`speech_to_text`). Only the recognized meal description text is transmitted to the AI meal parser Edge Function. Audio recordings are never retained, stored on disk, or uploaded to servers.
- **Purpose:** App functionality (voice logging meals and nutrition).

### App Info & Performance
- **Data Type:** Crash logs and diagnostics.
- **Collected:** Yes (via Sentry and Google AdMob diagnostics).
- **Shared:** Shared with Google AdMob / Sentry for analytics and crash diagnostics. Free of personal/health data.
- **Purpose:** Analytics, diagnostics, and app performance.

---

## 3. Data Deletion Mechanism
- In-app: `Profile -> Settings -> Delete Account` (immediate hard cascade delete).
- Email request: Contact `mahmoud.mma.en@gmail.com` with subject "Account Deletion Request".

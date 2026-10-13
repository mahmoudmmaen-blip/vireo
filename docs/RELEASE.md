# Vireo Android Release Guide

This document explains how to generate the release signing key, configure `android/key.properties`, and build a production release Android App Bundle (`.aab`) for Google Play.

---

## 1. Prerequisites

- Flutter SDK (3.29+)
- Java / JDK 17+ with `keytool` available in your `PATH` (or under `<JAVA_HOME>/bin`)
- Android SDK 36 (or minimum target requirement per Google Play Console)
- Access to the Vireo Supabase, RevenueCat, and Sentry projects

---

## 2. Generate Upload Keystore

Run the following command in **PowerShell**.

> **IMPORTANT:** Keystores must **never** be checked into version control. Store your keystore outside the repository directory (e.g. `N:\keys\vireo-upload.jks`).

```powershell
# Create external directory for keys if it does not exist
if (-not (Test-Path "N:\keys")) { New-Item -ItemType Directory -Path "N:\keys" }

# Generate the keystore
keytool -genkey -v `
  -keystore "N:\keys\vireo-upload.jks" `
  -alias "vireo-upload" `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -storetype JKS
```

Make sure to note down and securely back up:
1. Keystore file (`N:\keys\vireo-upload.jks`)
2. Store password
3. Key alias (`vireo-upload`)
4. Key password

---

## 3. Configure `android/key.properties`

Create a file named `key.properties` inside the `android/` folder:

```
android/key.properties
```

Populate it with the following template (using forward slashes `/` for the file path on Windows):

```properties
storeFile=N:/keys/vireo-upload.jks
storePassword=<STORE_PASSWORD>
keyAlias=vireo-upload
keyPassword=<KEY_PASSWORD>
```

> **Note:** `android/key.properties` and `*.jks` / `*.keystore` are ignored by git in `.gitignore`. If `key.properties` is missing, `android/app/build.gradle.kts` falls back to debug signing to allow local development and debug builds.

---

## 4. Supabase Auth URL Configuration

The application ID has been configured to `com.vireofit.app`.

In your **Supabase Dashboard**:
1. Navigate to **Authentication** -> **URL Configuration**.
2. Add the following redirect URI to **Redirect URLs**:
   ```
   com.vireofit.app://login-callback
   ```
3. Save changes.

---

## 5. Build Release App Bundle

Run the following command from the repository root (`n:\vireo`). Replace each `<PLACEHOLDER>` with your production secrets and values.

```powershell
flutter build appbundle --release `
  --dart-define=SUPABASE_URL="<SUPABASE_URL>" `
  --dart-define=SUPABASE_ANON_KEY="<SUPABASE_ANON_KEY>" `
  --dart-define=SENTRY_DSN="<SENTRY_DSN>" `
  --dart-define=APP_ENVIRONMENT="production" `
  --dart-define=APP_RELEASE="vireo@1.0.0+1" `
  --dart-define=REVENUECAT_APPLE_API_KEY="<REVENUECAT_APPLE_API_KEY>" `
  --dart-define=REVENUECAT_GOOGLE_API_KEY="<REVENUECAT_GOOGLE_API_KEY>" `
  --dart-define=REVENUECAT_ENTITLEMENT_ID="pro" `
  --dart-define=REVENUECAT_MONTHLY_PRODUCT_ID="vireo_pro_monthly" `
  --dart-define=REVENUECAT_ANNUAL_PRODUCT_ID="vireo_pro_annual" `
  --dart-define=GOOGLE_WEB_CLIENT_ID="<GOOGLE_WEB_CLIENT_ID>" `
  --dart-define=GOOGLE_IOS_CLIENT_ID="<GOOGLE_IOS_CLIENT_ID>" `
  --dart-define=GOOGLE_AUTH_ENABLED=true `
  --dart-define=APPLE_AUTH_ENABLED=false `
  --dart-define=ADMOB_BANNER_ID="<ADMOB_BANNER_ID>" `
  --dart-define=ADMOB_NATIVE_ID="<ADMOB_NATIVE_ID>" `
  --dart-define=ADMOB_INTERSTITIAL_ID="<ADMOB_INTERSTITIAL_ID>" `
  --dart-define=ADMOB_REWARDED_ID="<ADMOB_REWARDED_ID>"
```

### Complete List of Environment Variables from `AppConfig`

| Define Variable | Default Value | Description |
|---|---|---|
| `SUPABASE_URL` | `https://jzizpqriifrcgiksnddq.supabase.co` | Supabase project API URL |
| `SUPABASE_ANON_KEY` | `sb_publishable_...` | Supabase publishable/anonymous API key |
| `SENTRY_DSN` | `""` | Sentry error tracking DSN |
| `APP_ENVIRONMENT` | `"production"` | Environment name (`production`, `staging`, `development`) |
| `APP_RELEASE` | `"vireo@1.0.0+1"` | Release version identifier tag |
| `REVENUECAT_APPLE_API_KEY` | `""` | RevenueCat API key for iOS |
| `REVENUECAT_GOOGLE_API_KEY` | `""` | RevenueCat API key for Android (Google Play) |
| `REVENUECAT_ENTITLEMENT_ID` | `"pro"` | Entitlement identifier configured in RevenueCat |
| `REVENUECAT_MONTHLY_PRODUCT_ID`| `"vireo_pro_monthly"` | Google Play Subscription Product ID for Monthly |
| `REVENUECAT_ANNUAL_PRODUCT_ID` | `"vireo_pro_annual"` | Google Play Subscription Product ID for Annual |
| `GOOGLE_WEB_CLIENT_ID` | `""` | Google OAuth Web Client ID for Android/Web Sign-In |
| `GOOGLE_IOS_CLIENT_ID` | `""` | Google OAuth iOS Client ID |
| `GOOGLE_AUTH_ENABLED` | `false` | Set to `true` to enable Google Sign-In |
| `APPLE_AUTH_ENABLED` | `false` | Set to `true` to enable Apple Sign-In |
| `ADMOB_BANNER_ID` | `ca-app-pub-3940256099942544/6300978111` | AdMob Banner ad unit ID (default: Google test ID) |
| `ADMOB_NATIVE_ID` | `ca-app-pub-3940256099942544/2247696110` | AdMob Native ad unit ID (default: Google test ID) |
| `ADMOB_INTERSTITIAL_ID` | `ca-app-pub-3940256099942544/1033173712` | AdMob Interstitial ad unit ID (default: Google test ID) |
| `ADMOB_REWARDED_ID` | `ca-app-pub-3940256099942544/5224354917` | AdMob Rewarded ad unit ID (default: Google test ID) |

---

## 5b. Owner & Google Play Reviewer Access Grant (`pro_grants`)

Reviewers and owners need full Pro access without paying or being constrained by free AI scan quotas. Run the following SQL command in your Supabase SQL editor or via CLI to grant Pro access:

```sql
-- Grant Pro to reviewer:
INSERT INTO public.pro_grants (email, note, expires_at)
VALUES ('reviewer@example.com', 'Google Play App Reviewer', NULL)
ON CONFLICT (email) DO UPDATE SET expires_at = NULL;

-- Grant Pro to app owner:
INSERT INTO public.pro_grants (email, note, expires_at)
VALUES ('owner@vireofit.com', 'App Owner / Admin', NULL)
ON CONFLICT (email) DO UPDATE SET expires_at = NULL;
```

*(Replace `'reviewer@example.com'` and `'owner@vireofit.com'` with the actual reviewer and owner emails)*.
When the granted email signs into Vireo, the app and Edge Functions (`hasPremiumEntitlement`) automatically grant Pro access across all features, no ads, and 50 AI scans/day.

---

## 6. Release Artifact Output

After the build completes successfully, the App Bundle will be located at:
```
build/app/outputs/bundle/release/app-release.aab
```

Upload this `.aab` file to **Google Play Console** under **Internal testing**, **Closed testing**, or **Production**.

---

## 7. Google Play Data-Safety Declaration (Health & Menstrual Data)

When completing or updating the **Data safety form** in Google Play Console:

| Data Type | Collected? | Shared? | Processing / Storage | Purpose | User Control |
|---|---|---|---|---|---|
| **Health info – Menstrual / Cycle tracking** (`Health and fitness`) | **No** (Stored locally only) | **No** | Stored strictly in local encrypted on-device storage (Hive). Never uploaded to Supabase or transmitted over network unless explicitly opted into cloud backup. | App functionality / Personalization | User can clear all cycle data on-demand via the "امسحي بيانات الدورة" button in Women's Health settings. |
| **Fitness info – Workouts, Steps, Weight** (`Health and fitness`) | **Yes** (if logged in) | **No** | Transmitted over HTTPS to Supabase for multi-device sync. | App functionality, analytics | Export/Delete account and all data supported. |
| **User ID & Email** (`Personal info`) | **Yes** | **No** | Authentication and entitlement tracking (RevenueCat / Supabase). | Account management | Delete account supported. |


# Google Play reviewer notes — Vireo (Android)

**Package:** `com.vireofit.app`  
**Version for this submission:** 1.0.0+3  
**Contact:** mahmoud.mma.en@gmail.com

Vireo is a fitness / nutrition / steps app (wellness, not a medical device). No account is required to explore most flows; guest mode works offline for logging.

---

## How to reach gated features

| Feature | How to open | Gate |
|---|---|---|
| Meal photo scan | Home → “Snap your meal” / camera card | Free: 3 AI scans/day (5 in week 1). Hard paywall only after limit. |
| Text / voice meal log | Meal capture → text / mic | Free, unlimited. Mic permission asked only when voice is tapped. |
| Barcode | Meal capture → barcode | Free, never paywalled. |
| Manual food entry | Nutrition → add food / search | Free. |
| Fasting timer | Home fasting card or Fasting tab | Free. Pregnancy / diabetes safety confirms for long fasts. |
| Ramadan mode | Settings → Goals / Ramadan | Free, never paywalled. |
| Steps / walk | Home step journey or Walk tab | Free. Health Connect optional. |
| Body / InBody | Home body card → Body composition → **Scan InBody report**, or Measurements | Free. Any clear report photo or PDF works. |
| Women’s health | Home (female profile) → Women’s card | Free. **Cycle data stays on-device only** (encrypted Hive); never uploaded. |
| Men’s vitality | Hidden behind `mensVitalityModule=false` for v1 | N/A for review unless flag enabled. |
| Outdoor GPS run | Hidden behind `gpsRunScreen=false` | N/A for review unless flag enabled. |
| AI Coach chat | Coach tab | Pro only (30 msgs/day). Free users see quick-action chips. |
| Adaptive coach / unlimited scans | Paywall from Settings → Subscription or after scan limit | RevenueCat Pro / trial / `pro_grants` / coin Pro day. |
| Ads | Home / Progress / Diet list (free only) | Never shown for Pro, `pro_grants`, or coin-unlocked Pro days. G-rated only. UMP consent before first ad (EEA/UK). Privacy options in Settings → About. |

---

## Food photo tip

**Any clear food photo works** (home-cooked Egyptian/Gulf plates, restaurant meals, packaged food). Gallery pick is fine — no need for a specific demo meal. After analysis, adjust portions with household measures (cups, spoons, loaf).

---

## Where InBody scan is

1. Open **Home** (after onboarding).  
2. Scroll to the **body composition** card (or open **Progress / Measurements**).  
3. Tap **Scan InBody / body report** (`InBodyScanScreen`).  
4. Camera, gallery, or PDF → review numbers → confirm. Names/IDs are stripped from extracted text.

---

## Privacy notes for review

- **Cycle tracking is local-only.** It does not leave the phone unless the user later opts into a future sync (none in this build).  
- Account deletion: Settings → About → Delete account → edge function `delete-account` → sign out. Web steps: hosted `delete-account.html`.  
- Legal pages: Privacy / Terms links in Settings → About (base URL via `LEGAL_BASE_URL` dart-define).  
- No `ACCESS_BACKGROUND_LOCATION`. Location (if outdoor GPS flag is on) is while-in-use only.

---

## Test account

Use any email sign-in or guest mode. If a Play review login is required, the owner will provide credentials in the Console “App access” form (`docs/store/PLAY_CONSOLE_FORMS.md`).

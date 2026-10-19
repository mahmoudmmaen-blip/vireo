engine: agent
You are a senior engineer on the Vireo repo (branch ux-v2). Read AGENTS.md and docs/PRODUCT_DECISIONS.md first and follow them strictly. Only start if 'git log --oneline -8' shows the P36 commit 'feat(home+meals): calorie mascot wave, meal health score & swaps, plan/program fixes'; if it is missing, write .runner/done/004_BLOCKED.txt explaining why and stop without changing code. Do queue item 5 in docs/prompts/QUEUE_ORDER.md: the full spec below (also docs/prompts/P40_launch_growth_pack.md). Never push/reset/clean/checkout/delete. Finish with the 5-line report.

Act as a senior Flutter engineer + growth PM on Vireo (branch ux-v2). Start after P36 is committed. Read AGENTS.md first and follow it strictly. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push.

Source: owner-approved product review (Claude + Gemini Pro + Kimi K3, 2026-10-16). Decisions are in docs/PRODUCT_DECISIONS.md — implement them exactly.

## 1. FASTER LOGGING (the #1 gap vs MyFitnessPal / Lose It / Yazio)
- **Repeat meals:**
  - "زي امبارح" one-tap chip on each meal slot (copies yesterday's same slot);
  - "وجباتي" favorites (star any logged meal);
  - "آخر حاجات أكلتها" recents list.
  - All available from the Home meal card and the log sheet. Max 2 taps from Home.
- **Write or say your meal:** "اكتب أو قول أكلك" text box ("أكلت ربع فرخة ورز وطبق سلطة").
  - It goes through the SAME server pipeline as "عدّل النتيجة" (Step B DB resolution, no free kcal guessing).
  - Voice uses the Android system speech-to-text (speech_to_text plugin or a platform intent), locale ar-EG / ar-SA. No paid ASR.
  - Ask the microphone permission only when the user taps the mic.
- **Result screen calibration is the hero, not hidden:**
  - always-visible portion stepper (½ / 1 / 1½ / 2);
  - a 3-state oil chip "زيت: خفيف / عادي / مسبّك" (± values from our oil calibration);
  - the kcal shown as "≈ 650 سعرة" with a small "تقديري" label.
  - Corrections still feed personal calibration (P34).
- **Family plate:** toggle "أكلنا من طبق واحد" → "نصيبي: ربع / تلت / نص" (¼ / ⅓ / ½) for shared dishes (koshari, mahshi, kabsa, molokhia).

## 2. RAMADAN & FASTING, CULTURALLY NATIVE
- **Fasting timer can use prayer times:**
  - Iftar = Maghrib and Imsak = Fajr, computed OFFLINE with the `adhan` Dart package from a city the user picks (Cairo, Alexandria, Riyadh, Jeddah, Dammam, Dubai, Abu Dhabi, Kuwait, Doha, Manama, Muscat + "مدينة تانية" lat/long picker).
  - NO location permission.
  - Calculation method: Egypt = Egyptian General Authority; KSA = Umm al-Qura; Gulf = Umm al-Qura/Dubai.
- **Water tracker** integrated with fasting: during Ramadan, show "شربت كام كوباية من الإفطار للسحور؟" with a goal spread between iftar and suhoor. One water row only (P36 already collapsed reminders).
- **Ramadan free forever:** Ramadan mode, the fasting timer, barcode, the women's module are NEVER paywalled.

## 3. HOME-SCREEN WIDGET (Android)
- Use the home_widget package. The 2×2 widget shows calories left plus the mascot state emoji and the fasting countdown when active. Tapping it opens the camera log.
- Update on meal save and every 30 min max. Dark and light. RTL.

## 4. SHAREABLE WEEKLY CARD (organic growth)
- **Card:** a weekly 1080×1920 story card: "رصيد حرقك الأسبوع ده", the steps total, the mascot, the streak and the Vireo logo.
- **Rules:** no weight numbers unless the user turns them on. Offer it ONLY when the user hit a goal (never ask a struggling user to share).
- **Sharing:** use share_plus (WhatsApp/Instagram). The card is rendered locally (RepaintBoundary → PNG). No personal data in links.

## 5. MONETIZATION (code side only; prices are set by the owner in Play Console / RevenueCat)
- **Free AI photo scans: 3 per day.** In the first 7 days after install, the limit is 5 per day.
  - Enforce SERVER-SIDE in the analyze-meal edge function (per user per day, Supabase table), with the client showing the remaining scans.
  - Text/voice logging, barcode and manual search stay unlimited.
- **Pro:** unlimited scans with a hidden fair-use cap of 40 per day (server). Also includes the adaptive coach recovery plans, the AI coach chat, all scene packs and seasonal mascots, the advanced fasting plans, and no ads.
- **AI coach chat:**
  - Pro only. Free users get quick-action chips ("اقترح عشا بروتين عالي تحت 500 سعرة من اللي في التلاجة", "أعوض إمبارح إزاي؟").
  - Pro limit: 30 messages per day.
  - Strict system prompt: no diagnosis or medication, refuse plans under the safety floors, eating-disorder risk → supportive message + resources. Log nothing sensitive.
- **Paywall:**
  - (a) A soft paywall, dismissible with a visible X, at the end of onboarding RIGHT AFTER the user's first successful scan (the aha moment).
  - (b) A hard gate when the daily free scans run out (offer: "استنى لبكرة" or Pro).
  - The yearly plan is pre-selected and shows the calendar math (e.g., "أرخص من كوباية شاي في اليوم"). Monthly is the comparison. There is NO lifetime plan (owner decision) — remove any lifetime product/UI if it exists. One CTA. Trial terms in plain Arabic under the button.
  - Read the prices from RevenueCat offerings. Never hard-code prices.
- **Cancel/refund UX:** Settings → "اشتراكي" with an Arabic explanation and a deep link to Play subscriptions. No dark patterns.
- **API cost guard:**
  - compress images client-side to max 720 px / WebP before upload;
  - the image-hash cache (P32b);
  - a degraded mode: if the AI backend fails, manual/text logging still works offline.

## 6. CONTENT
- **"حقائق أكلك" cards:** 60 local myth-busting comparison cards (e.g., "طبق الكشري الكبير ≈ 3 ساعات مشي", "الطعمية في الإير فراير أقل بكتير من المقلية").
  - Every number must come from our DB plus the ACSM/MET formulas, computed at build time by a script (tool/content/facts_gen.dart). NO invented numbers.
  - Show one per day on Home under "المزيد", plus the same card as a shareable image.
- **Swap library:** expand to ≥100 local swaps, each with a saving computed from the DB.
- **Ramadan content block:** suhoor satiety ranking, an iftar pacing guide (تمر + مية → شوربة → استنى 15 دقيقة → الطبق الرئيسي), and a post-Ramadan rebound plan. All in Egyptian Arabic, gender-aware.
- **Seasonal mascot pack:** the camel with a Ramadan lantern scene (free during Ramadan), Eid, winter. Original art only.

## 7. NOTIFICATIONS (first 7 days + rules)
- **Rules:** max 2 per day; adaptive timing (learn the usual log times); quiet hours 11 PM–7 AM, except suhoor in Ramadan. In Ramadan, follow iftar/suhoor.
- **Permission:** ask for notification permission AFTER the first successful scan: "عايزني أفكرك بالوجبات؟".
- **Day 0–7 plan:**
  - D1 weight-log prompt;
  - D2 repeat-meal tip;
  - D3 first Burn Balance teaser;
  - D4 fasting intro (or Ramadan);
  - D5 first "بصمتك" insight;
  - D6 the share card (only if a goal was hit);
  - D7 the weekly summary.
- **Copy:** warm Egyptian, gender-aware ICU, never blame. Examples: "واخد بالك من نفسك؟ 😊 صوّر غداك — تانيتين بس", "إمبارح كان يوم تقيل شوية؟ مفيش مشكلة 💪 لو مشيت 20 دقيقة النهارده هنرجع للمسار".
- **Streaks are merciful:** one miss doesn't reset; use a "يوم راحة" token.

## 8. FOCUS: HIDE NON-CORE FOR v1 (feature flags, keep the code)
- **Hide** behind remote/local flags, default OFF for v1:
  - the GPS run screen (keep step-based walking energy);
  - the men's vitality / testosterone module (Play health-sensitivity risk).
- **Keep:** InBody/body (the owner wants it visible) and the women's module (local-only).
- **Onboarding:** ≤ 90 seconds: goal → weight/height → FIRST PHOTO SCAN → then account/permissions. Tap-cards, minimal typing.

## 9. PERFORMANCE ON LOW-END PHONES (Tecno/Infinix/Redmi, 3–4 GB RAM)
- **Release size:**
  - release AAB ≤ 35 MB per device split;
  - convert the background/scene images to WebP and lazy-load scene packs;
  - remove unused assets and fonts.
- **Speed:** cold start ≤ 1.5 s in profile mode on a mid emulator profile.
- Report the before/after sizes in the CHANGES doc.

## VERIFY & DELIVER
- Run `flutter gen-l10n` (10 locales) and `flutter analyze` (0 errors).
- Unit tests:
  - repeat-meal copy;
  - the plate-share math;
  - the free scan limit (server + client);
  - prayer-time fasting for Cairo and Riyadh (a known date);
  - the facts generator numbers;
  - notification caps;
  - the flags default.
- Audit tests at 360×640 ar_EG with textScale 1.3: the result screen, the paywall, the widget preview and the share card. Each with `--timeout 2m`, using pump(Duration).
- Redeploy analyze-meal (and any new function) with `npx supabase functions deploy <name> --use-api`. Check one real request in the logs.
- Run `flutter build apk --debug` and `flutter build appbundle --release` with the debug-signing fallback, to report the size. Poll until done.
- Write docs/P40_CHANGES.md, including what the OWNER must set: the RevenueCat products/prices from docs/PRODUCT_DECISIONS.md, and the Play subscriptions.
- `git add -A && git commit -m "feat(growth): repeat meals, text/voice log, prayer-time fasting, widget, share card, scan limits, paywall, content"`. Do not push.

Act as a senior Flutter + Supabase engineer and product designer on Vireo (branch ux-v2). Do this BEFORE P33. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push.

## 1. BUG: "وصلت للحد الأقصى" while the owner tests meal scans
Root causes found in supabase/functions/_shared/ai-usage.ts and analyze-meal/index.ts:
- **The free limit is 3 scans/day (anon 2), and the quota is consumed BEFORE analysis.** Failed scans (network, 502, empty or unsure-only results, timeouts, retries of the same photos) burn the quota.
- **`hasPremiumEntitlement` ignores the `pro_grants` table** (email-based grants for the owner and reviewers), so granted accounts are treated as free.

Fix:
- **Entitlements.** `hasPremiumEntitlement` must also check `pro_grants` by the user's JWT email (case-insensitive, expires_at null or in the future). Use the admin client for this.
- **Refund on failure.** Consume the quota only after a successful analysis with at least 1 confirmed item: either reserve-then-commit, or decrement the counter on failure. Retrying the same photos within 10 minutes must not count twice (hash of the image bytes).
- **Limits.** Free stays 3/day, plus +2 extra scans per rewarded ad, max 2 ads/day, using the existing rewarded-ad flow. Body-report scans have their own bucket (free 1/day).
- **Client UX.** Show "فاضلك X تحليلات النهارده" on the capture card for free users. When the limit is reached, show a friendly sheet with three options: (a) watch an ad for +2; (b) upgrade to Pro; (c) log manually / search the food DB, which is always free and unlimited. Never show a dead end.
- **Redeploy.** Run `npx supabase functions deploy analyze-meal --use-api`. Add the owner's email to pro_grants ONLY via the SQL documented in docs/RELEASE.md: write the SQL there, but do not run it against production yourself.
- **Tests:**
  - Deno or unit test: quota is refunded on failure;
  - pro_grants grants premium;
  - the Flutter limit sheet renders.

## 2. "اقترح وجبة" in Daily Score (Home card + Score & Insights)
Under the remaining-macros rectangles (باقي 113 جم بروتين، 239 جم كارب، 48 جم دهون، 1837 سعرة), add a **"اقتراح لوجبتك الجاية"** card:
- **Contents.** 2–3 meal suggestions that fit the REMAINING kcal and macros for the next meal slot (time of day; Ramadan slots if active). Prioritize the biggest gap (usually protein).
- **Source.** Build the suggestions from the bundled food DB (Egyptian/Arab foods + common restaurant meals), using the user's cuisine. Use a deterministic local algorithm, no AI call: a greedy/knapsack combination of 2–4 DB items, hitting the protein target within ±15% and kcal within ±10% of the per-meal budget. Prefer simple home foods (فراخ مشوية، تونة، بيض، زبادي يوناني، عدس، فول، جبنة قريش، رز، عيش بلدي، سلطة).
- **Display.** Each suggestion shows: a name, the total kcal/P/C/F, and each item in **household measures** (section 3), e.g. "صدر فراخ مشوي (قد كف إيدك) + 1 كوب رز + سلطة كبيرة".
- **Actions:**
  - "سجّلها" logs it in one tap (editable);
  - "اقتراح تاني" gives the next combination;
  - "♡" saves it to favourites.
- **Edge cases.** If the remaining kcal < 150, suggest a light protein snack only. If the user is over target, show "خلّي الوجبة الجاية خفيفة" with ≤ 300 kcal options. If the user is in pregnancy mode or under 18, never suggest a deficit.
- **Code.** Put the logic in lib/features/insights/domain/meal_suggester.dart (pure Dart), with unit tests: protein-gap, low-remaining, over-target, Ramadan slot, and determinism.

## 3. HOUSEHOLD MEASURES (no kitchen scale needed)
A **"مقاييس البيت"** system everywhere portions appear: the meal review editor, manual log, suggestions, and the barcode result.
- **Units with gram equivalents per food type:**
  - كوب (240 ml): cooked rice ≈ 160 g; cooked pasta ≈ 140 g; milk 245 g; cooked beans ≈ 170 g;
  - نص كوب
  - ملعقة كبيرة / ملعقة صغيرة: oil 13.5 g / 4.5 g; tahini ≈ 15 g; sugar 12.5 g / 4 g; honey 21 g;
  - كف اليد (palm): meat/chicken/fish ≈ 100–120 g cooked;
  - قبضة اليد (fist): ≈ 1 cup of carbs or fruit;
  - حفنة (cupped hand): nuts ≈ 28 g; لب ≈ 30 g;
  - إبهام (thumb): fats/butter/peanut butter ≈ 1 tbsp;
  - رغيف بلدي ≈ 90–100 g; نص رغيف;
  - طبق كشري صغير/وسط/كبير;
  - قطعة/حبة where it makes sense (egg 50 g, طعمية 30 g, date 8 g).
- **Data.** Store them in the food DB per food as `household_units: [{unit_id, grams}]`, with category defaults when a food lacks its own. Extend foods.json and the unit table in the meal review (from P27); don't duplicate it.
- **Picker UI.** Tap the portion, then choose a unit chip (illustrated icons: cup, spoon, palm, fist, cupped hand, thumb) and a quantity stepper (¼, ½, 1, 1½, 2…). Show grams as secondary text ("≈ 160 جم").
- **Calibration** (Settings → "مقاييس بيتك"): the user can set "كوبايتي" size (small 200 / standard 240 / large 300 ml) and their plate size. One-time tip with a simple illustration of the hand-portion guide.
- **Unit tests:** unit→grams conversion per category, custom cup size, and fraction steps.

## 4. VERIFY & DELIVER
- Run `flutter gen-l10n` (10 locales, Egyptian in ar_EG) and `flutter analyze` (0 errors).
- Run the new tests plus test/audit (the Home score card with the suggestion card, the portion picker, and the limit sheet at 360×640 ar_EG with textScale 1.3), each with `--timeout 2m`, using pump(Duration).
- Redeploy analyze-meal and confirm in the logs that a failed request does not consume quota.
- Run `flutter build apk --debug`. Poll until done.
- Write docs/P32b_CHANGES.md.
- `git add -A && git commit -m "feat(meals): fair scan quota + pro_grants, next-meal suggestions, household measures"`. Do not push.

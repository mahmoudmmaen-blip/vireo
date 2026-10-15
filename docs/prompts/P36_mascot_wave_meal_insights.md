Act as a senior Flutter engineer and product/motion designer on Vireo (branch ux-v2). Start after "feat(accuracy): round 2" is committed. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push.

## 1. CALORIE MASCOT WITH LIQUID WAVE ("رفيقك")
- **An ORIGINAL cute mascot** (no copying of any known character such as Kung Fu Panda or the WWF panda; no brand look-alikes). Make 4 selectable companions, all drawn by us with CustomPainter or Rive vector:
  - باندا
  - قطة
  - جمل صغير (Egyptian touch)
  - بومة

  Use simple rounded shapes and a flat style that matches the VireoColors tokens of the active theme.
- **The mascot body is a container filled with an animated liquid wave.** The fill level = consumed kcal / target. Use 2 layered sine waves with a slight phase offset and a gentle bob (1.5–2 s loop).
- **Optional macro layers** (setting): protein, carbs and fat as 3 stacked liquid bands in their pillar colors.
- **Color states.** Under 85% of target is calm (theme accent). 85–105% is a green "تمام". Over 105% is a soft amber "زيادة شوية". Never alarming red.
- **Expressions by state:**
  - hungry/empty in the morning;
  - happy when on track;
  - satisfied at 90–105%;
  - "full" puffed cheeks when over;
  - sleepy after 11 PM.

  Show a short Egyptian line under it ("فاضلك 1,250 سعرة — كُل براحتك") with ICU gender select.
- **Placement and behavior:**
  - Use it as the hero of the Daily Score card on Home (replacing the plain ring, with a toggle "الدايرة العادية" in Settings → المظهر) and on the meal-saved confirmation (animate the wave rising from old to new level, 900 ms).
  - Tapping the mascot opens Score & Insights.
  - Long-press is the quick "سجّل وجبة".
- **Performance and accessibility.** Use RepaintBoundary. The animation pauses when the widget is off-screen or the app is in background. Respect reduce motion (static fill). Add a semantics label with the numbers. Zero overflow at 360×640 ar_EG with textScale 1.3.
- **Tests:** the fill-level math (0, 50%, 100%, 140% clamped visual with an "over" badge), the state→expression mapping, the night state, and the off-screen pause.

## 2. MEAL RESULT UPGRADES (learned from competitor review)
- **Meal health score 1–10** with a short reason. Base it on protein density, fiber, added sugar, sodium, fried/oil and veg share. It must be deterministic from our nutrients (not an AI guess). Unit-test it.
- **Micro chips** under macros: sodium, sugar, fiber (from DB values; "تقدير" if missing).
- **One smart, specific swap tip** from rules, e.g. "شيل جلد الفراخ ← توفر ≈ 100 سعرة و8 جم دهون" or "نص الرز بدل كوبايتين ← توفر 200 سعرة". Compute the saving from our DB numbers.
- **"عدّل النتيجة" free-text correction:** the user types "ده سلمون مش فراخ، 150 جم". The server re-resolves through the same Step B pipeline (no new kcal guessing), and the correction feeds personal calibration (P34).
- **The meal name must be Arabic** when the app language is Arabic (the current results show English names like "Roasted Chicken With Rice"). Keep the English name only as a secondary line.
- **Stability:** the same photo re-analyzed must return the same result. Use the image-hash cache from P32b and return the cached result within 24 h unless the user taps "حلّل تاني".

## 3. FIXES FOUND IN THE OWNER'S SCREENSHOTS (2026-10-14)
1. **Today Plan clutter.** 13 separate "تذكير ماء X من 13" rows flood the timeline. Collapse them into ONE water row with progress (e.g., "مياه 0.5 من 3.25 لتر") that expands on tap. Reminders still fire as notifications.
2. **English or broken strings in Arabic UI:**
   - "Quality sleep", "Morning light", "Hit protein";
   - broken "teinالبرو";
   - "Vitality +7.5" and "بروتوكول Vitality";
   - "(الخصر) Log more entries to see trends".

   Localize all of them (10 locales) and add a test that fails if an ar_EG screen renders Latin words except brand names (Vireo, InBody, Pro).
3. **Diet programs list.** Every program shows the same "2230 سعرة · 131 جم بروتين" and the same "72 جرام دهون/يوم ≈ 510/أسبوع". Each program must compute its own targets from the user profile and program rules (low-carb, keto, high-protein, IF, Egyptian clean). The fat-loss line must come from that program's real deficit.
4. **Target mismatch.** The score card shows a goal of 2,786 kcal while the programs show 2,230. Use one source of truth for the active target, and show which program/plan set it.
5. **Progress tab theme mismatch.** It uses a green accent and a green "+" button while the other tabs are orange. All tabs must use the active theme tokens.

## 3b. HOME ORDER (owner request 2026-10-15)
The "المزيد والتحليلات" calories card (remaining kcal ring + P/C/F bars + الهدف/أكلت/حرقت) sits too low, below the ad. New Home order:
1. Ramadan card (when active)
2. Steps hero card
3. Meal capture card
4. **Calories card**, renamed "سعراتك النهارده". In P36 it becomes the mascot wave card (section 1), so it must NOT duplicate the Daily Score's remaining-macros rectangles. Show the mascot + remaining kcal + P/C/F here, and keep the Daily Score focused on the score, tips and next-meal suggestion.
5. Daily Score card
6. Weekly check-in banner (حان وقت التقييم الأسبوعي), only when due
7. Pillars grid / today plan
8. The rest ("اختار خطتك الغذائية", "النشاط والصحة"…) under a "المزيد" header
9. Ad slot: never between items 1–6; first ad at earliest after item 7.
- Update the audit test for the new order. Use one source of truth for the target (the card currently shows 2,157 while the programs show 2,230; see section 3.4).

## 4. VERIFY & DELIVER
- Run `flutter gen-l10n` (10 locales) and `flutter analyze` (0 errors).
- Run the unit tests and the audit tests: Home with the mascot in 4 themes, the meal result, Today Plan with water collapsed, and the programs list. All at 360×640 ar_EG with textScale 1.3, each with `--timeout 2m`, using pump(Duration).
- Redeploy analyze-meal if changed.
- Run `flutter build apk --debug`. Poll until done.
- Write docs/P36_CHANGES.md.
- `git add -A && git commit -m "feat(home+meals): calorie mascot wave, meal health score & swaps, plan/program fixes"`. Do not push.

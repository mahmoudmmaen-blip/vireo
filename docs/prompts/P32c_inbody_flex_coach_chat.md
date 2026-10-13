Act as a senior Flutter + Supabase engineer and product designer on Vireo (branch ux-v2). Do this right after P32b and BEFORE P33. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push.

Reference fixture: docs/refs/inbody_receipt_ar.jpg is a REAL photo of an Arabic InBody thermal receipt, held in a hand at an angle (ID number redacted). Use it as the golden test case.

## 1. INBODY SCAN = FLEXIBLE "ANY BODY REPORT" READER
- **Home.** Add an "تحليل الجسم" card on Home (below the score card). Show the latest body fat %, muscle mass, visceral fat and the trend arrow, plus a primary button "صوّر تقرير InBody" and a secondary button "قيس بالشريط". When there is no data, show an inviting empty state: "عندك InBody؟ صوّره وإحنا نظبط خطتك عليه".
- **Inputs the reader must handle,** all through the body_report mode of analyze-meal (server key only):
  - InBody thermal receipts (Arabic or English), A4 result sheets, and the InBody app screenshots;
  - other brands: Tanita, Omron, Xiaomi/Huawei/Renpho scale app screenshots;
  - a handwritten note, or a screenshot of a chat with a coach.
  - Photos may be curved, angled, partially shadowed, or held in a hand.

  Allow up to 3 photos per report (long receipts) and merge them.
- **Fields to extract** (all optional, each with its own confidence):
  - date, height, age, sex, weight;
  - skeletal muscle mass; body fat mass; PBF %; BMI; BMR; waist-hip ratio; visceral fat level;
  - segmental lean (RA, LA, trunk, RL, LL: kg and %); segmental fat (kg and %);
  - InBody score; fat control; muscle control; phase angle; total body water; protein; minerals.
- **Never store ID numbers or names.** Strip them server-side.
- **Confirmation screen:** an editable form grouped into Basics / Composition / Segmental / Advanced. Low-confidence fields are highlighted in amber with "اتأكد من الرقم ده". Include a "ضيف قيمة يدوي" option. Then save it with a source chip "InBody" (or the detected brand).
- **Golden test (must pass).** Expected values from docs/refs/inbody_receipt_ar.jpg:
  - date 2026-09-22; height 180; age 32; male; weight 94.7;
  - SMM 37.4; fat mass 28.6; PBF 30.2; BMI 29.2; BMR 1797; WHR 0.96; visceral 12;
  - segmental lean: 3.65 / 3.66 / 28.6 / 10.50 / 10.38;
  - segmental fat: 2.0 / 2.1 / 15.2 / 4.0 / 4.0;
  - InBody score 69; fat control −17.0; muscle control 0.0; phase angle 5.9.

  Write an integration script (tool/inbody_golden/) that calls the deployed function with this image and asserts that ≥ 90% of the fields match within tolerance. Report the score in docs/P32c_CHANGES.md. Unit-test the parser and merger with a recorded JSON response so CI does not call the network.
- **Insights from the report** (shown after saving, in plain Egyptian Arabic):
  - "الدهون 30.2% (الطبيعي 10–20%) → هدفك تخسر ≈ 17 كجم دهون مع الحفاظ على العضل";
  - visceral fat 12 (> 9) → a gentle health note;
  - segmental balance (left vs right);
  - phase angle meaning (general, non-medical).
- **Plan recompute** uses the P32 source priority. BMR comes from the report; protein uses g/kg of lean mass; the goal comes from fat control. Show the one-time "حدّثنا خطتك بناءً على InBody" card with before→after numbers.

## 2. ONBOARDING SHORTCUT: "عندك InBody؟"
- Add a first-class choice early in onboarding (after the language/goal step): **"عندي تقرير InBody — وفّر الأسئلة"** vs **"كمّل عادي"**.
- If the user picks InBody: open the reader, then auto-fill height, weight, age, sex, body fat, muscle and BMR, and SKIP those onboarding questions. Ask only what the report can't give (activity level, goal, diet preferences).
- Show "وفّرنا عليك X أسئلة ✓".
- If the scan fails, fall back gracefully to the normal questions with the extracted values pre-filled.

## 3. COACH CHAT THAT CAN CHANGE THE PLAN ("اسأل كوتش Vireo")
- Reuse or upgrade the existing coach chat (coach_chat quota already exists). It should be reachable from Home (a floating chat chip), the score screen ("ناقش الاقتراح ده"), meal suggestions, and the InBody insights.
- **Context sent to the model** (server-side, privacy-minimal): profile, targets, today's totals, the last 7 days' summary, the latest body report, active plan items and fasting/Ramadan state. Never send cycle data unless the user enabled sync and the topic needs it.
- **Behavior.** It discusses suggestions in Egyptian Arabic and gives short answers with options. When the user and the coach agree on a change, the model returns a structured **plan action**: change kcal/protein target, swap a meal suggestion, add a workout to the plan, change the step goal, set a fasting plan, add a reminder.
- **The app shows an "إضافة للخطة" confirmation card** with before→after. Nothing changes without the user's tap. Every change can be undone ("تراجع") from Plan history.
- **Safety rails:**
  - no medical diagnosis;
  - no kcal targets below a safe floor (women 1200, men 1500; none in pregnancy or under 18);
  - weight-loss rate capped at ≤ 1% per week;
  - refer to a doctor for red-flag symptoms;
  - refuse extreme fasting/diets.
- **UI:** a clean chat with quick-reply chips ("اقترح عشا", "ليه السعرات دي؟", "عدّل خطتي", "فسّرلي InBody"), voice input (existing speech_to_text), and a typing indicator. Free users get the existing daily coach limit plus a rewarded ad for +5 messages; Pro is generous.
- **Tests:** a plan-action JSON parser; safety floor clamps; "no change without confirm"; undo.

## 4. VERIFY & DELIVER
- Run `flutter gen-l10n` (10 locales, ar_EG Egyptian) and `flutter analyze` (0 errors).
- Run the new tests plus test/audit (Home with the body card, the report confirm form, the onboarding InBody path, and the chat at 360×640 ar_EG with textScale 1.3), each with `--timeout 2m`, using pump(Duration).
- Redeploy the edge functions and run the InBody golden script, recording its score.
- Run `flutter build apk --debug`. Poll until done.
- Write docs/P32c_CHANGES.md.
- `git add -A && git commit -m "feat(body+coach): flexible InBody reader, onboarding shortcut, plan-aware coach chat"`. Do not push.

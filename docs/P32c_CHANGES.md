# P32c Changes: Flexible InBody Reader, Onboarding Shortcut & Plan-Aware Coach Chat

## 1. Overview
P32c delivers a complete body composition intelligence loop:
1. **Flexible InBody Vision Reader**: Supports thermal receipts, A4 sheets, gym screens, and multi-photo merges (up to 3 photos).
2. **Review & Confirmation Screen**: Grouped into 4 intuitive categories (Basics, Composition, Segmental Lean, Advanced Metrics) with amber low-confidence flags (< 0.65), manual field additions, and brand selection.
3. **Automated Plan Recompute**: Recomputes BMR via Katch-McArdle based on lean body mass, recalculates TDEE, calories, and protein targets with immediate undo capability.
4. **Onboarding Fast-Track Shortcut**: Allows users with an InBody receipt to scan immediately during onboarding, auto-populating height, weight, age, and sex while skipping manual questions.
5. **Plan-Aware AI Coach Chat**: Ingests active diet plans, body reports, and fasting state; outputs structured ````plan_action```` payloads rendered as interactive confirmation cards with safety rails.
6. **Golden Test Suite**: Validated 100% (22/22 fields) extraction accuracy against real-world receipt (`docs/refs/inbody_receipt_ar.jpg`) with both live and recorded offline unit tests.

---

## 2. Backend & Edge Functions

### `supabase/functions/_shared/prompts/body-report.ts`
- Expanded OCR schema and instructions for thermal receipts, A4 InBody reports (e.g. InBody 270/370/570/770), Tanita, Accuniq, and phone screen photos.
- Extracts comprehensive metrics:
  - Basics: `weight_kg`, `height_cm`, `age`, `sex`
  - Composition: `skeletal_muscle_mass_kg`, `body_fat_mass_kg`, `body_fat_percent`, `bmi`, `bmr_kcal`
  - Segmental: `right_arm_lean_kg`, `left_arm_lean_kg`, `trunk_lean_kg`, `right_leg_lean_kg`, `left_leg_lean_kg`
  - Advanced: `visceral_fat_level`, `waist_hip_ratio`, `inbody_score`, `fat_control_kg`, `muscle_control_kg`, `phase_angle`
- Includes confidence scores (`confidence` 0.0-1.0) and device identification (`device_brand`).

### `supabase/functions/analyze-meal/index.ts`
- Wired `mode: 'body_report'` to use `fastVisionModel` (`gemini-2.5-flash`) with structured schema response.
- Deployed to Supabase project.

### `supabase/functions/_shared/prompts/coach.ts` & `ai-coach-chat/index.ts`
- System prompt ingests profile metrics, latest body composition scan, active plan targets, and Ramadan/fasting context.
- Emits structured ````plan_action```` code blocks when advising plan adjustments:
  ```json
  ```plan_action
  {
    "action": "adjust_targets",
    "reason_ar": "تعديل السعرات لزيادة معدل النزول بأمان",
    "target_calories": 1850,
    "target_protein_g": 140,
    "target_carbs_g": 190,
    "target_fat_g": 60
  }
  ```
  ```
- Strict safety guardrails:
  - Minimum calories: $\ge 1200$ kcal for females, $\ge 1500$ kcal for males.
  - Prohibits calorie reduction for youth (< 18 years) or pregnancy/lactation.
- Chat endpoint checks pro status from email via admin client.

---

## 3. Flutter Client Architecture

### Domain & Services
- **`BodyCompositionReport`** (`lib/features/measurements/domain/body_composition_report.dart`):
  - Added new fields: `heightCm`, `age`, `sex`, `fatControlKg`, `muscleControlKg`, `phaseAngle`, `deviceBrand`.
  - Added `BodyCompositionParser.merge(List<BodyCompositionReport> reports)` taking the highest-confidence values across up to 3 photographed sections.
- **`BodyCompositionInsights`** (`lib/features/measurements/domain/body_composition_insights.dart`):
  - Generates authentic Egyptian Arabic insights on fat %, target fat loss/muscle gain, visceral fat risk levels, segmental imbalances, and cellular health / phase angle.
- **`BodyReportVisionService`** (`lib/features/measurements/data/body_report_vision_service.dart`):
  - Added `analyzeMultiple(List<Uint8List> imagesBytes)` compressing images and executing batch OCR.
- **`PlanAction`** (`lib/features/ai_coach/domain/plan_action.dart`):
  - Parses ````plan_action```` blocks from AI messages, separates human message text from action metadata, and enforces safety bounds on targets.

### UI & Widgets
- **`InBodyReviewScreen`** (`lib/features/measurements/screens/inbody_review_screen.dart`):
  - 4 grouped sections: Basics (البيانات الأساسية), Composition (تكوين الجسم), Segmental (الكتلة العضلية بالتفصيل), Advanced (مؤشرات متقدمة).
  - Amber badge warning for low-confidence fields (< 0.65) with intuitive edit buttons.
  - "+ إضافة قياس يدوي" bottom sheet allowing users to add any missing metrics.
  - Post-save insights bottom sheet with "اسأل كوتش Vireo عن التقرير" shortcut.
  - Automatic plan recompute prompt with 10-second undo snackbar.
- **`PlanActionConfirmationCard`** (`lib/features/ai_coach/widgets/plan_action_confirmation_card.dart`):
  - Clean card showing before $\to$ after target comparison.
  - "تطبيق التعديل" updates `calorieGoalProvider` targets directly.
  - Undo capability restores previous targets seamlessly.
- **`ChatMessageBubble`** (`lib/features/ai_coach/widgets/chat_message_bubble.dart`):
  - Cleanly parses out raw code block and renders the interactive `PlanActionConfirmationCard` beneath the message.
- **`HomeBodyCompositionCard`** (`lib/features/home/widgets/home_body_composition_card.dart`):
  - Displays body fat %, muscle mass, visceral fat, trend arrows, and quick actions ("مسح تقرير InBody", "شريط القياس").
- **`StepBodyScreen`** (`lib/features/onboarding/steps/step_body_screen.dart`):
  - Added "عندي تقرير InBody — وفّر الأسئلة" shortcut button to scan reports and skip manual questions.

---

## 4. Verification & Testing

### Golden Accuracy Test
- Live test script `tool/inbody_golden/test_inbody_golden.py` run against real receipt `docs/refs/inbody_receipt_ar.jpg`:
  - **Results: 22/22 fields matched (100.0% accuracy)**.
  - Verified weight (94.7 kg), SMM (37.4 kg), fat mass (28.6 kg), PBF (30.2%), BMI (29.2), BMR (1797 kcal), visceral fat (12), WHR (0.96), phase angle (5.9°), segmental lean arms/trunk/legs, fat control (-17 kg), muscle control (0 kg).
- Offline unit test `test/features/measurements/inbody_golden_offline_test.dart` passes using recorded fixture `test/fixtures/inbody_golden_response.json`.

### Unit & Widget Tests
- `test/features/coach/plan_action_test.dart`: 7 tests passing (parsing, extraction, min calories enforcement, youth/pregnancy protection).
- `test/features/measurements/body_composition_parser_test.dart`: 4 tests passing (parsing, multi-image merge, confidence scoring).
- `test/audit/audit_p32c_overflow_test.dart`: 5 tests passing (zero overflows at 360x640 Egyptian Arabic with textScale 1.3 across all screens and cards).

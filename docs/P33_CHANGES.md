# P33 Changes: Sex-Aware Modules, Themes, Onboarding Polish & Engagement Journey

## 1. Sex-Aware Experience (Men & Women)
- **User Sex Detection & Persistence**:
  - Added `UserSexNotifier`, `userSexProvider`, and `isFemaleUserProvider` (`lib/core/services/user_sex_provider.dart`), reading from Hive settings and guest profile cache.
  - Egyptian Arabic gender-aware copy across the app: dynamically switches between "بطل" and "بطلة", e.g., in notifications, streak chips, workout finish celebrations, water completion, and protein badges.
- **Men's Health & Vitality Module (`صحة الرجل`)**:
  - `MenVitalityHeroCard` on Home dashboard and insights.
  - Weekly Vitality Score (0–100) based on sleep (7–9h), resistance training (3×/week), sunlight (15m), zinc & vitamin D food sources, protein targets, and smoke/alcohol-free days.
  - Non-medical coaching tone with disclaimer ("إرشادات عادات عامة").
- **Women's Health Module (`صحتك`)**:
  - `WomenHealthHeroCard` and full interactive `WomenHealthScreen`.
  - Privacy: All cycle and symptom data stored strictly locally in encrypted on-device storage (Hive). One-tap permanent data deletion ("امسحي بيانات الدورة").
  - Phase tracking & predictions: Menstrual, Follicular, Ovulatory, and Luteal phases.
  - Phase-aware guidance: Softer calorie messaging for luteal phase appetite increases (+100–300 kcal), scale water retention reassurance, menstrual light workout suggestions, and iron/calcium/folate food suggestions.
  - Pregnancy & Breastfeeding mode: Disables calorie deficit across the nutrition engine. Breastfeeding adds +350 kcal surplus. Pregnancy supports trimesters (+0 / +340 / +450 kcal).
- **Google Play Data Safety**:
  - Updated `docs/RELEASE.md` with Play Data-safety disclosure confirming menstrual/cycle data is stored locally only, never shared or synced without explicit opt-in, and can be cleared by the user anytime.

## 2. Multi-Theme System (Settings → المظهر)
- 4 comprehensive themes built on `VireoColors` with dark and light variants:
  1. **Ember** (vibrant orange; default for men).
  2. **Calm Gold** (deep charcoal + warm gold/olive accents with white pill buttons; default for women).
  3. **Ocean** (deep oceanic navy + electric teal).
  4. **Rose** (refined deep plum + rose).
- Theme selection persisted in Hive and reflected dynamically throughout the app.
- Tokenized cards: replaced hardcoded hex values in `MealCaptureHeroCard` and `PremiumStepsHeroCard` with `vireoColors` tokens.

## 3. Onboarding Polish
- Added `"ليه بنسأل؟"` info boxes under key onboarding steps (`WhyWeAskBox`).
- Upgraded height/weight selection with tactile haptic ticks (`HapticFeedback.selectionClick()`).
- Added `"عايز تركز على إيه؟"` goal focus chips (multi-select, max 3) in `StepGoalScreen`.

## 4. Engagement: Daily Journey & Coins
- "Today Plan" rebranded as **"رحلة اليوم"** with numbered sequence badges and points:
  - Meal logging: +10 pts
  - Walk goal: +25 pts
  - Water: +5 pts
  - Workout: +25 pts
  - Weigh-in: +5 pts
  - Mood check: +5 pts
- Anti-abuse: Points awarded once per day per task, enforced in `CoinsService`.
- Coin balance shown in Home header via `CoinsHeaderPill`.
- 500 coins unlocks 1 day of Vireo Pro via local grant (`FeatureGates.grantCoinsProDay`).

## 5. Paywall Clarity
- Added clear "التجربة المجانية تشمل / لا تشمل" section on the paywall screen.
- Explicitly states trial length, renewal price in local currency, and "تقدر تلغي في أي وقت" policy.

## 6. Verification
- `flutter gen-l10n`: generated successfully.
- `flutter analyze`: 0 errors, 0 warnings.
- Unit tests (`test/features/personal/p33_unit_test.dart`): 10 passing tests covering cycle prediction, calorie adjustment, luteal messages, coin anti-abuse, and theme switching.
- Overflow audit tests (`test/audit/audit_p33_overflow_test.dart`): 8 passing tests verifying 360×640 `ar_EG` textScale 1.3 across all screens and widgets.

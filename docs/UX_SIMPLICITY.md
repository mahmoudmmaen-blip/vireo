# Vireo UX Simplicity Pass (P25)

## 1. Overview & Core Philosophy
The core objective of the P25 simplicity pass is to make Vireo feel effortless and uncluttered for both first-time and daily users while preserving every advanced capability.

Key design principles enforced:
1. **One Screen = One Main Job + One Primary Button**: Secondary actions are tucked into "المزيد" or bottom sheets.
2. **Progressive Disclosure**: Only core essentials are visible up front; rich historical charts and secondary tools expand on tap.
3. **Max 5 Cards Above the Fold on Home**:
   - **Card 1**: Daily Score + Steps hero (`DailyScoreHeroCard`)
   - **Card 2**: "الخطوة الجاية" — Contextual Smart Next Action (`SmartNextActionCard`)
   - **Card 3**: Today Plan (collapsed to next 3 actionable items + "عرض الكل") (`TodayPlanSection`)
   - **Card 4**: Hydration quick card with 1-tap add (`QuickWaterCard`)
   - **Card 5**: Native Ad slot for free users (`VireoNativeAdCard`)
4. **The Three Pillars Navigation (Home / Food / + / Walk / Workouts)**:
   - Direct access to the 3 main daily fitness pillars from the bottom navigation bar:
     - **Home** (Tab 0)
     - **Food / Nutrition** (Tab 1)
     - **+** (Quick log / Scan sheet)
     - **Walk** (`WalkingTrackerScreen`, Tab 2)
     - **Workouts** (`WorkoutScreen`, Tab 3)
   - Secondary destinations (Progress, Profile, Diary) remain accessible via profile header, deep links, and notifications.
5. **Progressive Feature Unlocking**:
   - Days 1–2: Users experience core essentials (Home, Meal Scan, Water, Steps, Workout player).
   - Day 3+: Community social feed, body composition, Vitality Protocol, and specialized diet programs progressively unlock with a "جديد" badge.
   - Any user can bypass and unlock all features immediately via **Settings → كل المميزات فوراً**.

---

## 2. Before vs. After Tap Count Benchmarks

| Key Task | Previous Tap Count | New Tap Count | Optimization Details |
| :--- | :---: | :---: | :--- |
| **Log Water (+250 ml)** | **2–3 taps** (Open Water screen/modal $\to$ select cup $\to$ confirm) | **1 tap** | `QuickWaterCard` on Home features a direct `+250 ml` tonal button with haptic feedback. |
| **Log Meal Photo (AI Scan)** | **3 taps** (Open menu $\to$ camera $\to$ capture) | **2 taps** | Tap Smart Next Action / Fab $\to$ opens camera preview $\to$ snap. |
| **Start Today's Workout** | **3 taps** (Workout tab $\to$ select session $\to$ start) | **1 tap** | Direct "ابدأ التمرين" button on "الخطوة الجاية" card launches `WorkoutFlowScreen` immediately. |
| **Check / Complete Plan Item** | **2 taps** (Tap item $\to$ confirm sheet) | **1 tap** | Direct checkbox tap toggles task status with haptic impact. |
| **Track Walking / Step Activity** | **2 taps** (Health hub $\to$ Walking tracker) | **1 tap** | Dedicated "Walk" (المشي) tab on the primary bottom bar + 1-tap chip on Daily Score hero. |

---

## 3. Moved, Simplified, and Progressively Disclosed Elements

### Home Dashboard:
- **Moved to Day 3+ / "المزيد والتحليلات" section**:
  - `TodayHeroCard` (macro nutrition breakdown rings)
  - `ChooseDietPlanCard` (secondary diet programs picker)
  - `FastingWindowCard` (intermittent fasting tracker)
  - `HealthHubScreen` entry card
  - `WeeklyCheckInScreen` banner
  - `_WeekStrip` (weekly consistency day indicators)
  - `_RecoveryCard` (vitality recovery score)
  - `_TodayLog` (detailed food item list)
- **Merged / Unified**:
  - Daily Score ring and Live Steps progress merged into `DailyScoreHeroCard`.
  - Next task evaluation unified into `SmartNextActionCard` (protein deficit $\to$ workout due $\to$ water $\to$ steps).

### Settings Reorganization:
Settings previously presented a long ungrouped list of switches and radio tiles. It is now organized into exactly 5 logical, card-wrapped sections:
1. **الحساب (Account)**: Authentication state, email, logout, and safe account deletion.
2. **الأهداف والتفضيلات (Goals & Preferences)**: Cuisine preference, and "كل المميزات فوراً" instant unlock switch.
3. **التنبيهات (Notifications)**: Meal times, hydration, and workout reminders.
4. **الخصوصية والشروط (Privacy & Legal)**: UMP consent options (EEA/UK), terms of use, privacy policy, and medical disclaimer.
5. **الاشتراك (Subscription)**: Pro status, paywall, and subscription management.
*(Appearance settings are neatly tucked into an expandable card; developer debug options only appear in `kDebugMode`).*

---

## 4. Verification & Quality Assurance
- **Localization**: Full 10-locale compatibility maintained (`flutter gen-l10n`).
- **Static Analysis**: `flutter analyze` reports **0 errors**.
- **Build Quality**: Verified with debug APK compilation (`flutter build apk --debug`).

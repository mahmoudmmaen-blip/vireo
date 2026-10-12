# P29 Feature Implementation: Ramadan Mode 🌙 & Egyptian/Arab Food Database 🇪🇬

**Branch:** `ux-v2`  
**Date:** 2026-10-13  
**Status:** Complete & Verified  

---

## 1. Feature Overview

### 1.1 Ramadan Mode 🌙
- **Hijri Detection & Auto-suggestion**: Uses `hijri: ^3.0.1` (`HijriCalendar.now().hMonth == 9`) to detect the holy month of Ramadan and suggest activating Ramadan mode.
- **Offline Prayer Times via `adhan: ^2.0.0+1`**:
  - Offline astronomical computation without network dependencies.
  - Supports selectable calculation methods: **Egyptian General Authority of Survey (الهيئة المصرية العامة للمساحة)** (default), Umm Al-Qura (Makkah), Muslim World League (Madinah), Dubai, Kuwait, and Qatar.
  - Persisted in Hive settings (`ramadan_settings`).
- **Home Countdown Card**:
  - Live countdown widget (`RamadanCountdownCard`) positioned in Home dashboard.
  - Shows "إفطار بعد ⏳ HH:MM" during fasting hours (between Fajr and Maghrib) and countdown to Suhoor end during non-fasting night hours.
  - Displays prayer times for Suhoor/Fajr and Iftar/Maghrib, selected city name, and status badges.
- **Nutrition & Meal Slots Adaptation**:
  - Meal slots dynamically switch from standard 4 meals (Breakfast, Lunch, Dinner, Snack) to 3 Ramadan slots: **سحور (Suhoor)** / **فطار (Iftar)** / **سناك بعد الفطار (Post-Iftar Snack)**.
  - Target macros and calories split accordingly:
    - Suhoor: ~35% kcal, ~35% protein.
    - Iftar: ~45% kcal, ~40% protein.
    - Post-Iftar Snack: ~20% kcal, ~25% protein.
- **Hydration & Water Distribution**:
  - Daily water requirement distributed across non-fasting hours:
    - 25% at Iftar (e.g. 2 cups / 500 ml).
    - 50% throughout the evening (e.g. 4 cups / 1000 ml).
    - 25% at Suhoor (e.g. 2 cups / 500 ml).
- **Ad & Notification Fasting Suppression**:
  - `AdService.canShowInterstitial` suppresses interstitial ads during fasting hours.
  - Reminder scheduler suppresses food and water notifications that fall between Fajr and Maghrib.
- **Evidence-Based Workout & Plan Adjustments**:
  - Today Plan adjusts timeline to highlight Pre-Iftar light walk (30 min before Maghrib) and Post-Iftar workout (60–90 min after Iftar with adequate hydration).
  - Ramadan meal plan tips suggest Egyptian dishes (شوربة عدس، فول، سلطة، فراخ مشوية، قطايف باعتدال) with honest calories.

---

### 1.2 Egyptian Food Database + Restaurants 🇪🇬
- **Expanded Bundled Dataset (`assets/food_db/foods.json`)**:
  - Database expanded to **439 items** (well above the ≥ 400 requirement).
  - Authentic Egyptian staples: فول مدمس، طعمية، بيض، جبنة قريش/رومي/بيضاء، عيش بلدي/شامي/فينو، بليلة، كشري، محشي، ملوخية، بامية، مسقعة، فتة، رز بالشعرية، مكرونة بشاميل، كفتة، حواوشي، شاورما، إلخ.
  - Traditional desserts & drinks: بسبوسة، كنافة، قطايف، أرز باللبن، مهلبية، شاي بسكر، قهوة تركي، عصير قصب، سوبيا، كركديه، إلخ.
  - Gulf/Levant classics: كبسة، مندي، حمص، فلافل، تبولة، إلخ.
  - Restaurant chains (labeled "تقديري" / "Approx."): مؤمن، الطازج، أبو طارق، التابعي، كوك دوور، KFC، ماكدونالدز، البيك، هرفي.
- **Arabic Normalization & Search Repository**:
  - Full Arabic diacritics stripping (tashkeel `\u064B-\u065F`).
  - Alef normalization (`[أإآٱ] -> ا`).
  - Taa Marbuta normalization (`[ة] -> ه`).
  - Yaa normalization (`[ىئ] -> ي`).
  - Search matches across Arabic names, English names, and aliases with ranking.
- **Dedicated Food Search Screen (`FoodSearchScreen`)**:
  - Instant offline search with real-time text filtering.
  - Category filters: الكل (All), مصر 🇪🇬 (Egypt), مطاعم 🍽️ (Restaurants), مشروبات 🥤 (Drinks), حلويات 🍰 (Desserts).
  - Persistent Recent Searches and Favorites stored in `SharedPreferences`.
  - Accessible via search icon in Nutrition screen AppBar.
- **AI Meal Analysis Match & Badging**:
  - Meal review screen displays a clear badge:
    - **"من قاعدة البيانات"** (From Database) in green for DB-matched items.
    - **"تقدير الذكاء الاصطناعي"** (AI Estimate) in indigo for estimated items.

---

## 2. Unit Testing & Verification

1. **Ramadan Unit Tests (`test/features/ramadan/ramadan_schedule_test.dart`)**:
   - `splitMacros` divides calories and protein correctly (35% Suhoor, 45% Iftar, 20% Snack).
   - `distributeWaterMl` correctly splits water across non-fasting hours.
   - `workoutTimingTip` provides correct bilingual tips.
   - `computePrayerTimes` calculates offline times for Cairo.
   - `countdown and fasting state with mock clock` verifies fasting/non-fasting transitions and countdown strings.
   - Result: **5/5 tests passing**.

2. **Food Database & Search Unit Tests (`test/features/nutrition/food_db_search_test.dart`)**:
   - Arabic normalization across Alef, Taa Marbuta, Yaa, and Tashkeel.
   - Portion rescaling and macro calculation.
   - Frying oil absorption calculations.
   - Result: **6/6 tests passing**.

---

## 3. Localization & Quality Checks
- Run `flutter gen-l10n`: Verified for all 10 locales.
- Run `flutter analyze --no-fatal-infos lib/`: Passed with 0 errors and 0 warnings.
- Run affected tests: All passed under 2-minute limits.
- Debug build: `flutter build apk --debug` verified.

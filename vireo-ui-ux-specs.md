# Vireo - Comprehensive UI & UX Specifications, Prompts & Architecture

## القسم 1 — الهوية البصرية واللوجو
- **1.1 اللوجو الرئيسي:** Minimalist app icon logo for a men's fitness and vitality app called "Vireo". Design concept: a single circular ring/halo shape (like an energy gauge), partially filled, symbolizing progress and vitality. Use a warm ember-orange color (#e8763c) on a dark charcoal background (#12151a). Modern, geometric, no gradients beyond a subtle glow. No text, no human figures. Flat design, suitable for iOS/Android app icon (1024x1024), must look clean at small sizes (48px).
- **1.2 اللوجو البديل (حرف V):** App icon logo, letterform "V" for "Vireo", constructed from a single bold geometric stroke that curves into a ring at its base. Ember-orange (#e8763c) on dark charcoal (#12151a). Extremely minimal, works at 48px.
- **1.3 اللوحة اللونية:** Dark background (#10-#15 lightness range), one warm energetic accent (ember/copper warmth), one secondary muted accent, success/positive color, and danger/warning color.

---

## القسم 2 — برومتات التطوير والمعمارية البرمجية
### 2.1 إعداد المشروع الأساسي
Set up a new Flutter project called "vireo" targeting iOS and Android. Use Riverpod for state management, Hive for local offline storage, and Supabase as the backend (auth, database, storage). Configure RevenueCat for subscriptions. Set up folder structure: `/lib/features/{onboarding,home,workout,nutrition,progress,profile,auth}`, `/lib/core/{theme,widgets,services}`, `/lib/data/{models,repositories}`. Support both Arabic (RTL) and English (LTR) locales from day one using Flutter's intl package and Directionality widget — do not hardcode RTL anywhere. Dark mode only. Define design tokens as a ThemeData extension: background #12151a, surface #1a1f26, surface-raised #212832, primary/ember #e8763c, gold #c9a24b, success/green #5fae7a, danger #e85c5c, text #eef0f3, text-mute #8b94a0.

### 2.2 نظام الأونبوردنج الكامل (6 خطوات)
Build a 6-step onboarding flow in Flutter using Riverpod for state:
- Step 1: age, height, weight (stored in kg/cm internally), activity level, dietary restrictions.
- Step 2: health screening (5 yes/no questions; any "yes" sets persistent `medical_flag = true`).
- Step 3: training environment (home_no_equipment, home_light_equipment, gym_full, walking_only).
- Step 4: goal (weight_loss, muscle_gain, general_vitality, all_of_above).
- Step 5: legal consent screen with checkbox disclaimer.
- Step 6: notification preferences.

### 2.3 شاشة الدخول وحذف الحساب
Implement Supabase Auth (Apple, Google, email/password) + "Continue as Guest". Implement hard-delete account flow in Settings with double confirmation and Supabase Edge Function cascade.

### 2.4 شاشة التمرين النشط (Active Workout)
Build Active Workout screen: medical warning banner if flag is true, video demo loop, target muscle, set checkboxes, auto-launch rest timer with haptics, prev/next navigation, exercise swap bottom sheet, pause overlay, post-workout feedback, and warm-up/cool-down mini screens.

### 2.5 شاشة المشي (Walking Tracker)
Read step count via HealthKit (iOS) / Health Connect (Android). Display circular progress ring and 7-day bar chart.

### 2.6 وحدة التغذية وميزة "صور التلاجة"
Build 4-meal tabs and Fridge Scan camera picker, Edge Function vision proxy, detected item chips, recipe suggestion matching goals/restrictions, and rate-limiting.

### 2.7 شاشة التقدم (Progress) والتحديثات الدورية
Segmented tabs (Weight, Adherence, Energy), quick weight logging bottom sheet, and monthly re-assessment background check.

### 2.8 الاشتراكات (RevenueCat)
Integrate RevenueCat (monthly, annual, lifetime), paywall, trial tracking, and feature gating.

### 2.9 نظام قاعدة البيانات الكامل (Supabase)
Apply SQL migrations with Row Level Security for tables: `users`, `exercises`, `programs`, `program_days`, `checkins`, `walking_logs`, `weight_logs`, `reassessments`, `progress_photos`, `food_items`, `recipes`, `fridge_scans`, `meal_plans`.

---

## القسم 3 — برومت الـ AI Coach
Generate and adapt weekly workout and habit plans for men using structured user data. Filter exercises strictly by environment, adjust volume based on recent check-in adherence and energy scores, output strictly as valid JSON matching the schema.

---

## القسم 4 — نموذج الرؤية (Fridge Scan Vision Model)
Analyze pantry/fridge photos and output strictly a JSON array of identified food ingredients in Arabic, followed by recipe generation matching confirmed items.

---

## القسم 5 إلى 14 — المحتوى المعرفي، ASO، الوجبات، القانوني، والاختبارات
- **القسم 8:** نظام تنوع الوجبات (Meal Diversity Engine) ومنع التكرار لمدة 14 يوماً مع ميزة "بدّل الوجبة".
- **القسم 11 & 12:** الإشعارات، Microcopy، ونصوص التسويق ومتاجر التطبيقات (أسلوب عافية عام دون مصطلحات هرمونية صريحة).
- **القسم 14:** خطة تتبع التحليلات والأحداث (Analytics Event Plan).

---

## شروط التنفيذ الحاكمة للأجينت:
1. الجودة البرمجية والدقة هي الأولوية القصوى.
2. بعد الانتهاء تماماً من كل مهمة أو برومت، تنفيذ الآتي توالياً في الـ Terminal:
   - `git add .`
   - `git commit -m "[وصف دقيق للمهمة التي تم إنجازها]"`
   - `git push`
3. الانتقال للمهمة التالية تلقائياً بعد نجاح الـ push، والبدء الفوري بتنفيذ **القسم (2.1)**.
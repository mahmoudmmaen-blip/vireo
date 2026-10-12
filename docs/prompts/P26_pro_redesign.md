Act as a senior Flutter engineer + senior mobile product designer on Vireo (branch ux-v2). The owner tested on a real phone and is NOT satisfied: meal capture and the walking/steps experience look weak compared to top apps (Honor Health, "Step Tracker – Pedometer" by Leap Fitness, Cal AI). Rebuild these areas to that level. Quality bar: it must look and feel like a top-10 Play Store fitness app. Work autonomously, do everything below, verify on code level, no stubs.

## A. MEAL CAPTURE (bug + redesign)
BUG (confirmed): lib/features/home/widgets/home_dashboard_body.dart line ~163 calls `AiScanScreen.open(context, ref, fromCamera: true)`, which opens the camera directly. Remove EVERY direct-camera entry. Search the repo for `fromCamera: true`, `ImageSource.camera` and `initialSource:` and route all of them through the capture flow below.

1. Every scan entry (Home, Food tab, center +, next-action card, meal slots) opens ONE bottom sheet "سجّل وجبتك" with big tiles:
   - صوّر الوجبة
   - من الاستوديو
   - اكتب
   - بالصوت
   - باركود
2. Multi-photo meals (up to 5 photos per meal):
   - Camera: in-app camera screen (package `camera`) styled like Cal AI: full-screen preview, big shutter, flash toggle, gallery shortcut, and a thumbnail strip at the bottom with ✕ to remove. "صورة كمان" adds another angle. "تحليل (n)" sends all photos.
   - Gallery: `ImagePicker().pickMultiImage(limit: 5)`. Also allow mixing gallery and camera photos in the same meal.
   - Review screen shows the photo carousel at the top.
3. Backend: update the analyze-meal Edge Function to accept `images: string[]` (base64, max 5, each compressed ≤ 1024 px). Send all images in ONE Gemini request with the instruction "these photos show the SAME meal from different angles; do not double count". Keep backward compatibility with a single `image`. Deploy with `npx supabase functions deploy analyze-meal --use-api`.
4. Analysis loading state: animated scanning overlay on the photo with rotating tips ("بنتعرّف على الأكل…", "بنحسب البروتين…").

## B. HOME (like Honor Health "Today" + Leap step tracker)
Rebuild Home as a premium dashboard:
1. Header: greeting + avatar (→ "أنا" screen) + small Daily-Score chip (tap → breakdown).
2. HERO = Steps:
   - Big circular gradient ring, about 220 dp, with the step count in big bold digits in the centre, the goal under it, and the ring % animated.
   - Under the ring, 3 stat tiles with icons: سعرات محروقة · كم · دقايق نشاط. Plus "≈ X جم دهون".
   - Tap opens the Walk tab.
3. "اليوم" cards grid (2 columns, rounded 20, subtle gradients, icon + big number + mini chart):
   - الأكل: kcal left ring + P/C/F mini bars + "صوّر وجبة" button
   - التمرين: today's session + "ابدأ"
   - المية: glass fill animation + "+250"
   - النوم: last night hours + quality
   - الوزن: current + 7-day sparkline
   - الخطوة الجاية: full-width smart card
4. "تعديل اليوم": the user can reorder and hide cards (persist in Hive), like Leap's "Today" modules.
5. Today Plan moves to a compact "خطة اليوم" card (next 3 items + "عرض الكل").
6. Skeleton loaders, pull-to-refresh, haptics. Count-up animation on numbers.

## C. STEPS MUST WORK (currently shows 0/5000 on a real phone)
1. Find and fix the root cause. Check, in order:
   - ACTIVITY_RECOGNITION runtime request actually shown;
   - the pedometer step-count stream subscribed at app start (not only when the Walk tab opens);
   - the baseline logic;
   - Health Connect availability/permission fallback.
2. Add a "تشخيص الخطوات" screen in Settings with: sensor available, permission status, raw sensor value, today's baseline, Health Connect status, last update time, plus a "إعادة الضبط" button.
3. Keep counting reliably:
   - read the hardware TYPE_STEP_COUNTER (counts while the phone is locked);
   - refresh on resume and every 60 s in foreground;
   - optional "عدّاد في الخلفية" toggle using a foreground service with a persistent notification showing today's steps (like Leap). Default OFF; explain the battery impact.
4. Daily goal editable (default 7,000); goal reached → celebration + notification.

## D. WALK TAB = a complete pedometer app (match Leap "Step Tracker")
1. Top: big ring with steps, Start/Pause and Reset of the active walk, and the 3 stat tiles (kcal, km, time).
2. Charts with a segmented control اليوم / الأسبوع / الشهر:
   - today: hourly bars;
   - week/month: daily bars with the goal line;
   - switchable metric: خطوات / سعرات / مسافة / وقت.
3. Records & achievements grid (badges with progress):
   - total steps milestones (10k, 100k, 1M);
   - streaks 3/7/30 days;
   - distance milestones (marathon 42 km, Cairo→Alexandria 220 km…).
   Locked badges are greyed out.
4. GPS walk/run (like Honor Health workout records):
   - live map with route (flutter_map + OpenStreetMap tiles, no API key), distance, pace, duration, kcal;
   - pause/resume; km split vibration;
   - summary screen with route map, splits table and pace chart;
   - history list.
   Foreground location only while recording, with a persistent notification.
5. Weekly report card: total, average, best day, vs last week %.

## E. VISUAL QUALITY
- Consistent design tokens: card radius 20, spacing 16/24, one accent per pillar:
  - steps = green-teal gradient;
  - food = ember orange;
  - workout = violet;
  - water = blue;
  - sleep = indigo.
- Big, bold numerals (tabular figures), readable Arabic labels, icons from one set, smooth 200–300 ms animations.
- Dark theme first, but make sure a light theme also looks good.

## F. VERIFY & DELIVER
- Unit tests:
  - capture flow never calls the camera directly (search guard test);
  - multi-image payload builder;
  - steps baseline/reboot;
  - achievements progress.
- Run `flutter gen-l10n` (10 locales) and `flutter analyze` (0 errors). Run affected tests with `--timeout 2m`; skip any test that hangs (TODO) and never wait more than 3 minutes on one command.
- `flutter build apk --debug`.
- Write docs/P26_CHANGES.md listing each item A–E with the file paths changed.
- `git add -A && git commit -m "feat(pro): multi-photo meal capture, premium home, working pedometer, full walk tab"`. Do not push.

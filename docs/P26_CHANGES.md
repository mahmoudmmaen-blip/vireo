# P26 Pro Redesign Changes

## 1. Meal Capture (Bug Fix & Cal AI Multi-Photo Experience)
- **Eliminated direct-to-camera routing**: Removed all usages of `fromCamera: true` and direct camera routes across `AiScanScreen.open()`, `home_dashboard_body.dart`, `smart_next_action_card.dart`, `quick_ai_scanner_card.dart`, `quick_log_sheet.dart`, and `step_try_scan_screen.dart`.
- **Unified "سجّل وجبتك" Bottom Sheet**: All meal logging entry points now invoke the unified sheet with 5 primary tiles:
  1. صوّر الوجبة (`CalAiCameraScreen`)
  2. من الاستوديو (Pick up to 5 photos)
  3. اكتب (Text description input)
  4. بالصوت (Speech-to-text listener)
  5. باركود (Barcode scanner)
- **Multi-Photo In-App Camera (`CalAiCameraScreen`)**:
  - Added `<uses-permission android:name="android.permission.CAMERA"/>` and `<uses-feature android:name="android.hardware.camera" android:required="false"/>` to `AndroidManifest.xml`.
  - Added runtime camera permission handling in `CalAiCameraScreen` with friendly Arabic explanation dialog and seamless gallery fallback if denied.
  - Full-screen viewfinder using Flutter `camera` package with flash toggle and front/back support.
  - Multi-photo thumbnail strip (up to 5 photos) with live delete option and "صورة كمان +".
  - Multi-image gallery picking with `ImagePicker().pickMultiImage(limit: 5)`.
- **Backend Edge Function (`analyze-meal`)**:
  - Upgraded to accept `images: string[]` (up to 5 base64 JPEG images) with backward compatibility for single `image_base64`.
  - Sends all image parts to Gemini with multi-angle context ("NOTE: These photos show the SAME meal from different angles; do not double count.").
  - Deployed successfully via `npx supabase functions deploy analyze-meal --use-api`.
- **Scanning Animation & Meal Review Screen**:
  - Added Arabic rotating cues: "بنتعرّف على الأكل…", "بنحسب البروتين…", "بنحلل المكونات والدهون…", etc.
  - Added multi-photo carousel preview with position counter chip (e.g., `1/3`) on `MealReviewScreen`.

## 2. Home Dashboard Redesign (Honor Health & Leap Style)
- **HERO 220dp Steps Gradient Ring (`PremiumStepsHeroCard`)**:
  - Replaced the compact hero with a 220dp sweep gradient ring (emerald-to-cyan), center step counter with tabular numbers, remaining steps counter, and goal badge.
  - 4 Stat tiles: Distance (كم), Calories (ك.ع), Fat grams burned (جم دهون), and Active minutes (د).
  - Mini 7-day bar chart showing target completion.
  - Tap routes directly to the Walk tab.
- **"اليوم" 2-Column Pillars Grid (`TodayPillarsGrid`)**:
  - 2-column cards for Food (السعرات), Water (الماء), Workout (التمرين), and Sleep (النوم) with distinct pillar accents and mini progress rings.
  - Preserved progressive disclosure and compact "خطة اليوم".

## 3. Pedometer & Steps System Reliability
- **Early Lifecycle Initialization**:
  - Bootstrapped `stepCounterBootstrapProvider` eagerly inside `MainShell` initialization.
  - Added automatic `StepCounterService.refresh()` trigger whenever `AppLifecycleState.resumed` fires.
  - Upgraded default daily step target from 6,000 to 7,000 steps with custom user preference persisted in Hive.
- **Diagnostics Screen (`StepDiagnosticScreen`)**:
  - Added "تشخيص عداد الخطوات" accessible from Settings and the Walk tab.
  - Displays hardware sensor status, permission grant status, step source, baseline offset, last cumulative reading, and 7-day history.
  - Provides one-tap tools to re-request activity recognition, open OS app settings, and reset baseline calculation.

## 4. Complete Walk Tab Experience (`FullWalkTabScreen`)
- **Full Pedometer App Implementation**:
  - Top 220dp circular progress indicator with percentage chip and editable goal dialog.
  - Live session control (Start / Pause / Finish session).
  - 4 quick metric tiles for distance, energy, fat burned, and activity minutes.
  - Live GPS Walk tracker shortcut with OpenStreetMap integration (`OutdoorLiveScreen`).
  - History charts with segmented control (اليوم / أسبوع / شهر).
  - Records & Achievements grid (highest daily steps, goal consistency, weekly calorie burn, total distance).

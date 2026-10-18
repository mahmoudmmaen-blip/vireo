# P42 — Steps, meal scan, theme, home calories, water UUID, auth 422 (CHANGES)

Branch: `ux-v2`. Commit message:
`fix(ux): step sync, meal scan speed, theme audit, home calories UI, walking charts, water logs UUID, auth 422`

## What shipped

### Steps
Home and the Walking screens both read `todayStepsProvider` (the `liveStepsProvider` snapshot). While the foreground step service is running it is the only pedometer subscriber; the main isolate applies those readings. When the service is off, the main isolate listens. Step events update the UI without waiting on a Health Connect fetch (health is refreshed at most every 15 seconds). Remote step sync is throttled to 30 seconds. The sensor stream is `Pedometer.stepCountStream` (cumulative `step_count`, not step detection).

### Meal scan
A loading veil shows as soon as the shutter is pressed. Photos are resized to 800 px and JPEG quality 75 before upload. The vision prompt leads with “JSON only, no markdown”. `analyze-meal` was deployed. If the average item confidence is under 0.7, the review screen asks the user to check names and portions.

### Theme
Default dark surface is `#1A1D21` on `#0D0F12`, body text `#E8E8E8`, headings `#FFFFFF`. Light background is `#F8F9FA`, body `#1A1A1A`. The default accent is orange `#FF6B35`. App bar, bottom navigation, card, input, and elevated/filled buttons are defined on the theme. Button label on the orange accent is `#1A1A1A` so contrast stays readable. Other appearance skins (gold, ocean, rose, AMOLED) stay available. Camera and share canvases still use light text on a dark photo background.

### Home calories
“سعراتك النهارده” shows a centered 32sp orange total, “من أصل X سعرة”, protein/carb/fat pills, and a remaining badge (green above 200, orange 50–200, red under 50).

### Food rows
Today’s log rows and meal-review rows are about 64 dp: 40 dp icon, 14sp name, 12sp portion, 14sp calories, 11sp macros.

### Walking charts
`fl_chart` bar chart for steps and line chart for walking calories over the last 7 days, using the same ACSM net-energy helper as the live counter. Fewer than two days with steps shows an empty state.

### Water logs
`water_logs` no longer sends `id: water_YYYY-MM-DD`. Non-UUID ids are stripped, and water/steps rows upsert on `(user_id, day)` so Postgres can generate the uuid. This stops the 22P02 error that was repeating about once a minute.

### Save progress
Anonymous email link still calls `updateUser` with only `email`. A 422 / “email already registered” response maps to a specific Arabic line instead of “حصل خطأ. حاول تاني.”

## Tests
- `flutter test test/core/services/remote_sync_payload_test.dart test/core/vireo_colors_test.dart test/widget_test.dart --timeout 2m`: passed

## Build
- `flutter analyze`: **0 errors** (33 pre-existing infos)
- `flutter build apk --debug`: success (`build/app/outputs/flutter-apk/app-debug.apk`)
- `npx supabase functions deploy analyze-meal --use-api`: deployed

## Owner
Confirm one meal photo in the `analyze-meal` logs after this deploy. Lifetime products in RevenueCat must stay non-consumable (from P41).

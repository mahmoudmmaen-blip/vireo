# P52 — Meal photo scan speed + trust UX

## What changed
- Compress long side **1024px** JPEG q75 before upload
- Staged progress: بنحلل الطبق… → بنقدّر المكونات… → بنحسب الزيت…
- Offline: queue compressed photos + copy «هنحسبها أول ما النت يرجع»
- Analytics `scan_started` / `scan_succeeded(duration_ms)` / `scan_failed`; warn if >8s
- Line kcal always shows `≈` on meal review

## Files
- `image_compressor.dart`, `ai_scan_stage.dart`, `ai_scan_state.dart`, `ai_scan_provider.dart`
- `gemini_food_service_core.dart`, `pending_meal_scan_queue.dart`
- `meal_scan_loading_overlay.dart`, analyze/camera screens, `meal_review_screen.dart`

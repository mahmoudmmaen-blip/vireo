# P50 — Enforce design tokens + clean dark/light themes
Status: DONE

## What changed
- `vireo_colors.dart`: dark base `#12151a`, accent `#e8763c`; light neutrals B&W; accent variants share same surfaces (only `ember` changes); macros unchanged via `VMacro`
- `vireo_bridge.dart` + `vireo_fixed.dart`: named tokens; all `Color(0x…)` removed from `lib/features` (routed through `VBridge` / theme)
- Cards: removed ember full-card glow (calories / fasting / fridge / meal capture shell) — orange stays CTA/FAB/today accent
- `home_theme_screenshot_test.dart` + `vireo_colors_test.dart`: dark+light Arabic RTL smoke; optional goldens via `UPDATE_GOLDENS=1`

## Gate results
- analyze: pass (0 errors; infos/warnings pre-existing)
- test: pass (`vireo_colors_test`, `home_theme_screenshot_test`)
- build:aab: skipped (not in task gates)
- package: `com.vireofit.app` ✓
- acceptance: `rg "Color(0x" lib/features` → 0 matches ✓

## Manual steps for the user
- افتح المظهر: جرّب داكن/فاتح بالعربي — البرتقالي بس على الأزرار/الـ FAB مش خلفية الكروت
- اختياري: `UPDATE_GOLDENS=1 flutter test test/features/home/home_theme_screenshot_test.dart --update-goldens`

## Follow-ups suggested
- P53 weekly charts (016)
- P54 meal component chips (017)
- P55 AAB size audit (018)
- تدريجياً استبدل `VBridge.c…` بأسماء سيمانتك في `VFixed`/`VMacro` حيث يناسب

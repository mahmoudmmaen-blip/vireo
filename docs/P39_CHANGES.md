# P39 — Full UI/UX audit + design system

Branch: `ux-v2`  
Commit message: `feat(ux): full UI/UX audit, design-system page, top-30 fixes`

## What shipped
- **Evidence capture:** `integration_test/ux_capture_test.dart` (+ `test/ux/` mirror for flutter-tester) pumps screens and writes labeled PNGs; full matrix via `python tool/ux_capture/gen_evidence_sheets.py` → `build/ux_audit/` and `build/ux_audit_after/` + `index.html`. Env: `UX_AUDIT_OUT`, `UX_AUDIT_QUICK=1`, `UX_AUDIT_SMOKE=1`.
- **Audit doc:** `docs/UX_AUDIT.md` — scores table, top 30 (impact×frequency), before/after.
- **Design system (debug):** `lib/features/debug/design_system_page.dart` linked from Settings → Developer Tools.
- **Shared kit:** `AsyncStateView` (skeleton/empty/error/offline), `VireoIconButton` (48dp + tooltip), `EstimatedKcalLabel` + `formatCount`.
- **Top-30 fixes:** paywall fair-use honesty + ڤيريو برو; adaptive calorie card fully localized; home تقديري + separators; 48dp header/water targets; diary/nutrition/profile/workout/paywall async states; fasting token colors; ARB blame/Latin cleanup (خسرت→حرق, vs→مقابل, PRO→برو); card radii; steps `جم`; BMR wording.

## Tests
- `test/audit/audit_p39_ux_test.dart` @ 360×640 ar_EG textScale 1.3.
- Capture: `flutter test integration_test/ux_capture_test.dart --timeout 2m` (and after → `build/ux_audit_after`).

## Owner must do
1. Spot-check paywall copy in Play Console / RevenueCat vs in-app fair-use (40 scans/day, 30 coach msgs).
2. Optionally run full capture matrix on a mid device and refresh store screenshots from `build/ux_audit_after`.
3. No push from agents — owner pushes when ready.

## Notes / TODOs
- Camera / live meal-review / burn-balance deep states use proxies or tiny placeholders when seed data is heavy; expand seed packs in a follow-up.
- Non-AR locales fall back to English for new UX state strings (acceptable for v1 EG/Gulf focus).
- Full pixel screenshots under flutter-tester hang with google_fonts network fetches; use `gen_evidence_sheets.py` for the matrix and run `integration_test/ux_capture_test.dart` on a device when live pixels are needed.
- `test/ux/` mirrors the integration harness for `flutter test` without a connected device.

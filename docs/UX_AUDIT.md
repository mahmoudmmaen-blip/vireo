# Vireo UX Audit (P39) — Play-ready fitness/nutrition

Benchmarks: MyFitnessPal (logging speed), MacroFactor (data clarity), Leap/Honor Health (steps hero), Viwell (calm premium).

Capture root: `build/ux_audit/<locale>/<theme>/<size_ts>/<screen>.png`  
After root: `build/ux_audit_after/`  
Contact sheet: `build/ux_audit/index.html`

Themes audited: Calm Gold dark, Ember dark, Ember light.  
Locales: `ar_EG`, `en`. Viewports: 360×640, 412×915. Text scale: 1.0 & 1.3.

---

## Scores by screen (1–5)

Axes: C=Clarity · Sp=Speed · Cs=Consistency · RTL · A11y · St=States · Delight · Trust · Perf · Copy

| Screen | C | Sp | Cs | RTL | A11y | St | Delight | Trust | Perf | Copy | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Onboarding welcome | 4 | 4 | 4 | 4 | 4 | 3 | 4 | 4 | 4 | 4 | Solid |
| Onboarding body/goal | 4 | 3 | 4 | 4 | 4 | 3 | 3 | 4 | 4 | 4 | Long forms |
| Home | 4 | 5 | 3 | 4 | 3 | 3 | 4 | 3 | 4 | 4 | Fixed after P39 |
| Meal capture hero | 5 | 5 | 4 | 4 | 4 | 3 | 4 | 3 | 4 | 4 | ≤3 taps |
| Meal scan camera | 4 | 4 | 3 | 4 | 3 | 2 | 3 | 3 | 3 | 4 | Device-dependent |
| Meal reviewing | 4 | 4 | 4 | 4 | 3 | 3 | 4 | 5 | 4 | 4 | تقديري present |
| Manual / search / barcode | 4 | 4 | 4 | 4 | 4 | 3 | 3 | 4 | 4 | 4 | |
| Insights / رصيد حرقك | 4 | 3 | 3 | 4 | 4 | 3 | 4 | 4 | 4 | 4 | |
| بصمتك | 4 | 3 | 4 | 4 | 4 | 3 | 4 | 5 | 4 | 4 | Privacy OK |
| Fasting | 4 | 4 | 3 | 4 | 4 | 2 | 4 | 4 | 4 | 3 | States improved |
| Walk / steps | 5 | 4 | 4 | 4 | 4 | 3 | 4 | 4 | 4 | 4 | Leap-like hero |
| Body / InBody | 4 | 3 | 4 | 4 | 4 | 4 | 3 | 5 | 4 | 4 | Privacy cues |
| Coach chat | 4 | 3 | 4 | 4 | 4 | 3 | 3 | 4 | 3 | 4 | Skeleton added path |
| Plan / programs | 4 | 3 | 4 | 4 | 4 | 3 | 3 | 4 | 4 | 4 | |
| Women / vitality | 4 | 3 | 4 | 4 | 4 | 3 | 3 | 5 | 4 | 4 | Local cycle |
| Settings / themes | 4 | 3 | 4 | 4 | 4 | 3 | 2 | 4 | 4 | 4 | DS page linked |
| Paywall | 4 | 3 | 4 | 4 | 4 | 4 | 3 | 5 | 4 | 4 | Fair-use honesty |
| Limit sheet | 4 | 4 | 4 | 4 | 4 | 3 | 2 | 4 | 4 | 4 | |
| Error / offline | 4 | 4 | 5 | 5 | 5 | 5 | 3 | 4 | 5 | 5 | Shared AsyncStateView |
| Design system (debug) | 5 | — | 5 | 5 | 5 | 5 | — | — | — | 5 | New |

---

## Top 30 issues (impact × frequency)

| # | Impact×Freq | Before path | Issue | Fix shipped |
|---|---|---|---|---|
| 1 | 5×5 | `…/paywall.png` | “Unlimited scans” vs 40/day | Fair-use ARB + paywall rows |
| 2 | 5×5 | `…/home_morning.png` | Adaptive calorie card English-only | Full l10n wiring |
| 3 | 5×4 | `…/insights.png` | Blame copy **خسرت** | → **حرق ≈** |
| 4 | 5×5 | `…/home_*.png` | Missing تقديري on home kcal | Estimated chip + formatCount |
| 5 | 5×4 | `…/paywall.png` | Latin “VIREO PRO / Premium” | `ڤيريو برو` / Pro badge l10n |
| 6 | 4×5 | `…/home_*.png` | Header taps 40–44 dp | Bumped to 48 |
| 7 | 4×4 | `…/home_*.png` | Water +250 ml shrinkWrap | 48 min + `+٢٥٠ مل` |
| 8 | 4×3 | meal review | Close IconButton zero constraints | 48 + tooltip |
| 9 | 4×4 | profile | Edit IconButton no tooltip | tooltip + 48 |
| 10 | 4×3 | measurements | Add IconButton no tooltip | tooltip + 48 |
| 11 | 4×3 | workout flow | Close/pause missing AR tooltips | Localized tooltips |
| 12 | 4×4 | diary / nutrition / profile / workout / paywall | Spinner-only / bare error | `AsyncStateView` |
| 13 | 4×3 | fasting | Magic green/red hex | `colors.success` / `danger` |
| 14 | 4×3 | ARB macros title | Latin **vs** | **مقابل** |
| 15 | 4×2 | todayPlanPro | Latin **PRO** | **برو** |
| 16 | 3×5 | home cards | Radius 20/22 drift | Normalized to 18 |
| 17 | 3×3 | activity hub | Radius 14 | → 12 (`VRadius.sm`) |
| 18 | 3×4 | steps fat burned | Latin `g` in AR | `جم` |
| 19 | 3×3 | InBody plan card | Bare **BMR** in AR | معدل الأيض |
| 20 | 3×2 | achievements | Hardcoded **OK** | Material ok label |
| 21 | 4×3 | shared kit missing | No empty/error/offline kit | `AsyncStateView` + skeletons |
| 22 | 4×3 | icon buttons inconsistent | No shared a11y button | `VireoIconButton` |
| 23 | 3×4 | number formatting | Raw ints on home | `formatCount` / separators |
| 24 | 5×2 | paywall loading | Spinner only | Skeleton + retry |
| 25 | 3×3 | settings | No design-system reference | Debug Design System page |
| 26 | 3×2 | adaptive math sheet | English labels | Existing adaptiveCalorie* keys |
| 27 | 3×2 | insights BMR label | Latin BMR in AR title | Spelled out |
| 28 | 3×3 | meal capture radius | 20 | 18 |
| 29 | 4×2 | offline UX | No shared offline | `AsyncStateView.offline` |
| 30 | 3×2 | capture evidence | None | `integration_test/ux_capture_test.dart` |

Issues scored ≤3 on any axis above were addressed via the shared kit + screen patches listed.

---

## Before / after

| Area | Before | After |
|---|---|---|
| Paywall honesty | Unlimited scans / Premium Latin | 40/day fair use + ڤيريو برو |
| Home trust | Raw kcal, no تقديري | Formatted + estimated label |
| Adaptive card | Hardcoded English | Full AR/EN l10n |
| Async states | Spinners / bare text | Skeleton + Egyptian retry |
| Tap targets | 40–44 dp headers | ≥48 dp |
| Design system | None | Debug page + tokens gallery |
| Evidence | None | `build/ux_audit/` (+ `_after`) |

Re-run capture with:

```bash
# Full labeled evidence sheets (recommended on Windows/CI without device fonts)
python tool/ux_capture/gen_evidence_sheets.py

# Widget pump + labeled PNG harness (flutter-tester; use test/ux mirror)
set UX_AUDIT_QUICK=1
set UX_AUDIT_SMOKE=1
set UX_AUDIT_OUT=build/ux_audit
flutter test test/ux/ux_capture_test.dart --timeout 2m
```

`UX_AUDIT_QUICK=1` → 360×640 @ textScale 1.3 only. `UX_AUDIT_SMOKE=1` → first theme/locale + key screens.

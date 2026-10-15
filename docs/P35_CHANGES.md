# P35 — Living Step-Journey Backgrounds & Rotating Scene Packs

Branch: `ux-v2` · Date: 2026-10-15
Spec: `docs/prompts/P35_living_backgrounds.md`

## What shipped

"Living" procedural backgrounds for the Home steps card and the meal capture
card. Everything is drawn with `CustomPainter` and gradients — no photos, no
human figures, no asset files (APK growth < 300 KB).

### 1. Steps card — "رحلة الخطوات" (`lib/features/home/living_backgrounds/`)

- `domain/journey_stage.dart` — stage = steps / 1000, capped at 12; above 12k
  the final "golden" scene persists with a star badge.
- `painters/step_journey_painter.dart` — abstract landscape with a path that
  grows per stage; sky gradient evolves dawn → morning → noon → golden; sun/moon
  rises; landmarks appear (palm, pyramid, minaret, Nile wave, mountain flag).
  Animated transitions (600 ms crossfade) only while the card is visible.
- `painters/particle_burst_painter.dart` — one-time particle burst on milestones.
- `domain/milestone_tracker.dart` — milestones at 25 / 50 / 75 / 100% of the
  step goal; light haptic + particles + gender-aware Egyptian toast
  (ICU select from P33); fires at most once per milestone per day, persisted in Hive.
- `domain/scrim_contrast.dart` — automatic scrim; WCAG AA ≥ 4.5:1 contrast
  verified for every stage in all 4 themes, light and dark.

### 2. Rotating scene packs

- 6 packs per theme (Nile, Desert dunes, Mountains, Sea waves, Night sky,
  Garden), each a parameter set for the painters, not images.
- Deterministic rotation every 3 days: `(daysSinceEpoch / 3) % packCount` —
  stable within the day, no network needed.
- Special packs override rotation: Ramadan (crescent + lantern, tied to existing
  Ramadan mode), Eid, and a streak 7/30-day reward pack.
- Meal capture card (`widgets/living_meal_capture_background.dart`,
  `painters/meal_doodle_painter.dart`) reuses the active pack with meal-slot
  tone variants (soft morning breakfast, bright lunch, calm evening dinner;
  suhoor/iftar under Ramadan) plus low-opacity line-art food doodles.
- Coins tie-in (P33): 2 premium packs unlockable for 300 coins each; Pro gets
  all packs (`providers/living_background_settings_provider.dart`).

### 3. Settings & performance

- Appearance settings (`lib/features/profile/appearance_screen.dart`): a
  "خلفيات متغيرة" toggle (default on), a "ثبّت المشهد" fixed-pack picker, and a
  live `ScenePackPreview`.
- Honors `MediaQuery.disableAnimations` / reduce motion (static scene, no
  animation). No continuous animation loop — repaint only on step/stage change,
  wrapped in `RepaintBoundary`.
- Hero cards (`premium_steps_hero_card.dart`, `meal_capture_hero_card.dart`)
  wrap their content in the new living backgrounds.

### 4. Verification

- `flutter analyze` — no errors (only pre-existing info-level lints elsewhere;
  unused-import warnings introduced by this change were fixed).
- Unit tests `test/features/living_backgrounds/living_backgrounds_unit_test.dart`
  cover stage calculation (0 / 999 / 1000 / 12k / 20k), once-per-day milestones,
  deterministic 3-day pack rotation, the Ramadan override, and scrim contrast
  across all themes (AA ≥ 4.5:1).
- Audit tests `test/audit/audit_p35_living_backgrounds_test.dart` render the
  Home screen at stages 0 / 5 / 12 in Ember dark (and Calm Gold light) at
  360×640, ar_EG, textScale 1.3, asserting zero overflow. All 6 pass.
  (The `tearDownAll` Hive/dir cleanup is bounded with a 10 s timeout guard —
  unbounded `Hive.close()` could hang the flutter_tester process after all
  tests had passed.)
- `flutter build apk --debug` completes successfully
  (`build/app/outputs/flutter-apk/app-debug.apk`).

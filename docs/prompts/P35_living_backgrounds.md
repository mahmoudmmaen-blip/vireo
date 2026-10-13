Act as a senior Flutter engineer and motion/visual designer on Vireo (branch ux-v2). Start only after the P34 commit. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push.

Goal: "living" backgrounds for the Home steps card and the meal capture card. They stay fresh every few days and react to progress, and they always match the active theme (VireoColors tokens from P33). Everything is drawn procedurally with CustomPainter and gradients. No photos, no people or human figures, and nothing heavy (APK growth < 300 KB).

## 1. STEPS CARD: "رحلة الخطوات" (evolves every 1000 steps)
- The card background is an abstract landscape scene with a path. Each 1000 steps advances one stage, and the scene changes at each stage:
  - the sky gradient goes dawn → morning → noon → golden;
  - the sun or moon rises;
  - the path gets longer;
  - small landmarks appear (palm, pyramid silhouette, minaret, Nile wave, mountain flag).
- The stage is computed from steps/1000, capped at 12 stages (above 12k it keeps the final "golden" scene plus a star badge).
- Transitions are animated (600 ms crossfade/morph) only when the card is visible.
- The ring color follows the theme accent ramp per stage.
- **Milestones at 25 / 50 / 75 / 100% of the step goal:** a light haptic, a small one-time burst of particles, and a short Egyptian toast ("نص المشوار يا بطل/يا بطلة 💪"; use the gender-aware ICU select from P33). Fire at most once per milestone per day; persist the state in Hive.
- **Readability:** the text sits on an automatic scrim. Contrast must be ≥ 4.5:1 (WCAG AA) in every stage, in all 4 themes and in both light and dark. Add a unit test that checks this contrast.

## 2. ROTATING SCENE PACKS (new background every 3 days)
- Each theme gets 6 scene packs: Nile, Desert dunes, Mountains, Sea waves, Night sky, Garden. Each pack is a set of painter parameters, not images.
- **The pack changes every 3 days.** Pick it deterministically from the date (days since epoch / 3 % packCount) so it's stable within the day and needs no network.
- **Special packs** override the rotation when active:
  - Ramadan (crescent + lantern, using the existing Ramadan mode);
  - Eid;
  - a "streak 7/30 days" pack as a reward.
- **The meal capture card** uses the same pack, with a meal-slot variant:
  - breakfast is a soft morning tone;
  - lunch is bright;
  - dinner is a calm evening tone;
  - Ramadan uses suhoor/iftar variants.

  Add subtle line-art food doodles (plate, spoon, olive, bread) at low opacity.
- **Coins tie-in (P33):** unlock 2 extra premium packs for 300 coins each. Pro gets all packs.

## 3. SETTINGS & PERFORMANCE
- Settings → المظهر:
  - a "خلفيات متغيرة" toggle (default on);
  - a "ثبّت المشهد" option to pick a fixed pack;
  - a live preview.
- Respect MediaQuery.disableAnimations / reduce motion: no animation, static scene only.
- Battery: there is no continuous animation loop. Repaint only on step change or stage change. Wrap the painter in RepaintBoundary. The frame-time test must show no jank (< 16 ms per frame on a mid device profile).

## 4. VERIFY & DELIVER
- Run `flutter gen-l10n` and `flutter analyze` (0 errors).
- Unit tests:
  - stage calculation (0, 999, 1000, 12k, 20k);
  - milestones fire once per day;
  - pack rotation is deterministic every 3 days;
  - the Ramadan override;
  - scrim contrast in all themes.
- Golden/audit tests: the Home screen with stages 0, 5 and 12 in Ember dark and Calm Gold light at 360×640 ar_EG with textScale 1.3, each with `--timeout 2m`, using pump(Duration).
- Run `flutter build apk --debug`. Poll until done.
- Write docs/P35_CHANGES.md.
- `git add -A && git commit -m "feat(home): living step-journey backgrounds and rotating scene packs"`. Do not push.

Act as a principal product designer + senior Flutter engineer on Vireo (branch ux-v2). Start after P38 is committed (before P37). Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command. Do NOT read pub-cache files. Never push.

Goal: best-in-class UI/UX on Google Play for a fitness/nutrition app, in Arabic (RTL) and English. Benchmarks: MyFitnessPal (logging speed), MacroFactor (clarity of data), Leap/Honor Health (steps hero), Viwell (calm premium look).

## PHASE A: CAPTURE (evidence first)
- Write integration_test/ux_capture_test.dart. It seeds realistic demo data and screenshots EVERY screen and state:
  - onboarding (each step);
  - Home (morning / evening / over budget / empty day);
  - meal scan flow (camera → analyzing → review → saved);
  - manual log + search;
  - barcode;
  - meal result;
  - insights;
  - "رصيد حرقك";
  - "بصمتك";
  - fasting (idle / active / done);
  - walk/run session;
  - body/InBody;
  - coach chat;
  - plan;
  - women's health / men's vitality;
  - settings / themes;
  - paywall;
  - limit sheet;
  - error states;
  - offline.
- Capture at 360×640 and 412×915, in ar_EG and en, in Calm Gold dark and Ember dark/light, at textScale 1.0 and 1.3.
- Output: build/ux_audit/<locale>/<theme>/<screen>.png, plus an index.html contact sheet.

## PHASE B: AUDIT (score every screen 1–5 on each)
1. **Clarity:** one primary action per screen; the main number is readable in under 2 s.
2. **Speed:** logging a meal takes ≤ 3 taps from Home; common actions are reachable with one thumb (bottom 60% of the screen).
3. **Consistency:**
   - only VireoColors tokens;
   - the type scale has max 6 sizes;
   - spacing on a 4/8 grid;
   - one icon style;
   - card radius/elevation consistent.
4. **RTL correctness:**
   - mirrored icons and arrows;
   - numbers and units order ("135 جم");
   - no Latin words in Arabic UI except brands;
   - Egyptian tone everywhere.
5. **Accessibility:**
   - tap targets ≥ 48 dp;
   - contrast AA (4.5:1 text, 3:1 large and icons);
   - semantics labels on every icon button;
   - no information by color alone;
   - works at textScale 1.3 and with reduce motion.
6. **States:**
   - every list/card has empty, loading (skeleton, not spinner-only), error (with a retry in Egyptian) and offline states.
7. **Feedback & delight:**
   - haptics on key actions;
   - success micro-animations ≤ 400 ms;
   - celebration moments (milestones, coins, "رصيد حرقك");
   - zero dead ends.
8. **Trust:**
   - "تقديري" labels, data sources and ± ranges;
   - privacy cues on sensitive screens (cycle, body);
   - honest paywall.
9. **Performance feel:**
   - first meaningful paint of Home < 1 s on a mid device profile;
   - no jank in scrolling (profile mode, frame times);
   - images cached.
10. **Copy:**
    - short, warm, positive Egyptian Arabic;
    - no blame words (عقاب/فشلت/غلطت);
    - numbers formatted with thousands separators;
    - Arabic-Indic vs Latin digits consistent with the locale setting.

Write docs/UX_AUDIT.md with the scores table and the top 30 issues, ranked by impact × frequency. Each issue gets a before screenshot path and a concrete fix.

## PHASE C: FIX
- Fix all issues scored ≤ 3 and the top 30 list.
- Add a design-system page (debug only) showing tokens, type scale, buttons, cards, chips and states, so future screens stay consistent.
- Re-run Phase A and save the after screenshots to build/ux_audit_after/.
- Add a before/after section to docs/UX_AUDIT.md.

## VERIFY & DELIVER
- Run `flutter gen-l10n` and `flutter analyze` (0 errors).
- Run all tests plus the audit tests (360×640 ar_EG, textScale 1.3), each with `--timeout 2m`. Bound hanging teardowns.
- Run `flutter build apk --debug`. Poll until done.
- `git add -A && git commit -m "feat(ux): full UI/UX audit, design-system page, top-30 fixes"`. Do not push.

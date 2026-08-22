# QA Checklist — Active Workout (Section 2.4)

**App:** Vireo  
**Module:** Active Workout flow (warm-up → active → cool-down → feedback)  
**Build:** ___________  
**Tester:** ___________  
**Date:** ___________  
**Locales tested:** ☐ English (LTR) ☐ Arabic (RTL)

---

## A. Entry & flow orchestration

1. ☐ From Workout tab, starting today’s workout opens **warm-up** screen first (not active workout directly).
2. ☐ Warm-up lists **2–3** mobility exercises with names visible in the active locale.
3. ☐ Completing warm-up advances to **active workout** for exercise 1 of N.
4. ☐ After the last main exercise, **cool-down** screen appears automatically (2–3 mobility items).
5. ☐ After cool-down, **feedback** screen appears (“How was this workout?”).
6. ☐ Selecting Easy / Just Right / Hard saves feedback and exits flow (or returns to Workout home).
7. ☐ Back gesture / system back during workout shows expected behavior (pause or confirm exit — document actual behavior: ___________).

---

## B. Medical flag banner (`medical_flag = true`)

8. ☐ User with `medical_flag = true` sees a **persistent banner** at top during warm-up, active, and cool-down phases.
9. ☐ Banner uses **danger color token** (`#e85c5c` / theme `danger`).
10. ☐ Banner is **non-dismissible** (no close X, swipe away, or tap-to-hide).
11. ☐ Banner does **not** appear when `medical_flag = false`.
12. ☐ Banner text is localized (EN + AR) and readable in both RTL/LTR.
13. ☐ Banner does not overlap/obscure pause button or primary navigation controls.

---

## C. Active workout — happy path

14. ☐ Exercise **name** and **target muscle group** display correctly for current locale.
15. ☐ Stat row shows correct **sets**, **reps**, and **rest_seconds** from exercise record.
16. ☐ Video loads from Supabase Storage / CDN URL, loops continuously, and is **muted** by default.
17. ☐ Video aspect ratio is **16:9** for strength-type exercises and **1:1** for mobility/cardio-type (verify at least one of each).
18. ☐ Set checkboxes render one per set; tapping marks set **complete** and turns **green** (success token).
19. ☐ After completing a set (not the last set), **rest timer overlay** opens automatically.
20. ☐ Rest timer counts down from `rest_seconds` value shown on exercise.
21. ☐ **Skip** ends rest timer and returns to active set UI.
22. ☐ **+15s** adds 15 seconds to remaining rest time.
23. ☐ At **5 seconds** remaining: light haptic + soft beep fire once.
24. ☐ At **0 seconds**: stronger haptic + beep fire; timer closes and user can proceed.
25. ☐ **Previous** navigates to prior exercise (disabled or hidden on first exercise — verify: ___________).
26. ☐ **Next** navigates to next exercise (disabled or hidden on last exercise — verify: ___________).
27. ☐ **Swap Exercise** opens bottom sheet with alternative exercises.
28. ☐ Swap alternatives match **same target_muscle** and user **training_environment**.
29. ☐ Selecting a swap replaces current exercise and refreshes video/stats/checkboxes.
30. ☐ **Pause** (top-right) opens overlay with **Resume**, **End Workout**, **Restart**.
31. ☐ Resume closes overlay and preserves workout state.
32. ☐ End Workout prompts/confirms and exits (verify data saved or discarded per spec: ___________).
33. ☐ Restart resets current workout progress from exercise 1 / set 1.

---

## D. Edge cases & error handling

### Empty / minimal program data

34. ☐ Day program with **zero main exercises** after warm-up shows graceful empty state (no crash, clear message + exit CTA).
35. ☐ Warm-up/cool-down with **0 items** skips phase or shows empty state without crash (document behavior: ___________).

### Rest timer edge cases

36. ☐ Exercise with **`rest_seconds = 0`**: completing a set does **not** hang UI; no rest overlay (or instant dismiss).
37. ☐ Exercise with **`rest_seconds = 1`**: timer completes; alerts still behave without duplicate firing.
38. ☐ Rapidly tapping **Skip** and **+15s** does not crash or show negative countdown.

### Video failures

39. ☐ **Invalid / broken video URL**: placeholder or error state shown; workout remains usable (sets, nav, swap).
40. ☐ **Slow network**: loading indicator on video; no ANR; user can still pause or end workout.
41. ☐ **Airplane mode** after load: cached playback or graceful error (document: ___________).
42. ☐ Switching exercise via Next/Prev reloads video for new URL.

### Set completion edge cases

43. ☐ Tapping a completed set again does not break state (toggle off vs locked — document: ___________).
44. ☐ Completing **all sets** on last exercise advances to cool-down (not rest timer on non-existent next set).
45. ☐ Swap exercise mid-workout resets set checkboxes for the new exercise.

### Swap sheet edge cases

46. ☐ When **no alternatives** exist, bottom sheet shows empty state with helpful copy (not blank sheet).
47. ☐ Swap sheet scrolls when many alternatives; cards show title + prep time + cuisine/environment icon if applicable.

### Pause / lifecycle

48. ☐ App backgrounded during rest timer: timer state correct on resume (paused vs continues — document: ___________).
49. ☐ App killed mid-workout: relaunch behavior documented (restored vs lost — ___________).
50. ☐ Phone call / interruption overlay does not corrupt workout state.

---

## E. Feedback screen

51. ☐ All three options visible: **Easy**, **Just Right**, **Hard** (localized).
52. ☐ Selection required before continue (if enforced — verify: ___________).
53. ☐ Feedback persists to `checkins` / adaptive table (verify in Supabase or offline queue).
54. ☐ Submitting feedback twice in same session handled correctly.

---

## F. RTL / LTR layout verification

**Run sections F1–F6 in English (LTR) and Arabic (RTL).**

### F1. Global direction

55. ☐ EN: layout direction LTR; AR: layout direction RTL (from locale, not hardcoded).
56. ☐ Toggling language mid-flow updates direction on next screen rebuild (or note limitation: ___________).

### F2. Active workout screen

57. ☐ Exercise title and muscle text align correctly (start edge = reading direction).
58. ☐ Stat row (sets/reps/rest) order reads naturally in both locales.
59. ☐ Set checkboxes align on correct side; labels don’t clip in Arabic.
60. ☐ Prev/Next buttons: icon chevrons mirror in RTL (back points right, forward points left).
61. ☐ Pause button remains in consistent corner per design (note if top-start vs top-end: ___________).

### F3. Rest timer overlay

62. ☐ Countdown numerals centered; Skip / +15s buttons not truncated in Arabic.
63. ☐ Button order feels natural in RTL (primary action on start side).

### F4. Swap bottom sheet

64. ☐ Sheet handle and drag affordance correct in both directions.
65. ☐ Exercise card title wraps for long Arabic strings without overflow yellow/black stripes.
66. ☐ Prep time and icons align consistently in RTL.

### F5. Pause overlay

67. ☐ Resume / End Workout / Restart stack or list reads top-to-bottom correctly in AR.
68. ☐ Destructive action (End Workout) visually distinct in both locales.

### F6. Warm-up, cool-down, feedback, medical banner

69. ☐ Medical banner text wraps multiline in Arabic without overlapping video.
70. ☐ Warm-up/cool-down list items RTL-aligned; numbers/bullets on correct side.
71. ☐ Feedback option chips/buttons fit on narrow screens (iPhone SE / small Android) in both locales.

---

## G. Accessibility & devices

72. ☐ Touch targets ≥ 48×48 dp for set checkboxes, pause, skip, swap.
73. ☐ Text scales with system font size without breaking layout (test Large / XL).
74. ☐ Video area has semantic label for screen readers (exercise name announced).
75. ☐ Test on **iOS** physical device: ___________
76. ☐ Test on **Android** physical device: ___________

---

## H. Regression smoke (post-fix)

77. ☐ Full workout completion EN: warm-up → 3 exercises → cool-down → feedback → saved.
78. ☐ Full workout completion AR: same path, no LTR leaks.
79. ☐ `medical_flag=true` user completes workout with banner always visible.
80. ☐ Broken video URL workout still completable and feedback submittable.

---

## Sign-off

| Result | Count |
|--------|-------|
| Pass | |
| Fail | |
| Blocked | |
| N/A | |

**Release recommendation:** ☐ Ship ☐ Ship with known issues ☐ Block  
**Notes:**

_______________________________________________  
_______________________________________________

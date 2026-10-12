Act as a senior product designer + Flutter engineer on Vireo (branch ux-v2). The owner's #1 rule: the app must feel SIMPLE, never complicated, even though it has many features. Do a full simplicity pass. Change the UI/flows only; keep features intact. Work autonomously.

Principles (apply to every screen):
1. One screen = one main job + one primary button. Secondary actions go in a "⋯" menu or a "المزيد" section.
2. Progressive disclosure: show the essentials; details expand on tap ("عرض التفاصيل").
3. Max 5 cards above the fold on Home. Home order:
   - Daily Score + Steps hero;
   - "الخطوة الجاية" — ONE smart next-action card, e.g. "باقي 40 جم بروتين — سجّل غداك";
   - Today Plan (collapsed to the next 3 items + "عرض الكل");
   - Water quick card;
   - one native ad slot for free users.
   Everything else (social, vitality, recipes, body composition, reports) lives in its tab or under "المزيد".
4. Plain language: short Egyptian-friendly labels, no jargon (say "دهون" not "lipids"; explain TDEE as "حرقك اليومي"). Max ~8 words per subtitle.
5. Feature unlocking for new users: Day 1 shows Home, scan, water, steps, workout. Social, body-composition, vitality protocol and advanced programs appear from day 3 with a small "جديد" badge and a one-line intro. Users can open everything anytime from Settings → "كل المميزات".
6. Fewer taps:
   - log water = 1 tap;
   - log a meal photo = 2 taps;
   - start today's workout = 1 tap from Home;
   - check a plan item = 1 tap.
   Measure and fix anything slower.
7. Consistent patterns: the same card style, the same bottom-sheet style, the same back behaviour, the same empty-state style everywhere.
8. Settings: group into 5 sections (الحساب، الأهداف، التنبيهات، الخصوصية، الاشتراك). Hide developer/debug items in release builds.
9. Onboarding stays ≤ 60 s. Remove any question that is not used to personalise the plan.

Deliverables:
- docs/UX_SIMPLICITY.md: before/after tap counts per key task and the list of moved/hidden elements.
- Widget tests for the Home layout (≤ 5 primary cards for a new user) and for feature unlocking by day.
- Run `flutter gen-l10n` (10 locales). `flutter analyze` must report 0 errors. Run the affected tests with `--timeout 2m`. Then `flutter build apk --debug`.
- `git add -A && git commit -m "refactor(ux): simplicity pass — progressive disclosure, next-action card, fewer taps"`. Do not push.

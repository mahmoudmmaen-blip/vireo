# AGENTS.md — Vireo working environment (read this first, every task)

You are an engineer working INSIDE this folder. The folder is the source of truth; any model (Cursor, Antigravity/Gemini, Kimi, Claude) must follow the same rules.

## 1. Product
- **Vireo:** a Flutter fitness/nutrition/steps app for Egyptian & Arab users, men and women.
- **Stack:**
  - Flutter + Riverpod + Hive;
  - Supabase (Auth, Postgres, Edge Functions);
  - Gemini (vision), optional Claude (coach);
  - RevenueCat, AdMob.
- **Branch:** ux-v2. **Locales:** 10 ARB files. ar_EG is Egyptian Arabic and is the default for Arabic users.

## 2. Where things are
| What | Where |
|---|---|
| Task queue (do the next item only) | docs/prompts/QUEUE_ORDER.md |
| Task specs | docs/prompts/P*.md |
| What each task changed | docs/P*_CHANGES.md |
| Science & formulas | docs/SCIENCE.md, docs/ACCURACY.md |
| Store / legal | docs/store/*, docs/legal/* |
| Release steps | docs/RELEASE.md |

## 3. Hard rules (never break)
1. **Never** `git push`, `git reset`, `git clean`, `git checkout -- .`, rebase, or delete files/folders. The owner pushes.
2. **Never** read, print or create secrets: key.properties, *.jks, .env, API keys. AI keys live only in Supabase secrets.
3. Never read pub-cache files. Never wait more than 3 minutes on one command. Poll long builds.
4. Tests: use `pump(Duration)` instead of `pumpAndSettle` when anything animates. Bound every `tearDownAll` (10 s timeout). Run each test file with `--timeout 2m`.
5. Every task ends with: `flutter analyze` (0 errors), the task's tests, `flutter build apk --debug` (when the code changed), a docs/P*_CHANGES.md file, and ONE commit with the exact message from the spec.
6. No stubs and no fake numbers. Science comes from formulas with sources; the LLM only explains.
7. **Copy:**
   - warm, positive Egyptian Arabic;
   - gender-aware (ICU select);
   - never blame words (عقاب/فشلت/غلطت);
   - no Latin words in Arabic UI except brand names.
8. **Ads:** strict G-rated, no women imagery, no dating or apparel. Pro has no ads.
9. **Safety floors:**
   - kcal ≥ 1200 (women) / 1500 (men);
   - no deficit in pregnancy or under 18;
   - weight loss ≤ 1%/week;
   - fasting > 24 h needs a confirmation; max 72 h.
10. **Privacy:** cycle data stays local (encrypted Hive) unless the user opts in. Remove names and IDs from body reports.

## 4. Standard procedures
- **New screen:**
  - use VireoColors tokens only;
  - 48 dp tap targets;
  - empty, loading, error and offline states;
  - audit test at 360×640 ar_EG with textScale 1.3.
- **New strings:** add to all 10 ARB files, then run `flutter gen-l10n`.
- **Edge function change:** deploy with `npx supabase functions deploy <name> --use-api`, then check one real request in the logs.
- **When stuck** twice on the same error: write what you tried in the CHANGES doc, skip with a TODO test, and continue. Never loop forever.

## 5. Reporting
Finish with a 5-line summary:
1. what shipped;
2. tests passed/failed;
3. the build result;
4. the commit hash;
5. anything the owner must do.

Act as a Senior Flutter Engineer working on Vireo (branch ux-v2). Read lib/core/l10n, lib/core/services/locale_provider.dart, lib/app.dart and the onboarding flow first.

TASK: MULTI-LANGUAGE (10 languages incl. Egyptian and Gulf dialects)

1. Languages: English (en), Arabic Fusha (ar), Egyptian Arabic (ar_EG), Gulf Arabic (ar_SA), French (fr), Spanish (es), Turkish (tr), Urdu (ur), Hindi (hi), Indonesian (id).
- Create one ARB per locale in lib/core/l10n and translate ALL existing keys naturally (not word-for-word). Keep placeholders/plurals valid.
- ar_EG and ar_SA override only casual copy (greetings, coach tone, celebrations, empty states, microcopy) in the dialect; everything else falls back to ar. Examples: ar_EG "يلا بينا", "عاش!"; ar_SA "هلا والله", "كفو!".
- Run flutter gen-l10n. Add all locales to supportedLocales in app.dart. RTL for ar, ar_EG, ar_SA, ur.

2. Language picker:
- First launch (before onboarding): a clean full-screen picker with each language shown in its own name + flag-free icon, default = device language if supported, else English.
- Profile → Settings → Language: same list, applies instantly, persisted in Hive.
- The AI coach and meal-scan food names follow the selected language/dialect (pass the locale code to the Edge Functions that already accept `language`; treat ar_EG/ar_SA as Arabic with a dialect hint for the coach tone).

3. Small fix: the "finished a workout" celebration is missing — call CelebrationService.trigger with CelebrationType.workout when a workout is completed (once per day).

4. Do not change numbers/units logic. Numbers stay Western digits (0-9) in all languages.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary.
flutter analyze → 0 errors; flutter test green.
git add -A && git commit -m "feat(l10n): 10 languages incl. Egyptian & Gulf dialects, language picker"
Do not push.

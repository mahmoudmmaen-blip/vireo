Act as a Senior Flutter Engineer + growth designer working on Vireo (branch ux-v2). Rebuild onboarding so a new user reaches value in under 60 seconds. Reuse lib/core/ui and FadeSlideIn.

Screens (progress bar on top, back + skip on every screen):
1. Welcome: logo, one line value prop, "Start" (no sign-in here; anonymous session is created silently).
2. Goal: lose fat / build muscle / more energy / all (big cards).
3. Body: sex (male default, the app targets men), age, height, weight, target weight with wheel pickers; metric/imperial toggle.
4. Activity level + training place (home / gym / walking).
5. Health safety: the 12 DietSafetyCopy questions as quick yes/no chips (reuse diet_programs). "None of these" button.
6. Try it now: scan a sample plate (bundled demo image + bundled result, no API call) to show the review screen. Then "Scan your own" (optional).
7. Plan reveal with animation: daily calories, protein, water (personalized), steps, recommended diet program, expected weekly change. "Start my plan".
8. Notifications: explain then ask (only if the user accepts).
9. Soft paywall once (skippable).
- Save each answer immediately so leaving mid-way resumes. Keep existing onboarding providers/repositories; remove the old 6-step UI.
Analytics events for each step (onboarding_step_viewed / completed) to measure drop-off.
flutter analyze → 0 errors. git add -A && git commit -m "feat(onboarding): 60-second value-first onboarding". Do not push.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary. Never run git push, git reset, or delete files outside what the task needs. Commit at the end exactly as stated.

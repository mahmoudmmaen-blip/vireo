Act as a Senior Flutter engineer on Vireo (branch ux-v2). The owner tested the debug APK on a real Android phone and found two bugs. Fix both completely.

BUG 1 — red crash screen "Tried to modify a provider while the widget tree was building" after tapping Skip (عدّيها) on onboarding step 2 (goal).
Root cause (confirmed): lib/features/onboarding/steps/step_body_screen.dart initState() calls _syncDraft() → onboardingProvider.notifier.updateDraft() synchronously. Any navigation to the body step crashes, so the Continue button crashes too.
- Fix it: in initState, defer with WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _syncDraft(); }), or remove the call if it isn't needed.
- Then search ALL of lib/ for the same pattern. That means any provider write (`ref.read(x.notifier).<method>`, `state =`, `ref.invalidate`) called directly inside initState, build, didChangeDependencies or didUpdateWidget. Fix every occurrence the same way. List them in the final summary.

BUG 2 — the owner chose Egyptian Arabic (ar_EG), but onboarding shows English text. Only the Skip button is Arabic; the layout is RTL and the "?" lands at the wrong end.
Root cause: the onboarding steps use hard-coded English strings (e.g. step_goal_screen.dart titles/subtitles 'Lose Fat', 'What is your primary focus?').
- Move EVERY user-visible string in lib/features/onboarding/** (all 9 steps, the shell, the paywall step, dialogs, snackbars) into the ARB files with proper translations for all 10 locales (en, ar, ar_EG, ar_SA, fr, es, tr, ur, hi, id). ar_EG must be natural Egyptian dialect; ar/ar_SA Modern Standard / Saudi.
- Then grep the rest of lib/ for hard-coded English UI strings (Text('...'), title: '...', label: '...', hintText, SnackBar content, AlertDialog text) on the main screens: home, today plan, nutrition, water, steps/GPS walk, workouts, progress, profile/settings, paywall, social. Localize them the same way. Skip debug-only text.
- Verify the selected language persists after an app restart and applies on the very first onboarding screen.

Rules:
- Run flutter gen-l10n.
- flutter analyze must show 0 errors.
- Run the onboarding + l10n tests with --timeout 2m. No unbounded pumpAndSettle.
- Add a widget test that pumps StepBodyScreen inside ProviderScope and asserts no exception.
- Build `flutter build apk --debug` so the owner can reinstall: build/app/outputs/flutter-apk/app-debug.apk.
- git add -A && git commit -m "fix(device): provider-in-initState crash, full onboarding/app localization". Do not push.

Work autonomously. Do not ask me questions — pick the best option yourself and note your choices in the final summary.

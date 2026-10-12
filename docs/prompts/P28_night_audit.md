Act as a senior Flutter QA engineer on Vireo (branch ux-v2). Run an overnight quality audit and fix everything you find. Work autonomously. Never wait more than 3 minutes on a hanging command; skip it with a TODO.

1. Layout audit: find every possible RenderFlex overflow.
   - Search for Rows with Text that is not wrapped in Expanded/Flexible.
   - Search for fixed heights that hold text.
   - Write widget tests that pump the main screens (Home, Food, Walk, Workouts, Meal review, Quick log sheet, Profile, Settings, Paywall, Onboarding steps 1–9) at 360×640 and 412×915, in ar_EG and en with textScaleFactor 1.3, and assert no overflow exceptions.
   - Fix all of them.
2. Localization audit:
   - grep lib/ for hard-coded user-visible strings (Text('…'), labels, hints, SnackBars, dialogs, notification titles/bodies) and move them all to the ARB files for 10 locales.
   - Check that ar_EG strings are Egyptian dialect and that no key is missing in any locale.
3. Consistency:
   - one card radius, one spacing scale, one font family per script;
   - icons from one set;
   - no leftover debug banners or validator popups in release.
4. Performance:
   - remove unnecessary rebuilds (watch → select where heavy);
   - make sure images in lists are cached and resized;
   - startup work is deferred after first frame.
5. Crash safety:
   - wrap every async UI action in try/catch with a friendly Arabic error;
   - no unhandled futures;
   - null-safety warnings from `flutter analyze` → 0 warnings if feasible.
6. Write docs/AUDIT_REPORT.md with what was fixed (file paths) and anything left.
7. Run `flutter gen-l10n`, `flutter analyze` and the affected tests (`--timeout 2m`), then `flutter build apk --debug`. The build MUST finish.
8. Commit: `git add -A && git commit -m "chore(qa): overnight audit — overflows, l10n, consistency, perf"`. Do not push.

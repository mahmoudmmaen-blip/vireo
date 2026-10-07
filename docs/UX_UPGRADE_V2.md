# Vireo — UI/UX Upgrade v2

## What changed

### Design system (`lib/core/ui/`)
- `vireo_tokens.dart`: spacing (`VSpace`), radii (`VRadius`), motion (`VMotion`), semantic macro colours (`VMacro`), numeric type (`VType.number` with tabular figures).
- `pressable.dart`: `Pressable` (press-scale + haptic), `VireoCard`, `SectionHeader`, `VireoPill`.
- `ring_progress.dart`: animated `RingProgress` (gradient sweep, overflow lap) + `MacroBar`.
- `motion.dart`: `AnimatedCount` (count-up numbers) + `FadeSlideIn` (staggered entrance, play-once).
- Theme: FilledButton, BottomSheet (rounded + drag handle), Chip, page transitions.

### Navigation
- New bottom bar: Home · Workout · **[+]** · Nutrition · Progress.
- Centre **+** opens the **Quick Log** sheet (`lib/features/quick_log/`): AI meal scan (camera/gallery), +250 ml water (with Undo), weight, cardio, AI coach.
- Profile moved to the avatar on Home (Profile has a back button to Home). Android back on a secondary tab returns Home.

### Home ("Today")
- Custom header: date, time-based greeting, streak pill, language toggle, avatar.
- **Today hero**: calories-left ring + protein/carbs/fat bars, Goal · Eaten · Burned (Burned opens Cardio). Data from `todayNutritionProvider` (plan meals confirmed + AI-scanned meals + cardio).
- Quick actions: Scan · Water · Train · Coach.
- Workout hero with exercise count, estimated minutes and upcoming exercises.
- Steps + water rings (water has −/+ steppers).
- Week strip with localized day names (fixes the old Saturday/Sunday offset bug).
- Recovery ring card.
- **Today's log**: every meal eaten today; swipe AI-scanned meals to delete; empty state CTA to scan.
- Pull to refresh.

### AI Coach
- Empty state with avatar, live "kcal left / protein left" pills and 4 suggestion cards.
- Accent-gradient user bubbles, coach avatar, long-press to copy, retry inline.
- Pill composer with animated send button, "typing…" status, New chat (clears history).

## Localization
53 new keys prefixed `ux*` were added to `app_en.arb` / `app_ar.arb` **and** to the committed generated files, so the app compiles as-is. Running `flutter gen-l10n` regenerates the same output.

## Known follow-ups
- `homeDashboardProvider` still uses placeholder steps (4200), streak (3) and weekly completion (4). Wire to `walkingTrackerProvider` / workout history.
- `WaterTrackerCard` and `AiCoachFab` are no longer used on Home (kept for now).

# Vireo

Men's fitness and vitality app for **iOS** and **Android** (Flutter).

## §2.1 Foundation stack

| Layer | Package / path |
|-------|----------------|
| State | [Riverpod](https://riverpod.dev) — `ProviderScope` in `lib/main.dart` |
| Offline storage | [Hive](https://docs.hivedb.dev) — `lib/core/services/hive_service.dart` |
| Backend | [Supabase](https://supabase.com) — auth, Postgres, storage — `lib/core/services/supabase_service.dart` |
| Subscriptions | [RevenueCat](https://www.revenuecat.com) — `lib/core/services/revenue_cat_service.dart` |
| Localization | `intl` + ARB — `lib/core/l10n/` (EN + AR) |
| Theme | Dark-only `ThemeData` + `VireoColors` extension — `lib/core/theme/` |

### Folder structure

```
lib/
├── main.dart
├── app.dart
├── core/          # theme, widgets, services, l10n, config, utils
├── data/          # models, repositories
└── features/
    ├── auth/
    ├── home/
    ├── onboarding/
    ├── workout/
    ├── nutrition/
    ├── progress/
    ├── profile/
    ├── subscription/
    └── walking/
```

Text direction is resolved from locale via `Directionality` in `lib/app.dart` — **never hardcoded RTL**.

### Design tokens (`VireoColors`)

| Token | Hex |
|-------|-----|
| background | `#12151a` |
| surface | `#1a1f26` |
| surface-raised | `#212832` |
| ember (primary) | `#e8763c` |
| gold | `#c9a24b` |
| success | `#5fae7a` |
| danger | `#e85c5c` |
| text | `#eef0f3` |
| text-mute | `#8b94a0` |

### Run locally

```bash
flutter pub get
flutter gen-l10n
flutter run \
  --dart-define=SUPABASE_URL=your_url \
  --dart-define=SUPABASE_ANON_KEY=your_anon_key \
  --dart-define=REVENUECAT_APPLE_API_KEY=your_apple_key \
  --dart-define=REVENUECAT_GOOGLE_API_KEY=your_google_key
```

### Tests

```bash
flutter test
dart analyze lib
```

Spec reference: [`vireo-ui-ux-specs.md`](vireo-ui-ux-specs.md)

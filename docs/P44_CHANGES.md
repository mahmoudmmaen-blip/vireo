# P44 — Revert package name to com.vireofit.app

## Why
P43 incorrectly renamed the Android applicationId to `com.vireoapp.fitness`. The app is already registered on Google Play as `com.vireofit.app`; that ID cannot change on an existing listing.

## What changed
- `android/app/build.gradle.kts`: `namespace` and `applicationId` → `com.vireofit.app`
- `AndroidManifest.xml` auth deep-link scheme → `com.vireofit.app`
- Kotlin sources moved back to `com/vireofit/app/` with matching `package` declarations
- Dart: widget app group + outdoor map user-agent package restored
- Docs: `RELEASE.md`, `REVIEWER_NOTES.md` package references restored

## Verify
- `applicationId` in release AAB must be `com.vireofit.app`
- Supabase redirect URI remains `com.vireofit.app://login-callback`

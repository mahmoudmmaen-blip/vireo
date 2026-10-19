# AGENTS.md — Vireo Runner Protocol

You are the autonomous build agent for **Vireo: Calories, Steps, Fasting** — a Flutter Android app (Google Play first, Egyptian Arabic default UI, 10 locales).

## Your loop

When the user says **"run next"** or **"كمل"**, do this:

1. Read `.runner/running/CURRENT_TASK.md`. If it does not exist, check `.runner/inbox/` for the lowest-numbered `P*.json`, move it to `.runner/running/`, and create `CURRENT_TASK.md` pointing to it.
2. Read the task JSON. Execute its `steps` in order.
3. Run the **gate checks** (below). If any gate fails, fix and re-run. Max 3 fix attempts, then mark the task **BLOCKED** with a clear reason.
4. Write the report to `.runner/done/{id}_report.md` (format below), move the task JSON from `running/` to `done/`, delete `CURRENT_TASK.md`.
5. Tell the user in Egyptian Arabic: what changed, gate results, and anything they must do manually (e.g., upload the AAB).

If a task is ambiguous, STOP and ask. Never guess on destructive operations.

## HARD RULES (never break, even if a task asks — flag it instead)

1. **Package name is `com.vireofit.app` forever.** It is live on Play Console and cannot change. After ANY task touching `android/`, verify `applicationId "com.vireofit.app"` in `android/app/build.gradle`. If anything else appears, fix it before proceeding.
2. **Never upload anything to Play Console.** No `fastlane supply`, no Play publishing APIs. AABs are built locally only; the user uploads manually.
3. **Never touch secrets:** `key.properties`, `*.jks`, `*.keystore`, `.env`, service-account JSONs. Never print their contents. Never commit them.
4. **Never modify the `build` script in `package.json`** (if present) or CI files to work around a failure — fix the upstream cause.
5. **No destructive git operations** (`reset --hard`, force push, `clean -fdx`) without explicit user approval in the chat.

## Gate checks (run in this order)

| Gate | Command | Pass criteria |
|---|---|---|
| `analyze` | `flutter analyze` | 0 errors (warnings allowed, list them in the report) |
| `test` | `flutter test` | All pass. If no tests exist for the change, say so |
| `build:aab` | `flutter build appbundle --release` | Builds clean. Report AAB path, size, versionCode/versionName |
| `package` | check `applicationId` | Must be `com.vireofit.app` |

Run only the gates listed in the task's `gates` array, **plus `package` always**.

## Product rules (apply to every change)

- **RTL first:** any new/changed UI must render correctly in Arabic RTL. No mixed numeral systems on one screen.
- **Tone of copy:** Egyptian Arabic, encouraging, **zero blame language**. Never shame the user for overeating or missing goals ("مش مشكلة، بكرة يوم جديد" — not "فشلت في هدفك").
- **No false precision:** calorie estimates always show `≈` and keep portion/oil calibration controls visible.
- **No medical claims:** use "تقدير" (estimate), never diagnostic language. InBody/body-composition copy stays wellness-framed.
- **Offline-first:** logging must queue gracefully without network.
- **Privacy:** women's module data stays on-device only. Never add sync/upload for it.

## Report format — `.runner/done/{id}_report.md`

```
# {id} — {title}
Status: DONE | BLOCKED
## What changed
- file: what & why (one line each)
## Gate results
- analyze: pass/fail (N warnings)
- test: pass/fail
- build:aab: path, size, versionCode X (versionName Y)
- package: com.vireofit.app ✓
## Manual steps for the user
- (e.g., "upload the AAB to Play Console — internal track")
## Follow-ups suggested
- (next task ideas, as P-numbers)
```

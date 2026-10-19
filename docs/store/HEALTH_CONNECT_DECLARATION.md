# Health Connect Declaration & Permission Rationale

Every `android.permission.health.READ_*` declared in `AndroidManifest.xml` maps to a user-visible feature that reads that type via the `health` package. Unused types were removed from the manifest and from request lists.

**Privacy rationale activity:** `MainActivity` handles `androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE` / `VIEW_PERMISSION_USAGE`. In-app copy for the grant screen is `healthConnectWatchTitle` / `healthConnectWatchBody` (see ARB files) and matches this table.

---

## Permission → feature table

| Permission | HealthDataType(s) | Feature / screen | Why needed |
|---|---|---|---|
| `READ_STEPS` | `STEPS` | Home step journey; Walk tab; `HealthStepsService`; Health Hub | Daily step progress, active energy, Today Plan goals |
| `WRITE_STEPS` | `STEPS` | Reserved for future pedometer→HC mirror; auth requested with Steps RW | Keep step history consistent across apps the user links |
| `READ_HEART_RATE` | `HEART_RATE` | Health Hub (`HealthHubScreen`) | Show today’s heart rate and 7-day trend from wearables |
| `READ_RESTING_HEART_RATE` | `RESTING_HEART_RATE` | Health Hub | Resting HR card for recovery context |
| `READ_HEART_RATE_VARIABILITY` | `HEART_RATE_VARIABILITY_RMSSD` | Health Hub + stress-from-HRV card | HRV trend used only as a wellness stress hint (not medical) |
| `READ_OXYGEN_SATURATION` | `BLOOD_OXYGEN` | Health Hub | SpO₂ card when the watch provides it |
| `READ_SLEEP` | `SLEEP_SESSION` | Health Hub; sleep goal / manual sleep fallback | Session duration for recovery / Today Plan sleep goal |
| `READ_WEIGHT` | `WEIGHT` | Body composition (`BodyCompHealthSync`); Health Hub | Sync smart-scale weight into body progress |
| `WRITE_WEIGHT` | `WEIGHT` | Progress weight log → `HealthConnectWriteService` | Write user-logged weight back so other apps stay in sync |
| `READ_BODY_FAT` | `BODY_FAT_PERCENTAGE` | Body composition sync | Import body-fat % from scales / connected apps |
| `READ_LEAN_BODY_MASS` | `LEAN_BODY_MASS` | Body composition sync | Lean mass for protein targets and muscle tracking |
| `READ_EXERCISE` | `WORKOUT` | Health Hub | Show recent workout sessions from Health Connect |
| `WRITE_EXERCISE` | `WORKOUT` | Outdoor walk/run finish → `HealthConnectWriteService` | Share Vireo sessions with Health Connect |

**Not declared:** `READ_DISTANCE`, `ACCESS_BACKGROUND_LOCATION`.

**Denials:** Steps fall back to the on-device pedometer with copy «من غير الإذن هنستخدم عداد الموبايل بس». Body metrics fall back to InBody OCR or manual entry. Sleep falls back to the in-app manual sleep logger. Health Hub shows an empty state with a grant CTA. Weight/workout HC writes are best-effort and never block local logging.

---

## Foreground service types (Play declaration)

Declared on `com.pravera.flutter_foreground_task.service.ForegroundService` as `health|dataSync`.

| Type | Kept? | One-line justification |
|---|---|---|
| `FOREGROUND_SERVICE_HEALTH` | Yes | Keeps the pedometer step counter accurate while the user starts “live steps” and the app is backgrounded. |
| `FOREGROUND_SERVICE_DATA_SYNC` | Yes | Syncs step baseline / offset between the FGS isolate and the UI without requiring a full restart. |
| `FOREGROUND_SERVICE_LOCATION` | **Removed** | Outdoor GPS uses while-in-use location only (no location FGS). GPS run UI is feature-flagged `gpsRunScreen=false`. |

**Background location:** not declared and not used (`ACCESS_BACKGROUND_LOCATION` absent).

---

## Camera & microphone

| Permission | When requested | Rationale (ARB) |
|---|---|---|
| `CAMERA` | Moment of use only (`SensitivePermissionGate.ensureCamera`) | `cameraPermissionRationaleTitle` / `Body` — meal, InBody, progress photos |
| `RECORD_AUDIO` | Moment of use only (`ensureMicrophone` before voice meal log) | `microphonePermissionRationaleTitle` / `Body` — on-device speech-to-text |

Neither is requested at app startup.

---

## Policy compliance

1. No medical claims — vitals are fitness/wellness display only.
2. Health Connect data is never sold or used for ads.
3. Cycle data is local-only (encrypted Hive) and unrelated to Health Connect.

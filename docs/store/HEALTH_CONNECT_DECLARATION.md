# Health Connect Declaration & Permission Rationale

This document details every Health Connect permission requested by Vireo, along with the precise user-facing rationale and technical implementation details required for Google Play policy approval.

---

## Declared Permissions

### 1. `READ_STEPS`
- **Permission Name:** `android.permission.health.READ_STEPS`
- **User-Facing Rationale:**  
  "Vireo reads your daily step count from Health Connect to display your daily walking progress, compute active calorie deficits, and sync with your Today Plan goals."
- **Why It is Essential:**  
  Users expect automatic tracking of their daily walking activity without having to leave the app running all day.
- **Handling Denials:**  
  If the user denies permission, Vireo falls back seamlessly to the device pedometer or manual step logging.

### 2. `READ_DISTANCE` (Optional)
- **Permission Name:** `android.permission.health.READ_DISTANCE`
- **User-Facing Rationale:**  
  "Used to calculate accurate walking distances and walking energy expenditure."
- **Handling Denials:**  
  Estimated based on step count and user height.

### 3. `READ_WEIGHT`
- **Permission Name:** `android.permission.health.READ_WEIGHT`
- **User-Facing Rationale:**  
  "Used to sync your body weight logs with Health Connect, track weight progress over time, and adjust your personalized calorie and macro targets."
- **Why It is Essential:**  
  Permits seamless body weight tracking and calibration of daily metabolic burn.
- **Handling Denials:**  
  User can manually log weight entries directly inside Vireo.

### 4. `READ_BODY_FAT`
- **Permission Name:** `android.permission.health.READ_BODY_FAT`
- **User-Facing Rationale:**  
  "Used to import body fat percentage from smart scales and InBody body composition scans."
- **Why It is Essential:**  
  Provides accurate body fat tracking and fine-tunes lean mass nutrition recommendations without manual entry.
- **Handling Denials:**  
  Falls back to manual entry or in-app InBody OCR scan parsing.

### 5. `READ_LEAN_BODY_MASS`
- **Permission Name:** `android.permission.health.READ_LEAN_BODY_MASS`
- **User-Facing Rationale:**  
  "Used to read lean body mass and skeletal muscle mass from smart scales or Health Connect-connected apps."
- **Why It is Essential:**  
  Essential for calculating protein intake goals (e.g. 1.6 - 2.2g per kg of lean mass) and monitoring muscle preservation during fat-loss deficits.
- **Handling Denials:**  
  Falls back to estimating lean body mass from height/weight or manual InBody report entry.

### 6. `READ_SLEEP`
- **Permission Name:** `android.permission.health.READ_SLEEP`
- **Health Data Type:** `SLEEP_SESSION`
- **User-Facing Rationale:**  
  "Vireo reads your sleep session duration to track restorative recovery, automatically complete your Today Plan sleep goal (≥7 hours), and correlate sleep quality with athletic vitality."
- **Why It is Essential:**  
  Recovery and quality sleep are vital for muscle protein synthesis and metabolic regulation. Automatically reading sleep sessions removes logging friction for wearable and health tracker users.
- **Handling Denials:**  
  If the user denies permission, Vireo falls back seamlessly to an in-app manual sleep logger (bedtime, wake-time, and 1–5 quality rating).

---

## Policy Compliance Check
1. **No Medical Claims:** Steps data is used strictly for fitness and habit tracking, with no medical diagnosis or health claims.
2. **No Data Re-sale:** Health Connect data is never transferred to data brokers, ad networks, or third parties.
3. **Data Protection:** All health data remains private to the user under Supabase Row Level Security (RLS).

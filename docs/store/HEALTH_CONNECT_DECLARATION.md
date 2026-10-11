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

---

## Policy Compliance Check
1. **No Medical Claims:** Steps data is used strictly for fitness and habit tracking, with no medical diagnosis or health claims.
2. **No Data Re-sale:** Health Connect data is never transferred to data brokers, ad networks, or third parties.
3. **Data Protection:** All health data remains private to the user under Supabase Row Level Security (RLS).

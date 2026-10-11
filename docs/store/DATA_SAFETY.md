# Google Play Data Safety Form Answers for Vireo

This document outlines the exact responses required for the Google Play Data Safety declaration, based directly on the actual Vireo source code.

## 1. Overview
- **Does your app collect or share any of the required user data types?** Yes.
- **Is all of the user data collected by your app encrypted in transit?** Yes, via HTTPS/TLS.
- **Do you provide a way for users to request that their data is deleted?** Yes, both directly in the app (in &le; 3 taps) and via public web URL (`https://vireo.app/legal/account_deletion.html`).

---

## 2. Data Types Collected & Shared

### Location
- **Data Type:** Approximate Location & Precise Location
- **Collected:** Yes (during outdoor GPS walking/running workouts only).
- **Shared:** No.
- **Background Location:** **NO**. Vireo uses foreground service only during active tracking.
- **Ephemeral:** Yes, converted to workout routes saved in the user's private database.
- **Purpose:** App functionality (recording workout route, distance, and pace).

### Health & Fitness
- **Data Type:** Health info (weight, body measurements) & Fitness info (steps, workout exercise records).
- **Collected:** Yes.
- **Shared:** No. (Only steps and streak are optionally shared in user-initiated friend challenges; never weight or health metrics).
- **Purpose:** App functionality, personal wellness analytics.
- **Health Connect:** Step count data read with user consent.

### Photos and Videos
- **Data Type:** Photos (food scans and optional progress photos).
- **Collected:** Yes.
- **Shared:** No.
- **Purpose:** App functionality (AI food identification via Google Gemini API).
- **Ephemeral Processing:** Food photos are analyzed ephemerally to estimate ingredients and macros. Progress photos are never backed up unless user opts in.

### Personal Info
- **Data Type:** Email address & User IDs.
- **Collected:** Yes (via Supabase authentication).
- **Shared:** No.
- **Purpose:** Account management, secure cross-device sync.

### Financial Info
- **Data Type:** Purchase history.
- **Collected:** Yes (via RevenueCat / Google Play Billing).
- **Shared:** No.
- **Purpose:** Subscription entitlement and premium feature unlocking. Credit card data is never handled directly.

### App Info & Performance
- **Data Type:** Crash logs and diagnostics.
- **Collected:** Yes (via Sentry, only when configured).
- **Shared:** No.
- **Purpose:** Analytics, diagnostics, and app performance. Free of personal/health data.

---

## 3. Data Deletion Mechanism
- In-app: `Profile -> Settings -> Delete Account` (immediate hard cascade delete).
- Public Web URL: `https://vireo.app/legal/account_deletion.html`.

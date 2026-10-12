Act as a senior Flutter engineer + product designer on Vireo (branch ux-v2). Build three features. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command.

## 1. BARCODE SCANNER (production quality)
- Use `mobile_scanner` with a full-screen scanner, a torch toggle, and haptic feedback when a code is found.
- Lookup order:
  1. local cache;
  2. the bundled Egyptian food DB (if it holds barcodes);
  3. the Open Food Facts API (world + Egypt);
  4. if not found, "صوّر الملصق الغذائي" → send the nutrition-label photo to Gemini to read the label → save it to the local cache as a user product.
- The result goes to the same MFP-style summary/review screen with servings (per 100 g / per piece / per pack).

## 2. WEEKLY WRAPPED 🎁 (shareable)
- Every Friday evening (local), a notification says "ملخص أسبوعك جاهز".
- The story-style screens (swipe) cover:
  - total steps with a fun comparison ("مشيت 52 ألف خطوة = 3 مرات طول الهرم الأكبر 🏛️");
  - kcal burned ≈ g fat;
  - best day;
  - workouts done;
  - protein-goal days;
  - streak;
  - weight trend.
- A share card (1080×1920 PNG) with the Vireo logo is shared through `share_plus` to WhatsApp, Instagram stories and others. It never includes meals or weight unless the user toggles that on.
- Fun comparisons are localized per locale (Egypt: الهرم، كوبري قصر النيل; Gulf: برج خليفة; general: ملاعب كورة).

## 3. PROGRESS PHOTOS BEFORE/AFTER SLIDER
- In "أنا → التقدم":
  - pick two dates' photos (front/side/back);
  - a draggable compare slider;
  - a side-by-side mode;
  - auto-align guide when taking a new photo (ghost overlay of the last one).
- Privacy:
  - photos stay on the device unless the user opts in to cloud backup;
  - export the comparison as an image with an optional blur on the face.

## Finish
- Run `flutter gen-l10n` (10 locales) and `flutter analyze` (0 errors).
- Run the affected tests with `--timeout 2m`.
- Run `flutter build apk --debug`; it must finish.
- Write docs/P30_CHANGES.md.
- `git add -A && git commit -m "feat(engage): barcode scanner, weekly wrapped share, progress photo compare"`. Do not push.

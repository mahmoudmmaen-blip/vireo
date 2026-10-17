# Vireo — Product decisions (2026-10-16)

Owner: Claude, after a review with Gemini Pro and Kimi K3 (2 rounds). Where the two disagreed, the reason for the call is given.

## Positioning
**The moat:** photo and text logging that understands Egyptian/Gulf food and portions, plus Ramadan done right. Everything else supports this one loop:

> scan → calories → mascot fills → burn balance → share

## Pricing (owner sets these in Play Console / RevenueCat)

| Market | Monthly | Yearly (hero, 7-day trial) |
|---|---|---|
| Egypt | 79 EGP | 499 EGP |
| KSA | 29.99 SAR | 119.99 SAR |
| UAE | 29.99 AED | 119.99 AED |
| Kuwait/Qatar/Bahrain/Oman | Play auto-convert from the SAR tier | |

- **No lifetime plan** (owner decision, 2026-10-16). Only monthly and yearly.

- **Egypt:** both reviewers converged on ≈499 EGP/yr (≈ $10). That sits at the Egyptian willingness-to-pay ceiling.
- **Gulf:** 119.99 yearly is under Yazio (AED 129.99) and well under MyFitnessPal. Monthly is 29.99, not 19.99, to push users to yearly.
- **Trial:** 7 days on the yearly plan only.
- **Ramadan offer:** yearly at 50% off (249 EGP / 59.99 SAR / 59.99 AED). It runs 2 weeks before Ramadan until Eid.
  - Kimi's view won here: it builds a recurring Ramadan renewal cohort. A lifetime plan is not offered at all.

## Free vs Pro
- **Free:**
  - 3 AI photo scans a day (5 a day in the first week);
  - unlimited text/voice/barcode/manual logging;
  - calories/macros, weight, water;
  - fasting + Ramadan mode;
  - steps with the default scenes;
  - the women's module;
  - G-rated ads (no interstitial after logging, no ads on the women's or Ramadan screens).
- **Pro:**
  - unlimited scans (fair-use cap of 40 a day);
  - the adaptive coach recovery plans;
  - the AI coach chat (30 messages a day);
  - all scene packs and seasonal mascots;
  - advanced fasting plans;
  - the full Burn Balance and "بصمتك" history;
  - no ads.
- **Scans compromise:** Gemini said 3 total, Kimi said 5 a day forever. We chose 3 a day: it keeps the moat usable daily and keeps API cost per free user bounded.
- **Never paywalled:** Ramadan mode, barcode, the women's module.

## Paywall
- **Soft paywall:** dismissible, shown right after the first successful scan at the end of onboarding.
- **Hard gate:** at the daily scan limit.
- This is a compromise between "Day-0 hard paywall" (Gemini) and "Day-2 only" (Kimi).

## Voice
- No paid ASR. "اكتب أو قول أكلك" uses the Android system speech-to-text and our existing text-resolution pipeline. Small effort, and it covers Gemini's #1 point.

## AI coach chat
- Pro only. Free users get quick-action chips.
- Strict guardrails: no diagnosis or medication, safety floors enforced, eating-disorder risk handled.

## Scope for v1
- **Hidden behind flags:** the GPS run screen and the men's vitality module.
- **Kept:** InBody/body and the women's module (local-only).

## Pre-launch adds (P40)
1. Repeat meals.
2. Text/voice logging.
3. A visible portion/oil calibration.
4. Family-plate share.
5. Prayer-time fasting (offline).
6. Water tracking in Ramadan.
7. A home-screen widget.
8. The WhatsApp share card.
9. Scan limits plus a cost guard.
10. The paywall plus cancel UX.
11. "حقائق أكلك" content.
12. 100+ swaps.
13. Ramadan content.
14. The notification plan.
15. Low-end performance and app size.

## Later (post-launch)
- Gulf barcode seeding (Almarai, Nada, Panda/Lulu private labels) from Open Food Facts plus user scans.
- Local payment options beyond Play Billing.
- Wear OS, social and community features: skip.

## Launch timing
Ramadan 2027 starts around 8 Feb 2027. To get there:
1. Closed testing (12 testers × 14 days) should start by early December.
2. Production by mid-January.
3. Store listing and screenshots refreshed for Ramadan 2 weeks before it starts.

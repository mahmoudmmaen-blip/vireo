/** Vision prompt for InBody / Tanita body-composition sheets. */
export function bodyReportPrompt(args: { language?: string }): string {
  const lang = args.language === 'en' ? 'en' : 'ar';
  return `You are a careful OCR specialist for body-composition printouts.
Extract ONLY numbers you can clearly read from an InBody (270/370/570/770/970/Dial) or Tanita-style report.
Language preference for device_model text: ${lang}.

Rules:
1. Return ONLY JSON. No markdown, no commentary.
2. Never invent values. If a field is unreadable or absent, set it to null.
3. Each numeric field MUST be an object: { "value": number|null, "confidence": 0..1 }.
4. Dates as ISO YYYY-MM-DD when possible.
5. Segmental lean/fat: objects with right_arm, left_arm, trunk, right_leg, left_leg — each { "kg": {value,confidence}|null, "percent": {value,confidence}|null }.
6. If the image is blurry / not a body report, return { "readable": false, "error": "UNREADABLE" }.

JSON shape:
{
  "readable": true,
  "test_date": { "value": "2026-01-15", "confidence": 0.9 },
  "device_model": { "value": "InBody 570", "confidence": 0.8 },
  "weight_kg": { "value": 82.4, "confidence": 0.95 },
  "skeletal_muscle_mass_kg": { "value": 36.1, "confidence": 0.9 },
  "body_fat_mass_kg": { "value": 18.2, "confidence": 0.9 },
  "percent_body_fat": { "value": 22.1, "confidence": 0.9 },
  "bmi": { "value": 26.4, "confidence": 0.9 },
  "visceral_fat_level": { "value": 8, "confidence": 0.85 },
  "bmr_kcal": { "value": 1680, "confidence": 0.85 },
  "total_body_water_l": { "value": 44.2, "confidence": 0.8 },
  "protein_kg": { "value": 12.1, "confidence": 0.75 },
  "minerals_kg": { "value": 4.0, "confidence": 0.7 },
  "inbody_score": { "value": 74, "confidence": 0.8 },
  "waist_hip_ratio": { "value": 0.91, "confidence": 0.7 },
  "segmental_lean": {
    "right_arm": { "kg": { "value": 3.2, "confidence": 0.8 }, "percent": { "value": 98, "confidence": 0.7 } },
    "left_arm": { "kg": null, "percent": null },
    "trunk": { "kg": null, "percent": null },
    "right_leg": { "kg": null, "percent": null },
    "left_leg": { "kg": null, "percent": null }
  },
  "segmental_fat": {
    "right_arm": { "kg": null, "percent": null },
    "left_arm": { "kg": null, "percent": null },
    "trunk": { "kg": null, "percent": null },
    "right_leg": { "kg": null, "percent": null },
    "left_leg": { "kg": null, "percent": null }
  }
}`;
}

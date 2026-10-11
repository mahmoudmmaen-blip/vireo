/**
 * Port of VireoAiPrompts.coachSystemPrompt + coachContextBlock — keep in sync with Dart.
 */

export const coachSystemPrompt = `You are "Vireo Coach", a personal fitness and nutrition coach integrated inside the Vireo app.

Tone & Persona Rules:
- Speak in clear, modern, encouraging Arabic (عربي فصحي مبسط أو لهجة بيضاء راقية).
- Be direct, professional, and practical — you are a nutrition and fitness coach, not a generic chatbot.
- Keep responses strictly short: maximum 4 bullet points or 1 concise paragraph.
- ALWAYS connect your answer to the user's remaining calories and protein goals for today.
- Avoid generic advice; give exact food quantities (in grams/spoons) and actionable tips.
- When the user reports food eaten (e.g. "أكلت 800 سعرة"), subtract mentally from remaining budget and suggest the next meal within what is left.`;

export function coachContextBlock(args: {
  remainingCalories: number;
  remainingProtein: number;
  targetCalories: number;
  targetProtein: number;
  currentWeight: number;
  goal: string;
  inbodySummary?: string;
}): string {
  const inbody = args.inbodySummary?.trim()
    ? `\n- Body composition: ${args.inbodySummary.trim()}`
    : '';
  return `Live user context (use these exact numbers in every answer):
- Remaining calories today: ${args.remainingCalories} kcal
- Remaining protein today: ${Math.round(args.remainingProtein)} g
- Daily calorie target: ${args.targetCalories} kcal
- Daily protein target: ${args.targetProtein} g
- Current weight: ${Number(args.currentWeight).toFixed(1)} kg
- Fitness goal: ${args.goal}${inbody}`;
}

export function buildCoachSystemInstruction(
  args: Parameters<typeof coachContextBlock>[0] & { language?: string },
): string {
  const lang =
    args.language === 'en'
      ? '\nRespond in clear, concise English unless the user writes in Arabic.'
      : '\nRespond in Arabic (عربي فصحي مبسط أو لهجة بيضاء راقية) unless the user writes in English.';
  return `${coachSystemPrompt}\n\n${coachContextBlock(args)}${lang}`;
}

Act as a senior Flutter engineer + nutrition product designer on Vireo (branch ux-v2). Build two features. Work autonomously. No stubs. Never wait more than 3 minutes on a hanging command.

## 1. RAMADAN MODE 🌙
- Toggle in Settings ("وضع رمضان"). Auto-suggest it when the Hijri month is Ramadan (use the `hijri` package).
- Prayer times for suhoor and iftar:
  - compute locally from the user's city/coordinates with the `adhan` package (Egyptian General Authority method by default; user-selectable);
  - no network needed.
- While Ramadan mode is on:
  - Home shows an "إفطار بعد ⏳ 02:14" countdown card and the suhoor time.
  - Meal slots become: سحور / فطار (iftar) / سناك بعد الفطار. Calories and protein are split across them.
  - Water goal is distributed between iftar and suhoor (e.g. 8 cups: 2 at iftar, 4 during the evening, 2 at suhoor), with reminders only in non-fasting hours.
  - Workout timing tip: best 60–90 min after iftar, or light walking before iftar. Today Plan adjusts.
  - The meal plan suggests Ramadan dishes per cuisine (Egyptian: شوربة عدس، فول، سلطة، فراخ مشوية، قطايف باعتدال…) with honest calories.
  - No reminders or ads interstitials during fasting hours that mention food or water.
- Unit tests:
  - schedule split;
  - prayer-time based countdown (mock clock);
  - water distribution.

## 2. EGYPTIAN FOOD DATABASE + RESTAURANTS 🇪🇬
- Add a local, bundled food database (JSON asset, ≥ 400 items) of Egyptian and Arab foods with realistic portion units and nutrition per portion and per 100 g. Cover:
  - Breakfast: فول مدمس، طعمية، بيض، جبنة قريش/رومي/بيضاء، عيش بلدي/شامي/فينو، بليلة.
  - Lunch/dinner: كشري، محشي، ملوخية، بامية، مسقعة، فتة، رز بالشعرية، مكرونة بشاميل، فراخ/لحمة/سمك مشوي ومقلي، كفتة، حواوشي، شاورما.
  - Snacks/desserts: بسبوسة، كنافة، قطايف، أرز باللبن، مهلبية، فول سوداني، لب.
  - Drinks: شاي بسكر، قهوة تركي، عصير قصب، سوبيا، كركديه.
  - Gulf/Levant basics: كبسة، مندي، حمص، فلافل، تبولة.
- Restaurant chains common in Egypt/Gulf with their popular meals (approximate, labeled "تقديري"): مؤمن، الطازج، أبو طارق، التابعي، كوك دوور، KFC، ماكدونالدز، البيك، هرفي.
- Search screen: instant offline search with Arabic normalisation (أ/إ/ا، ة/ه، ى/ي) and English names. Recent items and favourites.
- The AI meal analysis prefers matching items from this DB for portions and nutrition (send the matched candidates to the Edge Function or post-match on the client). Show "من قاعدة البيانات" vs "تقدير الذكاء الاصطناعي".
- Unit tests: Arabic normalisation search, portion conversion.

## Finish
- Run `flutter gen-l10n` (10 locales) and `flutter analyze` (0 errors).
- Run the affected tests with `--timeout 2m`.
- Run `flutter build apk --debug`. It must finish.
- Write docs/P29_CHANGES.md.
- `git add -A && git commit -m "feat(ramadan+fooddb): Ramadan mode and Egyptian/Arab food database with restaurants"`. Do not push.

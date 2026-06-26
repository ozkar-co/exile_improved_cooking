# exile_improved_cooking

Improves food progression for Exile.

Features:
- Soup gets a 20 percent bonus to satiety and energy.
- Includes the clay smoker and its recipes.
- Smoker now has safer cooking behavior:
	- Wider workable temperature range.
	- Items cannot be removed while still raw.
	- Cooking time scales from original bake data when available.
	- Very low (non-zero) burn chance at high heat.
- Adds a whole egg bread chain:
	- Sari -> Sari seed -> Sari Flour
	- Pegasum Egg + Oil + Sari flour -> Unfermented dough.
	- Dough ferments in ambient conditions (no rain/water nearby, moderate temperature).
	- Fermented dough splits into 6 unbaked breads, then bakes/burns via the normal cooking system.
- Bitter Maraka Flour uses an improved high-visibility texture.
- Adds the Bug Meat Pastry chain (late-game premium food):
	- Phase 1: 48× small invertebrate carcasses yield 1× bug meat paste (mortar and pestle).
	- Phase 2: Raw paste is edible but unsafe (90% food poisoning). Cook it over a fire or in the smoker to get cooked paste (168 hunger).
	- Phase 3: 1× cooked paste + 2× sari flour + 1× mashed anperla yield 6× unbaked bug meat pastries (mortar and pestle).
	- Phase 4: Bake pastries at 160°C for 14 ticks. Open-fire baking carries a 0.2% chance per hot tick to rot; the smoker avoids rotting but can still burn on overheat.

Nutrition (hunger / thirst / energy):
- Bug meat paste (raw): 84 / 0 / -14
- Bug meat paste (cooked): 168 / 0 / 14
- Bug meat paste (burned): 21 / 0 / -3
- Bug meat pastry (cooked): 84 / 2 / 22
- Bug meat pastry (burned): 21 / 0 / 5
- Rotten pastry: -4 / 0 / -12, guaranteed food poisoning and intestinal parasites

Design rationale:
- Cooking can increase effective nutritional value by making nutrient absorption more efficient. That is why soup gets a boost: the extra satiety and energy reward the added effort of preparing food.
- This also helps justify the resource costs of cooking, especially water and fuel.
- The smoker simplifies food processing by supporting bulk cooking and reducing the risk of burning food.
- The smoker remains safer than open-fire baking, while still keeping a small chance of mistakes at high temperatures.
- Whole egg bread adds a longer but coherent early-food progression: gather, mill, mix, ferment, and bake.
- Bug meat paste condenses 48 carcasses into one block at roughly 58% of the full cooked meat total (168 hunger); a modest bulk loss, not a harsh penalty.
- Bug meat pastry is late-game premium food: one batch yields 504 total hunger (6×84), slightly above the sum of its parts (496), rewarding the full pipeline with a meal that beats mashed anperla, egg bread, and maraka cake per serving.
- With **exile_alchemy** (optional): salted and sweet food variants use alchemical salt and sugar. Bug meat pastry requires salt and gains higher nutrition.
- Exile is already a challenging survival experience, so these changes improve quality of life without removing difficulty.
- The Bitter Maraka Flour texture is intentionally more visible to improve readability in low-light areas, underwater environments, and for players with color blindness.

Goal: make cooking a stronger early-game survival option.

## exile_alchemy integration (optional)

When `exile_alchemy` is loaded:

| Food | Recipe addition | Effect vs base (cooked) |
|------|-----------------|-------------------------|
| Maraka Cake (Sweet) | maraka flour + sugar | +2 hunger, +18 energy |
| Mashed Anperla (Salty) | 6 peeled + salt | +23 hunger, −5 thirst (minerals aid absorption) |
| Sari Bread (Seasoned) | fermented dough + salt + sugar | +13 hunger, +20 energy, −3 thirst |
| Bug Meat Pastry | **requires salt** (replaces plain recipe) | 98 / 0 / 26 per pastry |

Burned variants reuse the original burned nodes for maraka, mashed anperla, and sari bread.

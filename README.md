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
- Adds the Bug Meat Pastry chain:
	- Phase 1: 48× small invertebrate carcasses yield 1× bug meat paste (mortar and pestle).
	- Phase 2: Raw paste is edible but unsafe (90% food poisoning). Cook it over a fire or in the smoker to get cooked paste (96 hunger).
	- Phase 3: 1× cooked paste + 2× sari flour + 6× mashed anperla yield 6× unbaked bug meat pastries (mortar and pestle).
	- Phase 4: Bake pastries at 160°C for 14 ticks. Open-fire baking carries a 0.2% chance per hot tick to rot; the smoker avoids rotting but can still burn on overheat.

Nutrition (hunger / energy):
- Bug meat paste (raw): 48 / -12
- Bug meat paste (cooked): 96 / 8
- Bug meat paste (burned): 12 / -4
- Bug meat pastry (cooked): 60 / 18
- Bug meat pastry (burned): 15 / 3
- Rotten pastry: -4 / -12, guaranteed food poisoning and intestinal parasites

Design rationale:
- Cooking can increase effective nutritional value by making nutrient absorption more efficient. That is why soup gets a boost: the extra satiety and energy reward the added effort of preparing food.
- This also helps justify the resource costs of cooking, especially water and fuel.
- The smoker simplifies food processing by supporting bulk cooking and reducing the risk of burning food.
- The smoker remains safer than open-fire baking, while still keeping a small chance of mistakes at high temperatures.
- Whole egg bread adds a longer but coherent early-food progression: gather, mill, mix, ferment, and bake.
- Bug meat paste condenses 48 carcasses into one block at roughly one third of the raw meat total (48 hunger); cooking doubles that to 96, matching the usual raw-to-cooked ratio in Exile.
- Bug meat pastry combines cooked paste, sari flour, and mashed anperla into a high-effort meal worth 60 hunger per unit when baked.
- Exile is already a challenging survival experience, so these changes improve quality of life without removing difficulty.
- The Bitter Maraka Flour texture is intentionally more visible to improve readability in low-light areas, underwater environments, and for players with color blindness.

Goal: make cooking a stronger early-game survival option.

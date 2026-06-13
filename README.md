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
- Adds the Bug Meat Pastry, a multi-stage, high-risk cooking chain:
    - Phase 1: 48× small invertebrate carcasses yield 1× bug meat paste using the mortar and pestle.
    - Phase 2: The paste block must be placed under flowing water to wash out impurities. Takes ~8 minutes (50 steps, 10s per cycle). Each cycle carries a 4% chance to rot the batch, resulting in a dead-end rotten paste.
    - Phase 3: 4× washed paste + 2× sari flour + 2× vegetable oil yield 6× unbaked bug meat pastries using the mortar and pestle.
    - Phase 4 (Baking): Cooked at 160°C for 14 ticks. Baking over an open fire carries a 3% chance per hot tick to rot the pastry. Baking in the clay smoker eliminates the rotting risk entirely, leaving only the standard overheat/burn chance.

Design rationale:
- Cooking can increase effective nutritional value by making nutrient absorption more efficient. That is why soup gets a boost: the extra satiety and energy reward the added effort of preparing food.
- This also helps justify the resource costs of cooking, especially water and fuel.
- The smoker simplifies food processing by supporting bulk cooking and reducing the risk of burning food.
- The smoker remains safer than open-fire baking, while still keeping a small chance of mistakes at high temperatures.
- Whole egg bread adds a longer but coherent early-food progression: gather, mill, mix, ferment, and bake.
- Exile is already a challenging survival experience, so these changes improve quality of life without removing difficulty.
- The Bitter Maraka Flour texture is intentionally more visible to improve readability in low-light areas, underwater environments, and for players with color blindness.

Goal: make cooking a stronger early-game survival option.

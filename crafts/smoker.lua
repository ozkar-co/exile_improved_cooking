crafting.register_recipe({
	type = "crafting_spot",
	output = "exile_improved_cooking:smoker_unfired 1",
	items = { "nodes_nature:clay_wet 5" },
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mixing_spot",
	output = "nodes_nature:clay 5",
	items = { "exile_improved_cooking:smoker_unfired 1" },
	level = 1,
	always_known = true,
})

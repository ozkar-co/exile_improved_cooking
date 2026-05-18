local smoker_station_type = minetest.get_modpath("exile_advanced_ceramics") and "pottery_wheel" or "crafting_spot"

crafting.register_recipe({
	type = smoker_station_type,
	output = "exile_improved_cooking:smoker_unfired 1",
	items = { "nodes_nature:clay_wet 5" },
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = smoker_station_type,
	output = "nodes_nature:clay_wet 5",
	items = { "exile_improved_cooking:smoker_unfired 1" },
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

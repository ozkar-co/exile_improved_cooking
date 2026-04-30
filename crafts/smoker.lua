crafting.register_recipe({
	type = "clay_shaping_spot",
	output = "tech:smoker_unfired 1",
	items = { "nodes_nature:clay_wet 5" },
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "pottery_wheel",
	output = "tech:smoker_unfired 1",
	items = { "nodes_nature:clay_wet 5" },
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "clay_mixing",
	output = "nodes_nature:clay 5",
	items = { "tech:smoker_unfired 1" },
	level = 1,
	always_known = true,
})

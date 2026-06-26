if not minetest.get_modpath("exile_alchemy") then
	return
end

crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "exile_improved_cooking:maraka_bread_sweet 6",
	items = {
		"tech:maraka_flour",
		"exile_alchemy:sugar",
	},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "exile_improved_cooking:mashed_anperla_salty",
	items = {
		"tech:peeled_anperla 6",
		"exile_alchemy:salt",
	},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "mortar_and_pestle",
	output = "exile_improved_cooking:sari_bread_seasoned 6",
	items = {
		"exile_improved_cooking:egg_dough_fermented 1",
		"exile_alchemy:salt",
		"exile_alchemy:sugar",
	},
	level = 1,
	always_known = true,
})

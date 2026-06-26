local S = minetest.get_translator("exile_improved_cooking")

if not minetest.get_modpath("exile_alchemy") then
	return
end

local function bind_bake_timer(unbaked, cooked, burned, temp, duration)
	exile_add_bake({ [unbaked] = { temp, duration } })

	local function bake_timer(pos, elapsed)
		local selfname = minetest.get_node(pos).name:gsub("_cooked", "")
		if bake_table[selfname] == nil then
			return true
		end
		return ncrafting.do_bake(pos, elapsed, temp, duration, cooked, burned)
	end

	minetest.override_item(unbaked, {
		on_construct = function(pos)
			ncrafting.start_bake(pos, duration)
		end,
		on_timer = bake_timer,
	})

	minetest.override_item(cooked, {
		on_timer = bake_timer,
	})
end

local function register_maraka_sweet()
	local unbaked = "exile_improved_cooking:maraka_bread_sweet"
	local cooked = unbaked .. "_cooked"

	minetest.register_node(unbaked, {
		description = S("Unbaked Maraka Cake (Sweet)"),
		tiles = { "tech_flour.png" },
		stack_max = EXILE.stack_max_medium,
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = { -0.3, -0.5, -0.3, 0.3, -0.3, 0.3 },
		},
		groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, heatable = 80, edible = 1 },
		sounds = nodes_nature.node_sound_dirt_defaults(),
	})

	minetest.register_node(cooked, {
		description = S("Maraka Cake (Sweet)"),
		tiles = { "tech_flour_bitter.png" },
		stack_max = EXILE.stack_max_medium * 4,
		paramtype = "light",
		sunlight_propagates = true,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = { -0.28, -0.5, -0.28, 0.28, -0.32, 0.28 },
		},
		groups = { crumbly = 3, falling_node = 1, dig_immediate = 3, temp_pass = 1, heatable = 80, edible = 1 },
		sounds = nodes_nature.node_sound_dirt_defaults(),
	})

	bind_bake_timer(unbaked, cooked, "tech:maraka_bread_burned", 160, 10)

	exile_add_food({
		[cooked] = { 0, 0, 26, 32, 0 },
	})

	exile_add_harm({
		[cooked] = { { "Food Poisoning", 0.001, 1 } },
	})
end

local function register_mashed_salty()
	local unbaked = "exile_improved_cooking:mashed_anperla_salty"
	local cooked = unbaked .. "_cooked"

	minetest.register_node(unbaked, {
		description = S("Mashed Anperla (Salty, uncooked)"),
		tiles = { "tech_flour.png" },
		stack_max = EXILE.stack_max_medium / 6,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = { -6 / 16, -0.5, -6 / 16, 6 / 16, 1 / 16, 6 / 16 },
		},
		groups = { snappy = 3, falling_node = 1, dig_immediate = 3, temp_pass = 1, heatable = 70, edible = 1 },
		sounds = nodes_nature.node_sound_dirt_defaults(),
	})

	minetest.register_node(cooked, {
		description = S("Mashed Anperla (Salty)"),
		tiles = { "tech_flour_bitter.png" },
		stack_max = EXILE.stack_max_medium / 3,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = { -5 / 16, -0.5, -5 / 16, 5 / 16, -1 / 16, 5 / 16 },
		},
		groups = { crumbly = 3, falling_node = 1, dig_immediate = 3, heatable = 70, temp_pass = 1, edible = 1 },
		sounds = nodes_nature.node_sound_dirt_defaults(),
	})

	bind_bake_timer(unbaked, cooked, "tech:mashed_anperla_burned", 100, 35)

	exile_add_food({
		[cooked] = { 0, 7, 95, 42, 0 },
	})

	exile_add_harm({
		[cooked] = { { "Food Poisoning", 0.002, 1 } },
	})
end

local function register_sari_seasoned()
	local unbaked = "exile_improved_cooking:sari_bread_seasoned"
	local cooked = unbaked .. "_cooked"

	minetest.register_node(unbaked, {
		description = S("Sari Bread (Seasoned, Unbaked)"),
		tiles = { "exile_improved_cooking_egg_bread_unbaked.png" },
		stack_max = EXILE.stack_max_medium,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = { -0.28, -0.5, -0.28, 0.28, -0.3, 0.28 },
		},
		groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, heatable = 90, edible = 1 },
		sounds = nodes_nature.node_sound_dirt_defaults(),
	})

	minetest.register_node(cooked, {
		description = S("Sari Bread (Seasoned)"),
		tiles = { "exile_improved_cooking_egg_bread_cooked.png" },
		stack_max = EXILE.stack_max_medium,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = { -0.26, -0.5, -0.26, 0.26, -0.28, 0.26 },
		},
		groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, heatable = 90, edible = 1 },
		sounds = nodes_nature.node_sound_dirt_defaults(),
	})

	bind_bake_timer(
		unbaked,
		cooked,
		"exile_improved_cooking:egg_bread_unbaked_burned",
		160,
		12
	)

	exile_add_food({
		[cooked] = { 0, -3, 45, 28, 0 },
	})

	exile_add_harm({
		[cooked] = { { "Food Poisoning", 0.05, 1 } },
	})
end

local function upgrade_salted_pastry()
	exile_add_food({
		["exile_improved_cooking:bug_meat_pastry_unbaked_cooked"] = { 0, 0, 98, 26, 0 },
	})
end

register_maraka_sweet()
register_mashed_salty()
register_sari_seasoned()
upgrade_salted_pastry()

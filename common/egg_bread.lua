local S = minetest.get_translator("exile_improved_cooking")

local DOUGH_FERMENT_INTERVAL = 10
local DOUGH_FERMENT_STEPS = 36
local DOUGH_TEMP_MIN = 12
local DOUGH_TEMP_MAX = 45

local function can_ferment_here(pos)
    if climate.get_rain(pos) or minetest.find_node_near(pos, 1, {"group:water"}) then
        return false
    end

    local temp = climate.get_point_temp(pos)
    if not temp then
        return false
    end

    return temp >= DOUGH_TEMP_MIN and temp <= DOUGH_TEMP_MAX
end

minetest.register_node("exile_improved_cooking:sari_flour", {
    description = S("Sari Flour"),
    tiles = {"exile_improved_cooking_sari_flour.png"},
    stack_max = EXILE.stack_max_bulky,
    paramtype = "light",
    groups = {crumbly = 3, dig_immediate = 3, falling_node = 1, flammable = 1},
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:egg_dough_unfermented", {
    description = S("Sari Dough (Unfermented)"),
    tiles = {"exile_improved_cooking_egg_dough_unfermented.png"},
    stack_max = EXILE.stack_max_medium,
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, -0.35, 0.3},
    },
    groups = {crumbly = 3, dig_immediate = 3, temp_pass = 1},
    sounds = nodes_nature.node_sound_dirt_defaults(),
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_int("fermenting", DOUGH_FERMENT_STEPS)
        minetest.get_node_timer(pos):start(DOUGH_FERMENT_INTERVAL)
    end,
    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local fermenting = meta:get_int("fermenting")

        if fermenting <= 0 then
            EXILE.switch_node(pos, {name = "exile_improved_cooking:egg_dough_fermented"})
            return false
        end

        if can_ferment_here(pos) then
            meta:set_int("fermenting", fermenting - 1)
        end

        return true
    end,
})

minetest.register_node("exile_improved_cooking:egg_dough_fermented", {
    description = S("Sari Dough (Fermented)"),
    tiles = {"exile_improved_cooking_egg_dough_fermented.png"},
    stack_max = EXILE.stack_max_medium,
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.375, -0.5, -0.375, 0.375, -0.26, 0.375},
    },
    groups = {crumbly = 3, dig_immediate = 3, temp_pass = 1},
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:egg_bread_unbaked", {
    description = S("Sari Bread (Unbaked)"),
    tiles = {"exile_improved_cooking_egg_bread_unbaked.png"},
    stack_max = EXILE.stack_max_medium,
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.28, -0.5, -0.28, 0.28, -0.3, 0.28},
    },
    groups = {crumbly = 3, dig_immediate = 3, temp_pass = 1, heatable = 90, edible = 1},
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:egg_bread_unbaked_cooked", {
    description = S("Sari Bread"),
    tiles = {"exile_improved_cooking_egg_bread_cooked.png"},
    stack_max = EXILE.stack_max_medium,
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.26, -0.5, -0.26, 0.26, -0.28, 0.26},
    },
    groups = {crumbly = 3, dig_immediate = 3, temp_pass = 1, heatable = 90, edible = 1},
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:egg_bread_unbaked_burned", {
    description = S("Sari Bread (Burned)"),
    tiles = {"exile_improved_cooking_egg_bread_burned.png"},
    stack_max = EXILE.stack_max_medium,
    paramtype = "light",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.26, -0.5, -0.26, 0.26, -0.28, 0.26},
    },
    groups = {crumbly = 3, dig_immediate = 3, temp_pass = 1, flammable = 1, edible = 1},
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

exile_add_food({
    ["exile_improved_cooking:sari_flour"] = { 0, 0, 72, -8, 0 },
    ["exile_improved_cooking:egg_bread_unbaked_cooked"] = { 0, 0, 32, 8, 0 },
    ["exile_improved_cooking:egg_bread_unbaked_burned"] = { 0, 0, 8, 4, 0 },
})

exile_add_harm({
    ["exile_improved_cooking:egg_bread_unbaked_cooked"] = { { "Food Poisoning", 0.05, 1 } },
    ["exile_improved_cooking:egg_bread_unbaked_burned"] = { { "Food Poisoning", 0.002, 1 } },
})

exile_add_bake({
    ["exile_improved_cooking:egg_bread_unbaked"] = { 160, 12 },
})

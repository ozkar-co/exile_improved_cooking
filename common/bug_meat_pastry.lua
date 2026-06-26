local S = minetest.get_translator("exile_improved_cooking")

local PASTE_BAKE_TEMP = 100
local PASTE_BAKE_TIME = 12

local PASTRY_BAKE_TEMP = 160
local PASTRY_BAKE_TIME = 14
local PASTRY_BAKE_ROT_CHANCE = 0.002

local meat_paste_box = {
    type = "fixed",
    fixed = { -0.35, -0.5, -0.35, 0.35, -0.28, 0.35 },
}

local pastry_box = {
    type = "fixed",
    fixed = { 
        {-0.375, -0.5, -0.3125, -0.25, -0.375, -0.25}, -- NodeBox1
        {-0.4375, -0.5, -0.25, -0.1875, -0.3125, -0.125}, -- NodeBox2
        {-0.4375, -0.5, -0.125, -0.125, -0.25, 0}, -- NodeBox3
        {-0.3125, -0.5, 0, 0, -0.1875, 0.3125}, -- NodeBox4
        {0, -0.5, 0.125, 0.125, -0.25, 0.4375}, -- NodeBox5
        {0.125, -0.5, 0.1875, 0.25, -0.3125, 0.4375}, -- NodeBox6
        {0.25, -0.5, 0.25, 0.3125, -0.375, 0.375}, -- NodeBox7
        {-0.25, -0.5, 0.3125, 0, -0.1875, 0.375}, -- NodeBox8
        {-0.375, -0.5, 0, -0.3125, -0.1875, 0.25}, -- NodeBox9
        {-0.25, -0.1875, 0.0625, -0.0625, -0.125, 0.25}, -- NodeBox10
     },
}

local function pastry_do_bake(pos)
    local selfname = minetest.get_node(pos).name
    local name_cooked = "exile_improved_cooking:bug_meat_pastry_unbaked_cooked"
    local name_burned = "exile_improved_cooking:bug_meat_pastry_unbaked_burned"
    local name_rotten = "exile_improved_cooking:bug_meat_pastry_unbaked_rotten"
    local burntime = math.floor(PASTRY_BAKE_TIME * 0.40 + 10) * -1
    local meta = minetest.get_meta(pos)
    local baking = meta:get_int("baking")

    if climate.get_rain(pos) or minetest.find_node_near(pos, 1, { "group:water" }) then
        return true
    end

    climate.heat_transfer(pos, selfname)

    local temp = climate.get_point_temp(pos)
    local fire_temp = PASTRY_BAKE_TEMP
    if temp == nil then
        return true
    elseif baking == 0 then
        EXILE.switch_node(pos, { name = name_cooked })
        ncrafting.set_treatment(meta, "cook")
        minetest.check_for_falling(pos)
        meta:set_int("baking", -1)
        minetest.get_node_timer(pos):start(ncrafting.cook_rate)
        return true
    elseif temp < fire_temp then
        return true
    elseif temp > fire_temp * 2 or baking < burntime then
        if minetest.registered_nodes[name_burned] then
            minetest.swap_node(pos, { name = name_burned })
            ncrafting.set_treatment(meta, "burn")
        else
            minetest.set_node(pos, { name = "air" })
        end
        minetest.sound_play("tech_fire_small", { pos = pos, max_hear_distance = 10, loop = false, gain = 0.1 })
        minetest.add_particlespawner(ncrafting.particle_smokesmall(pos))
        return false
    elseif temp >= fire_temp then
        if math.random() < PASTRY_BAKE_ROT_CHANCE then
            minetest.swap_node(pos, { name = name_rotten })
            return false
        end
        meta:set_int("baking", baking - 1)
        return true
    end
end

minetest.register_node("exile_improved_cooking:bug_meat_paste", {
    description = S("Bug Meat Paste"),
    tiles = { "exile_improved_cooking_bug_meat_paste.png" },
    drawtype = "nodebox",
    paramtype = "light",
    node_box = meat_paste_box,
    stack_max = EXILE.stack_max_medium,
    groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, falling_node = 1, heatable = PASTE_BAKE_TEMP, edible = 1 },
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:bug_meat_paste_cooked", {
    description = S("Bug Meat Paste (Cooked)"),
    tiles = { "exile_improved_cooking_bug_meat_paste_cooked.png" },
    drawtype = "nodebox",
    paramtype = "light",
    node_box = meat_paste_box,
    stack_max = EXILE.stack_max_medium,
    groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, falling_node = 1, edible = 1 },
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:bug_meat_paste_burned", {
    description = S("Bug Meat Paste (Burned)"),
    tiles = { "exile_improved_cooking_bug_meat_paste_burned.png" },
    drawtype = "nodebox",
    paramtype = "light",
    node_box = meat_paste_box,
    stack_max = EXILE.stack_max_medium,
    groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, falling_node = 1, edible = 1 },
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:bug_meat_pastry_unbaked", {
    description = S("Bug Meat Pastry (Unbaked)"),
    tiles = { "exile_improved_cooking_bug_meat_pastry_unbaked.png" },
    drawtype = "nodebox",
    paramtype = "light",
    node_box = meat_paste_box,
    stack_max = EXILE.stack_max_medium,
    groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, heatable = PASTRY_BAKE_TEMP, edible = 1 },
    sounds = nodes_nature.node_sound_dirt_defaults(),
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_int("baking", PASTRY_BAKE_TIME)
        minetest.get_node_timer(pos):start(ncrafting.cook_rate)
    end,
    on_timer = function(pos, elapsed)
        return pastry_do_bake(pos)
    end,
})

minetest.register_node("exile_improved_cooking:bug_meat_pastry_unbaked_cooked", {
    description = S("Bug Meat Pastry"),
    tiles = { "exile_improved_cooking_bug_meat_pastry_unbaked_cooked.png" },
    drawtype = "nodebox",
    paramtype = "light",
    node_box = pastry_box,
    stack_max = EXILE.stack_max_medium,
    groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, edible = 1 },
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:bug_meat_pastry_unbaked_burned", {
    description = S("Bug Meat Pastry (Burned)"),
    tiles = { "exile_improved_cooking_bug_meat_pastry_unbaked_burned.png" },
    drawtype = "nodebox",
    paramtype = "light",
    node_box = pastry_box,
    stack_max = EXILE.stack_max_medium,
    groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, flammable = 1, edible = 1 },
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

minetest.register_node("exile_improved_cooking:bug_meat_pastry_unbaked_rotten", {
    description = S("Bug Meat Pastry (Rotten)"),
    tiles = { "exile_improved_cooking_bug_meat_pastry_unbaked_rotten.png" },
    drawtype = "nodebox",
    paramtype = "light",
    node_box = pastry_box,
    stack_max = EXILE.stack_max_medium,
    groups = { crumbly = 3, dig_immediate = 3, temp_pass = 1, compost = 1, edible = 1 },
    sounds = nodes_nature.node_sound_dirt_defaults(),
})

--[[
Hunger rationale (see health/data_food.lua):
  invert carcass raw/cooked/burned = 3 / 6 / 1  (48 carcass -> 144 / 288 / 48 total)
  sari flour = 72
  mashed_anperla_cooked = 72  (6 peeled tubers mashed into one block)

Paste (48 carcass -> 1 block, ~58% of full cooked meat value preserved):
  raw 84, cooked 168, burned 21

Pastry batch: 1 cooked paste + 2 flour + 1 mashed_anperla -> 6 pastries.
  Parts if eaten separately: 168 + 144 + 72 = 384 hu
  Baked output: 6 x 84 = 504 hu (~8% synergy bonus over parts, not a penalty).
]]--

local ROTTEN_HARM = {
    { "Food Poisoning", 1.0, 2 },
    { "Intestinal Parasites", 1.0, 1 },
}

exile_add_food({
    ["exile_improved_cooking:bug_meat_paste"] = { 0, 0, 84, -14, 0 },
    ["exile_improved_cooking:bug_meat_paste_cooked"] = { 0, 0, 168, 14, 0 },
    ["exile_improved_cooking:bug_meat_paste_burned"] = { 0, -1, 21, -3, 0 },
    ["exile_improved_cooking:bug_meat_pastry_unbaked_cooked"] = { 0, 2, 84, 22, 0 },
    ["exile_improved_cooking:bug_meat_pastry_unbaked_burned"] = { 0, 0, 21, 5, 0 },
    ["exile_improved_cooking:bug_meat_pastry_unbaked_rotten"] = { 0, -2, -4, -12, 0 },
})

exile_add_harm({
    ["exile_improved_cooking:bug_meat_paste"] = { { "Food Poisoning", 0.9, 1 } },
    ["exile_improved_cooking:bug_meat_paste_cooked"] = { { "Food Poisoning", 0.002, 1 } },
    ["exile_improved_cooking:bug_meat_paste_burned"] = { { "Food Poisoning", 0.001, 1 } },
    ["exile_improved_cooking:bug_meat_pastry_unbaked_cooked"] = { { "Food Poisoning", 0.004, 1 } },
    ["exile_improved_cooking:bug_meat_pastry_unbaked_burned"] = { { "Food Poisoning", 0.002, 1 } },
    ["exile_improved_cooking:bug_meat_pastry_unbaked_rotten"] = ROTTEN_HARM,
})

exile_add_bake({
    ["exile_improved_cooking:bug_meat_paste"] = { PASTE_BAKE_TEMP, PASTE_BAKE_TIME },
})

bake_table["exile_improved_cooking:bug_meat_pastry_unbaked"] = { PASTRY_BAKE_TEMP, PASTRY_BAKE_TIME }

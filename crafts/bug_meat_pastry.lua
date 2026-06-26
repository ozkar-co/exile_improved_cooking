crafting.register_recipe({
    type = "mortar_and_pestle",
    output = "exile_improved_cooking:bug_meat_paste 1",
    items = { "animals:carcass_invert_small 48" },
    level = 1,
    always_known = true,
})

local pastry_items = {
    "exile_improved_cooking:bug_meat_paste_cooked 1",
    "exile_improved_cooking:sari_flour 2",
    "tech:mashed_anperla 1",
}

if minetest.get_modpath("exile_alchemy") then
    table.insert(pastry_items, "exile_alchemy:salt")
end

crafting.register_recipe({
    type = "mortar_and_pestle",
    output = "exile_improved_cooking:bug_meat_pastry_unbaked 6",
    items = pastry_items,
    level = 1,
    always_known = true,
})

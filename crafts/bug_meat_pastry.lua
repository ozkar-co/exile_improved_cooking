crafting.register_recipe({
    type = "mortar_and_pestle",
    output = "exile_improved_cooking:bug_meat_paste 1",
    items = { "animals:carcass_invert_small 48" },
    level = 1,
    always_known = true,
})

crafting.register_recipe({
    type = "mortar_and_pestle",
    output = "exile_improved_cooking:bug_meat_pastry_unbaked 6",
    items = {
        "exile_improved_cooking:bug_meat_paste_cooked 1",
        "exile_improved_cooking:sari_flour 2",
        "tech:mashed_anperla 1",
    },
    level = 1,
    always_known = true,
})

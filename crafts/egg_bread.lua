crafting.register_recipe({
    type = "mortar_and_pestle",
    output = "exile_improved_cooking:sari_flour 1",
    items = {"nodes_nature:sari_seed 72"},
    level = 1,
    always_known = true,
})

crafting.register_recipe({
    type = "mortar_and_pestle",
    output = "exile_improved_cooking:egg_dough_unfermented 1",
    items = {
        "animals:pegasun_eggs 2",
        "tech:vegetable_oil 1",
        "exile_improved_cooking:sari_flour 1",
    },
    level = 1,
    always_known = true,
})

crafting.register_recipe({
    type = "mortar_and_pestle",
    output = "exile_improved_cooking:egg_bread_unbaked 6",
    items = {"exile_improved_cooking:egg_dough_fermented 1"},
    level = 1,
    always_known = true,
})

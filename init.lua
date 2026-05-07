local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath .. "/common/smoker.lua")
dofile(modpath .. "/nodes/smoker.lua")
dofile(modpath .. "/crafts/smoker.lua")

local SOUP_BONUS_FACTOR = 1.2

local function with_soup_bonus(itemstack)
    local boosted = ItemStack(itemstack)
    local imeta = boosted:get_meta()
    local eat_value = minetest.deserialize(imeta:get_string("eat_value"))

    if type(eat_value) ~= "table" then
        return boosted
    end

    if type(eat_value[1]) == "number" then
        eat_value[1] = eat_value[1] * SOUP_BONUS_FACTOR
    end
    if type(eat_value[2]) == "number" then
        eat_value[2] = eat_value[2] * SOUP_BONUS_FACTOR
    end

    imeta:set_string("eat_value", minetest.serialize(eat_value))
    return boosted
end

minetest.override_item("tech:soup", {
    on_use = function(itemstack, user, pointed_thing)
        return exile_eatdrink_playermade(with_soup_bonus(itemstack), user, pointed_thing)
    end,
})

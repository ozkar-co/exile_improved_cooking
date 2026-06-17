-- Register the smoker node
local SMOKER_MIN_TEMP = 50
local SMOKER_BASE_FIRING = ncrafting.base_firing
local SMOKER_FIRING_INTERVAL = ncrafting.firing_int
local SMOKER_BURN_BASE_CHANCE = 0.002
local smoker_is_done_stack

local function smoker_get_bake_profile(itemname)
    local cook_temp = 100
    local bake_length = 10

    if bake_table and bake_table[itemname] then
        cook_temp = bake_table[itemname][1] or cook_temp
        bake_length = bake_table[itemname][2] or bake_length
    end

    return cook_temp, bake_length
end

local function smoker_get_max_progress(itemname)
    local _, bake_length = smoker_get_bake_profile(itemname)
    return math.max(30, bake_length * 8)
end

local function smoker_get_progress_step(itemname, temperature)
    if temperature < SMOKER_MIN_TEMP then
        return 0
    end

    local cook_temp = smoker_get_bake_profile(itemname)
    local heat_ratio = temperature / cook_temp

    if heat_ratio < 1 then
        return math.max(1, math.floor(heat_ratio * 4))
    end

    return math.max(2, math.floor(math.min(heat_ratio, 2) * 5))
end

local function smoker_should_burn(itemname, temperature)
    local burned_item = itemname .. "_burned"
    if not minetest.registered_items[burned_item] then
        return false
    end

    local cook_temp = smoker_get_bake_profile(itemname)
    local overheat = math.max(0, temperature - cook_temp * 1.35)
    local chance = SMOKER_BURN_BASE_CHANCE +
        (overheat / math.max(cook_temp, 1)) * 0.003

    return math.random() < math.min(0.04, chance)
end

local function smoker_set_ui(pos, meta, status)
    meta:set_string("formspec", smoker_get_formspec(status))
    local text = smoker_get_status_text(status)
    if minimal and minimal.infotext_set then
        minimal.infotext_set(pos, meta, text)
    else
        meta:set_string("infotext", text)
    end
end

local function smoker_refresh_state(pos, meta)
    local inv = meta:get_inventory()
    local temperature = climate.get_point_temp(pos)
    local has_items = false
    local has_pending = false

    for slot = 1, 6 do
        local stack = inv:get_stack("smoker_main", slot)
        if not stack:is_empty() then
            has_items = true
            if not smoker_is_done_stack(stack) then
                has_pending = true
            end
        end
    end

    local status
    if not has_items then
        status = ""
    elseif has_pending and temperature < SMOKER_MIN_TEMP then
        status = "too_cold"
    elseif has_pending then
        status = "smoking"
    else
        status = "finished"
    end

    meta:set_string("status", status)
    smoker_set_ui(pos, meta, status)
    return status
end

local function smoker_is_full(inv)
    for slot = 1, 6 do
        if inv:get_stack("smoker_main", slot):is_empty() then
            return false
        end
    end
    return true
end

smoker_is_done_stack = function(stack)
    if stack:is_empty() then
        return true
    end
    return minetest.registered_items[stack:get_name() .. "_cooked"] == nil
end

minetest.register_node("exile_improved_cooking:smoker", {
    description = S("Food Smoker"),
    tiles = { "tech_pottery.png" },
    groups = { dig_immediate = 3, pottery = 1, temp_pass = 1 },
    paramtype = "light",
    paramtype2 = "facedir",
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = smoker_nodebox,
    },
    sounds = nodes_nature.node_sound_stone_defaults(),

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        inv:set_size("smoker_main", 6)

        -- Start the timer
        minetest.get_node_timer(pos):start(smoker_time)

        -- Initialize the variables for each slot
        for slot = 1, 6 do
            meta:set_int("variable_" .. slot, 0)
        end
        smoker_refresh_state(pos, meta)
    end,

    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local temperature = climate.get_point_temp(pos) -- Get the block temperature
        local status = meta:get_string("status")

        -- Iterate through each slot
        for slot = 1, 6 do
            local variable = meta:get_int("variable_" .. slot)
            local stack = inv:get_stack("smoker_main", slot)

            if not stack:is_empty() and not smoker_is_done_stack(stack) and temperature >= SMOKER_MIN_TEMP then
                if status == "" then
                    status = "smoking"
                    meta:set_string("status", status)
                end

                local item = stack:get_name()
                local max_value = smoker_get_max_progress(item)

                if smoker_should_burn(item, temperature) then
                    inv:set_stack("smoker_main", slot, item .. "_burned 1")
                    variable = max_value
                    meta:set_int("variable_" .. slot, variable)
                elseif variable < max_value then
                    -- Increase progress according to each food's original bake profile.
                    variable = variable + smoker_get_progress_step(item, temperature)

                    -- If the variable reaches or exceeds max_value
                    if variable >= max_value then
                        local cooked_item = item .. "_cooked"

                        if minetest.registered_items[cooked_item] then
                            -- Replace the item in the slot with its cooked version
                            inv:set_stack("smoker_main", slot, cooked_item .. " 1")
                            variable = max_value
                        end
                    end

                    -- Update the variable in the metadata
                    meta:set_int("variable_" .. slot, variable)
                end
            end
        end

        smoker_refresh_state(pos, meta)

        -- Continue the timer
        return true
    end,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        smoker_refresh_state(pos, meta)
        minetest.show_formspec(clicker:get_player_name(), "exile_improved_cooking:smoker", meta:get_string("formspec"))
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local status = meta:get_string("status")

        if listname == "smoker_main" then
            local inv = meta:get_inventory()
            if not inv:get_stack("smoker_main", index):is_empty() then
                return 0
            end
            if minetest.registered_items[stack:get_name() .. "_cooked"] then
                if status == "finished" then
                    meta:set_string("status", "")
                end
                return 1
            end
        end
        return 0
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local status = meta:get_string("status")

        if to_list == "smoker_main" then
            local inv = meta:get_inventory()
            if not inv:get_stack("smoker_main", to_index):is_empty() then
                return 0
            end
            local stack
            if from_list == "smoker_main" then
                stack = inv:get_stack(from_list, from_index)
            elseif player then
                stack = player:get_inventory():get_stack(from_list, from_index)
            else
                return 0
            end

            if minetest.registered_items[stack:get_name() .. "_cooked"] then
                if status == "finished" then
                    meta:set_string("status", "")
                end
                return math.min(count, 1)
            end
            return 0
        end

        if from_list == "smoker_main" then
            local inv = meta:get_inventory()
            local from_stack = inv:get_stack(from_list, from_index)
            if to_list ~= "smoker_main" and not smoker_is_done_stack(from_stack) then
                return 0
            end
            return math.min(count, 1)
        end

        return count
    end,

    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        if listname == "smoker_main" then
            if not smoker_is_done_stack(stack) then
                return 0
            end
            return math.min(stack:get_count(), 1)
        end
        return stack:get_count()
    end,

    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        -- Check if the listname is the "smoker_main" inventory
        if listname == "smoker_main" then
            -- if the item is taken reset the variable for that slot
            local meta = minetest.get_meta(pos)
            meta:set_int("variable_" .. index, 0)
            smoker_refresh_state(pos, meta)
        end
    end,

    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "smoker_main" then
            local meta = minetest.get_meta(pos)
            meta:set_int("variable_" .. index, 0)
            smoker_refresh_state(pos, meta)
        end
    end,

    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        if from_list == "smoker_main" or to_list == "smoker_main" then
            local meta = minetest.get_meta(pos)
            if from_list == "smoker_main" then
                meta:set_int("variable_" .. from_index, 0)
            end
            if to_list == "smoker_main" then
                meta:set_int("variable_" .. to_index, 0)
            end
            smoker_refresh_state(pos, meta)
        end
    end,

    on_destruct = function(pos)
        -- drops its contents when broken
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        if inv then
            for _, item in ipairs(inv:get_list("smoker_main")) do
                if not item:is_empty() then
                    minetest.add_item(pos, item)
                end
            end
        end
    end,
})

--unfired
minetest.register_node("exile_improved_cooking:smoker_unfired", {
    description = S("Clay Smoker (unfired)"),
    tiles = {
        "nodes_nature_clay.png",
        "nodes_nature_clay.png",
        "nodes_nature_clay.png",
        "nodes_nature_clay.png",
        "nodes_nature_clay.png",
        "nodes_nature_clay.png",
    },
    drawtype = "nodebox",
    stack_max = minimal.stack_max_bulky,
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = smoker_nodebox,
    },
    groups = { dig_immediate = 3, temp_pass = 1, heatable = 20 },
    sounds = nodes_nature.node_sound_stone_defaults(),
    on_construct = function(pos)
        --length(i.e. difficulty of firing), interval for checks (speed)
        ncrafting.set_firing(pos, SMOKER_BASE_FIRING, SMOKER_FIRING_INTERVAL)
    end,
    on_timer = function(pos, elapsed)
        --finished product, length
        return ncrafting.fire_pottery(pos, "exile_improved_cooking:smoker_unfired", "exile_improved_cooking:smoker", SMOKER_BASE_FIRING)
    end,
})

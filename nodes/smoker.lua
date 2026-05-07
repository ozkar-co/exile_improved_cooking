-- Register the smoker node

local function smoker_is_full(inv)
    for slot = 1, 6 do
        if inv:get_stack("smoker_main", slot):is_empty() then
            return false
        end
    end
    return true
end

local function smoker_is_done_stack(stack)
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

        meta:set_string("formspec", smoker_get_formspec(""))

        -- Start the timer
        minetest.get_node_timer(pos):start(smoker_time)

        -- Initialize the variables for each slot
        for slot = 1, 6 do
            meta:set_int("variable_" .. slot, 0)
        end
        meta:set_string("status", "")
    end,

    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local temperature = climate.get_point_temp(pos) -- Get the block temperature
        local status = meta:get_string("status")
        local has_items = false
        local has_pending = false

        -- Iterate through each slot
        for slot = 1, 6 do
            local variable = meta:get_int("variable_" .. slot)
            local stack = inv:get_stack("smoker_main", slot)

            if not stack:is_empty() then
                has_items = true
                if not smoker_is_done_stack(stack) then
                    has_pending = true
                end
            end

            local max_value = 100
            if not stack:is_empty() and not smoker_is_done_stack(stack) and variable < max_value and temperature >= 70 then
                if status == "" then
                    status = "smoking"
                    meta:set_string("status", status)
                end

                -- Increase the variable by a random amount
                variable = variable + math.random(1, 10)

                -- If the variable reaches or exceeds max_value
                if variable >= max_value then
                    local item = stack:get_name()

                    -- Check if a cooked version of the item exists
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

        if not has_items then
            meta:set_string("status", "")
        elseif has_pending and temperature < 70 then
            meta:set_string("status", "too_cold")
        elseif has_pending then
            meta:set_string("status", "smoking")
        else
            meta:set_string("status", "finished")
        end

        -- Update the formspec with the current inventory
        meta:set_string("formspec", smoker_get_formspec(meta:get_string("status")))

        -- Continue the timer
        return true
    end,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        minetest.show_formspec(clicker:get_player_name(), "exile_improved_cooking:smoker", meta:get_string("formspec"))
    end,

    can_dig = function(pos, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local status = meta:get_string("status")

        if smoker_is_full(inv) then
            return false
        end

        if status == "smoking" then
            return false
        end

        return true
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local status = meta:get_string("status")

        if status == "smoking" then
            return 0
        end

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

        if status == "smoking" and (from_list == "smoker_main" or to_list == "smoker_main") then
            return 0
        end

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
            return math.min(count, 1)
        end

        return count
    end,

    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local status = meta:get_string("status")
        if listname == "smoker_main" and status == "smoking" then
            return 0
        end
        if listname == "smoker_main" then
            return math.min(stack:get_count(), 1)
        end
        return stack:get_count()
    end,

    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        -- Check if the listname is the "smoker_main" inventory
        if listname == "smoker_main" then
            -- if the item is taken reset the variable for that slot
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            meta:set_int("variable_" .. index, 0)
            if inv:is_empty("smoker_main") then
                meta:set_string("status", "")
            end
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
        ncrafting.set_firing(pos, base_firing, firing_int)
    end,
    on_timer = function(pos, elapsed)
        --finished product, length
        return ncrafting.fire_pottery(pos, "exile_improved_cooking:smoker_unfired", "exile_improved_cooking:smoker", base_firing)
    end,
})

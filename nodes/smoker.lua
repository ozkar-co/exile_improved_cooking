-- Register the smoker node
minetest.register_node("tech:smoker", {
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

        meta:set_string("formspec", smoker_formspec)

        -- Start the timer
        minetest.get_node_timer(pos):start(smoker_time)

        -- Initialize the variables for each slot
        for slot = 1, 6 do
            meta:set_int("variable_" .. slot, 0)
        end
    end,

    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local temperature = climate.get_point_temp(pos) -- Get the block temperature
        -- Iterate through each slot
        for slot = 1, 6 do
            local variable = meta:get_int("variable_" .. slot)
            local amount = inv:get_stack("smoker_main", slot):get_count()
            -- Define the max value of variable depending on the amount of items on slot
            local max_value = amount * 100
            -- Only increase the variable if it's below max_value and temperature greater than 70
            if variable < max_value and temperature >= 70 then
                -- Increase the variable by a random amount
                variable = variable + math.random(1, 10)

                -- If the variable reaches or exceeds max_value
                if variable >= max_value then
                    local item = inv:get_stack("smoker_main", slot):get_name()

                    -- Check if a cooked version of the item exists
                    local cooked_item = item .. "_cooked"

                    if minetest.registered_items[cooked_item] then
                        -- Replace the item in the slot with its cooked version
                        -- keeping the same amount of the previous stack
                        inv:set_stack("smoker_main", slot, cooked_item .. " " .. amount)

                        variable = 0 -- Reset the variable to 0
                    end
                end

                -- Update the variable in the metadata
                meta:set_int("variable_" .. slot, variable)
            end
        end

        -- Update the formspec with the current inventory
        meta:set_string("formspec", smoker_formspec)

        -- Continue the timer
        return true
    end,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        minetest.show_formspec(clicker:get_player_name(), "tech:smoker", smoker_formspec)
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "smoker_main" then
            if minetest.registered_items[stack:get_name() .. "_cooked"] then
                return stack:get_count()
            end
        end
        return 0
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        -- allow to move from user main to smoker main only if
        -- the item have a _cooked version,
        -- allow to move from smoker main to user main in any case
        if to_list == "smoker_main" then
            local stack = player:get_inventory():get_stack(from_list, from_index)
            if minetest.registered_items[stack:get_name() .. "_cooked"] then
                return count
            end
            return 0
        end
        return count
    end,

    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        -- Check if the listname is the "smoker_main" inventory
        if listname == "smoker_main" then
            -- if the item is taken reset the variable for that slot
            local meta = minetest.get_meta(pos)
            meta:set_int("variable_" .. index, 0)
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
minetest.register_node("tech:smoker_unfired", {
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
        return ncrafting.fire_pottery(pos, "tech:smoker_unfired", "tech:smoker", base_firing)
    end,
})

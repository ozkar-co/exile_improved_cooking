smoker_time = 15

smoker_formspec = "size[8,4.8;]" ..
        "list[current_name;smoker_main;2.5,0.2;3,2;]" ..
        "list[current_player;main;0,2.7;8,4;]"..
        "listring[current_name;smoker_main]"..
        "listring[current_player;main]"

smoker_nodebox = {
        {-0.4375, -0.4375, -0.4375, 0.4375, -0.3125, 0.4375}, -- Base
        {-0.375, -0.5, -0.375, 0.375, -0.25, 0.375}, -- Base
        {-0.3125, -0.25, -0.3125, 0.3125, 0.125, 0.3125}, -- Base
        {-0.25, 0.125, -0.25, 0.25, 0.1875, 0.25}, -- Tody
        {-0.1875, 0.1875, -0.1875, 0.1875, 0.25, 0.1875}, -- Top
        {-0.125, 0.3125, 0, 0, 0.4375, 0.125}, -- Chimney
        {-0.1875, 0.25, -0.0625, 0.0625, 0.3125, 0.1875}, -- Chimney
    }

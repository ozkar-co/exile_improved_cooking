smoker_time = 15

function smoker_get_status_text(status)
        if status == "smoking" then
                return "Status: Smoking food"
        end
        if status == "too_cold" then
                return "Status: Too cold to smoke"
        end
        if status == "finished" then
                return "Status: Smoking finished"
        end
        return "Status: Waiting for food"
end

function smoker_get_formspec(status)
        return "size[8,4.8;]" ..
        "label[0.2,0.2;" .. minetest.formspec_escape(smoker_get_status_text(status)) .. "]" ..
                "list[current_name;smoker_main;2.5,0.6;3,2;]" ..
                "list[current_player;main;0,2.7;8,4;]" ..
                "listring[current_name;smoker_main]" ..
                "listring[current_player;main]"
end

smoker_nodebox = {
        {-0.4375, -0.4375, -0.4375, 0.4375, -0.3125, 0.4375}, -- Base
        {-0.375, -0.5, -0.375, 0.375, -0.25, 0.375}, -- Base
        {-0.3125, -0.25, -0.3125, 0.3125, 0.125, 0.3125}, -- Base
        {-0.25, 0.125, -0.25, 0.25, 0.1875, 0.25}, -- Tody
        {-0.1875, 0.1875, -0.1875, 0.1875, 0.25, 0.1875}, -- Top
        {-0.125, 0.3125, 0, 0, 0.4375, 0.125}, -- Chimney
        {-0.1875, 0.25, -0.0625, 0.0625, 0.3125, 0.1875}, -- Chimney
    }

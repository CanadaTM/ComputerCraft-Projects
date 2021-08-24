Monitor = peripheral.wrap("top")
Graphics_Mode = false
Offset = 1
Ore_Colors = {
    clay = colors.brown,
    glass = colors.lightBlue,
    obsidian = colors.gray,
    ender = colors.green,
    emerald = colors.lime,
    quartz = colors.lightGray,
    diamond = colors.cyan,
    debris = colors.brown,
    iron = colors.orange,
    gold = colors.yellow,
    copper = colors.orange,
    cobalt = colors.blue,
    slime_steel = colors.lightBlue,
    tinkers_bronze = colors.orange,
    rose_gold = colors.pink,
    pig_iron = colors.magenta,
    manyullyn = colors.purple,
    hepatizon = colors.purple,
    queens_slime = colors.green,
    netherite = colors.gray,
    tin = colors.lightGray,
    aluminum = colors.lightGray,
    lead = colors.gray,
    silver = colors.lightGray,
    nickel = colors.yellow,
    zinc = colors.lightGray,
    osmium = colors.lightBlue,
    uranium = colors.green,
    bronze = colors.orange,
    brass = colors.yellow,
    electrum = colors.yellow,
    invar = colors.lightGray,
    constantan = colors.orange,
    pewter = colors.yellow,
    steel = colors.gray
}

local function draw_box_from_center(
    center_x,
    center_y,
    width,
    height,
    color,
    filled
)
    -- defaults
    color = color or colors.white
    filled = filled or false

    if filled then
        paintutils.drawFilledBox(
            math.floor(center_x - (width / 2)),
            math.floor(center_y - (height / 2)),
            math.floor(center_x + (width / 2)),
            math.floor(center_y + (height / 2)),
            color
        )
    else
        paintutils.drawBox(
            math.floor(center_x - (width / 2)),
            math.floor(center_y - (height / 2)),
            math.floor(center_x + (width / 2)),
            math.floor(center_y + (height / 2)),
            color
        )
    end
end

local function draw_tank_graduations(
    width, height, tank_height
)
    -- 1/4
    paintutils.drawLine(
        width-1,
        math.ceil(height-(0.25 * tank_height) - 1),
        width-4,
        math.ceil(height-(0.25 * tank_height) - 1),
        colors.green)
    --1/2
    paintutils.drawLine(
        width-1,
        math.ceil(height-(0.5 * tank_height) - 1),
        width-4,
        math.ceil(height-(0.5 * tank_height) - 1),
        colors.yellow)
    --3/4
    paintutils.drawLine(
        width-1,
        math.ceil(height-(0.75 * tank_height) - 1),
        width-4,
        math.ceil(height-(0.75 * tank_height) - 1),
        colors.red)
end

local function draw_smeltry_tank(width, height)

    local tank_height = height - (2 * Offset)
    term.setPaletteColour(colors.gray, 0x303030)

    -- outline minus top
    draw_box_from_center(
        0.75 * width,
        (height / 2) + Offset,
        width / 2,
        tank_height
    )
    paintutils.drawLine(
        1 + (width / 2),
        Offset * 2,
        width - 1,
        Offset * 2,
        colors.gray
    )

    --graduations
    draw_tank_graduations(
        width, height, tank_height
    )
    return tank_height
end

local function draw_static_gui(monitor)
    local oldterm = term.redirect(monitor)
    --! Now all term.* calls will go to the monitor
    --!   instead

    --? set the monitor to graphics mode and get
    --?   the width and height

    -- term.setGraphicsMode(Graphics_Mode)
    local width, height = term.getSize(
        Graphics_Mode
    )

    term.setBackgroundColor(colours.black)
    term.clear()
    term.setCursorPos(1,1)

    -- draw the smeltry tank
    local tank_height = draw_smeltry_tank(
        width, height
    )

    -- print the title text, centered above the
    --  left half of the screen
    local title = "Smelt.io"
    term.setCursorPos(
        (
            math.floor(width / 2)
            - string.len(title)
        ) / 2,
        1
    )
    term.setBackgroundColor(colors.black)
    print(title)

    --print the smeltery tank label text, centered
    --  above the right half of the screen
    local tank_title = "Smeltery Contents:"
    term.setCursorPos(
        math.ceil(width / 2)
        + ((math.ceil(width / 2)
        - string.len(tank_title)) / 2),
        1
    )
    term.setBackgroundColor(colors.black)
    print(tank_title)
    -- sleep(5)

    -- clear code
    -- term.setBackgroundColor(colours.black)
    -- term.clear()
    -- term.setCursorPos(1,1)

    term.redirect(oldterm)
    --! Now the term.* calls will draw on the
    --!   terminal again
    return tank_height
end

local function fill_gui_tank(
    smeltery_contents,
    max_fluids,
    width,
    height,
    tank_height
)

    local function fill_box()

        --TODO: Put ore text, centered, over spots in gui

        -- clear tank contents
        draw_box_from_center(
            0.75 * width, (height / 2) + Offset,
            (width / 2) - 2,
            tank_height - 2,
            colors.black,
            true
        )

        --draw fluids
        local next_y = height - 1
        local total_liquids = 0
        for _, value in ipairs(smeltery_contents) do
            local ore = string.sub(value.name, 19)
            local metal_amount = value.amount
            total_liquids =
                total_liquids + value.amount

            paintutils.drawFilledBox(
                width - 1,
                next_y,
                (width / 2) + 1,
                (
                    next_y
                    - (
                        (metal_amount / max_fluids)
                        * tank_height
                    )
                ),
                Ore_Colors[ore] or colors.lightGray
            )

                next_y = next_y - (((metal_amount / max_fluids) * tank_height) * 0.8) - 1
        end

        -- redraw graduations
        draw_tank_graduations(
            width, height, tank_height
        )

        return total_liquids
    end

    local total_liquids = fill_box()

    return total_liquids / max_fluids
end

local function read_smeltery()
    local smeltery = peripheral.wrap(
        "tconstruct:smeltery_0"
    )
    local duct = peripheral.wrap(
        "tconstruct:duct_0"
    )
    local lava_tank = peripheral.wrap(
        "tconstruct:tank_0"
    )

    local item_capacity = smeltery.size()
    local ingot_capacity = item_capacity * 8
    local fluid_capacity = ingot_capacity * 144

    local contents = duct.tanks()

    local fuel_contents = lava_tank.tanks()
    local fuel_level = 0
    local fuel_capacity = table.getn(
        fuel_contents
    ) * 4000

    for _, value in ipairs(fuel_contents) do
        fuel_level = fuel_level + value.amount
    end

    return {
        max_ingots = ingot_capacity,
        max_fluids = fluid_capacity,
        smeltery_contents = contents,
        max_fuel = fuel_capacity,
        fuel_fill_level = fuel_level / fuel_capacity
    }

end

local function print_smeltery_details(
    width,
    current_fill_level,
    ingot_capacity,
    fluid_capacity,
    current_fuel_level,
    fuel_capacity
)
    term.setCursorPos(1, 3)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    local max_string_lenght = math.floor(width / 2)

    print("Smeltery Details:\n")
    print(
        "Fill Ammount: " .. string.format(
            "%.3f%%", current_fill_level * 100
        ) .. "\n"
    )

    local ingot_capacity_string =
        "Ingot Capacity: "
        .. ingot_capacity
        .. " Ingots"

    if (
        string.len(ingot_capacity_string)
        < max_string_lenght
    ) then
        print(ingot_capacity_string)
    else
        print(
            "Ingot Capacity: \n\t"
            .. ingot_capacity
            .. " Ingots\n"
        )
    end

    local fluid_capacity_string =
        "Fluid Capacity: "
        .. fluid_capacity
        .. "mb\n"

    if (
        string.len(fluid_capacity_string)
        < max_string_lenght
    ) then
        print(fluid_capacity_string)
    else
        print(
            "Fluid Capacity: \n\t"
            .. fluid_capacity
            .. "mb\n"
        )
    end

    local fuel_level_string =
    "Fuel Level: "
    .. string.format(
        "%.3f%%", current_fuel_level * 100
    )
    .. " of "
    .. fuel_capacity
    .. "mb"

    if (
        string.len(fuel_level_string)
        < max_string_lenght
    ) then
        print(fuel_level_string)
    else
        print(
            "Fuel Level: \n\t"
            .. string.format(
                "%.3f%%", current_fuel_level * 100
            )
            .. " of "
            .. fuel_capacity
            .. "mb"
        )
    end
end

local function main()
    Monitor.setTextScale(0.75)

    local tank_height = draw_static_gui(Monitor)

    local oldterm = term.redirect(Monitor)
    --! Now all term.* calls will go to the monitor
    --!   instead

    local width, height = term.getSize(
        Graphics_Mode
    )

    term.setCursorPos(1, 6)
    local read_data = read_smeltery()

    local current_fill_level = fill_gui_tank(
        read_data["smeltery_contents"],
        read_data["max_fluids"],
        width,
        height,
        tank_height
    )

    print_smeltery_details(
        width,
        current_fill_level,
        read_data["max_ingots"],
        read_data["max_fluids"],
        read_data["fuel_fill_level"],
        read_data["max_fuel"]
    )

    term.redirect(oldterm)
    --! Now the term.* calls will draw on the
    --!   terminal again
end

main()
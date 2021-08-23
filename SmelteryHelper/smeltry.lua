Monitor = peripheral.wrap("left")
Graphics_Mode = false
Offset = 1

local function draw_box_from_center(center_x, center_y, width, height, color, filled)
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

local function draw_tank_graduations(width, height, tank_height)
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
        math.floor(height-(0.5 * tank_height)),
        width-4,
        math.floor(height-(0.5 * tank_height)),
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
    draw_box_from_center(0.75 * width, (height / 2) + Offset, width / 2, tank_height)
    paintutils.drawLine(1 + (width / 2), Offset * 2, width - 1, Offset * 2, colors.gray)

    --graduations
    draw_tank_graduations(width, height, tank_height)
    return tank_height
end

local function draw_static_gui(monitor)
    local oldterm = term.redirect(monitor)
    --! Now all term.* calls will go to the monitor instead

    --? set the monitor to graphics mode and get the width and height
    term.setGraphicsMode(Graphics_Mode)
    local width, height = term.getSize(Graphics_Mode)

    term.setBackgroundColor(colours.black)
    term.clear()
    term.setCursorPos(1,1)

    -- draw the smeltry tank
    local tank_height = draw_smeltry_tank(width, height)

    -- print the title text, centered above the left half of the screen
    local title = "Smelt.io"
    term.setCursorPos(math.ceil((math.floor(width / 2) - string.len(title)) / 2), 1)
    term.setBackgroundColor(colors.black)
    print(title)

    --print the smeltery tank label text, centered above the right half of the screen
    local tank_title = "Smeltery Contents:"
    term.setCursorPos(math.ceil(width / 2) + ((math.ceil(width / 2) - string.len(tank_title)) / 2), 1)
    term.setBackgroundColor(colors.black)
    print(tank_title)
    -- sleep(5)

    -- clear code
    -- term.setBackgroundColor(colours.black)
    -- term.clear()
    -- term.setCursorPos(1,1)

    term.redirect(oldterm)
    --! Now the term.* calls will draw on the terminal again
    return tank_height
end

local function fill_tank(current_fill_level, fill_ammount, width, height, tank_height)

    local function fill_box(fill_level)
        draw_box_from_center(0.75 * width, (height / 2) + Offset, (width / 2) - 2, tank_height - 2, colors.black, true)
        paintutils.drawFilledBox((width / 2) + 1, height - (current_fill_level + fill_level) * (tank_height - 2), width-1, height-1, colors.lightBlue)

        draw_box_from_center(0.25 * width, (height / 2) + Offset, (width / 2) - 2, tank_height - 2, colors.black, true)
        term.setCursorPos(1, height / 2)
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        print("Start X: " .. (width / 2) + 2)
        print("Start Y: " .. height - (fill_level * (tank_height - 1)))
        print("End X: " .. width-1)
        print("End Y: " .. height-1)
        print("Current Fill %: " .. current_fill_level)
        print("Fill Ammount: " .. fill_ammount)
    end

    fill_box(fill_ammount)

    return current_fill_level + fill_ammount
end

local function main()
    Monitor.setTextScale(0.5)
    local width, height = term.getSize(Graphics_Mode)
    local current_fill_level = 0

    local tank_height = draw_static_gui(Monitor)

    local oldterm = term.redirect(Monitor)
    --! Now all term.* calls will go to the monitor instead

    for i=0,tank_height - 1 do
        current_fill_level = fill_tank(current_fill_level, 1 / (tank_height - 1), width, height, tank_height)
        draw_tank_graduations(width, height, tank_height)
        print(i)
        sleep(1)
    end

    term.redirect(oldterm)
    --! Now the term.* calls will draw on the terminal again
end

main()
local function defineGlobals()
    --[[
        Here I'll put the coordinates of the turtle at
        it's home so that we can refference it later
        to allow the turtle to go back to it's home.
    ]]
    HOME_X, HOME_Y, HOME_Z = 106, -16, -3642
    EXTRA_ITEM = 16
    MODEM = peripheral.wrap("left")
    CURRENT_TOOL = "" 
    TOOL = {}
end

local function faceDirection(direction)

    if direction == FACING then return end

    if direction == "north" then
        if FACING == "east" then
            turtle.turnLeft()
            FACING = direction
            return
        elseif FACING == "west" then
            turtle.turnRight()
            FACING = direction
            return
        elseif FACING == "south" then
            turtle.turnLeft()
            turtle.turnLeft()
            FACING = direction
            return
        end
    elseif direction == "east" then
        if FACING == "north" then
            turtle.turnRight()
            FACING = direction
            return
        elseif FACING == "south" then
            turtle.turnLeft()
            FACING = direction
            return
        elseif FACING == "west" then
            turtle.turnLeft()
            turtle.turnLeft()
            FACING = direction
            return
        end
    elseif direction == "south" then
        if FACING == "east" then
            turtle.turnRight()
            FACING = direction
            return
        elseif FACING == "west" then
            turtle.turnLeft()
            FACING = direction
            return
        elseif FACING == "north" then
            turtle.turnLeft()
            turtle.turnLeft()
            FACING = direction
            return
        end
    elseif direction == "west" then
        if FACING == "north" then
            turtle.turnLeft()
            FACING = direction
            return
        elseif FACING == "south" then
            turtle.turnRight()
            FACING = direction
            return
        elseif FACING == "east" then
            turtle.turnLeft()
            turtle.turnLeft()
            FACING = direction
            return
        end
    end
end

local function gotoLocation(target_x, target_y, target_z)
    local current_x, current_y, current_z = gps.locate(5)

    if not current_x then
        error("couldn't get coords for some reason...")
    end

    if (
        current_x == target_x
            and current_y == target_y
            and current_z == target_z
        ) then return end

    -- X component
    if current_x < target_x then
        faceDirection("east")
        for i = current_x, target_x - 1, 1 do
            turtle.forward()
        end
    elseif current_x > target_x then
        faceDirection("west")
        for i = current_x, target_x + 1, -1 do
            turtle.forward()
        end
    end

    -- Z component
    if current_z < target_z then
        faceDirection("south")
        for i = current_z, target_z - 1, 1 do
            turtle.forward()
        end
    elseif current_z > target_z then
        faceDirection("north")
        for i = current_z, target_z + 1, -1 do
            turtle.forward()
        end
    end

    -- Y component
    if current_y < target_y then
        for i = current_y, target_y - 1, 1 do
            turtle.up()
        end
    elseif current_y > target_y then
        for i = current_y, target_y + 1, -1 do
            turtle.down()
        end
    end
end

local function determineFacing()
    local initial_x, _, initial_z = gps.locate()
    turtle.forward()
    local changed_x, _, changed_z = gps.locate()
    if changed_x == initial_x and changed_z == initial_z then
        turtle.up()
        turtle.back()
        initial_x, _, initial_z = gps.locate()
        turtle.forward()
        changed_x, _, changed_z = gps.locate()
        turtle.down()
    end

    --[[
        This will be used to keep track of the turtles
        current heading so that turtle will be
        able to easily go back to it's home position.

        Notes:

        going north is -Z
        going east is +X
        going south is +Z
        going west is -X
    ]]
    if changed_x > initial_x then
        FACING = "east"
        return
    elseif changed_x < initial_x then
        FACING = "west"
        return
    elseif changed_z > initial_z then
        FACING = "south"
        return
    elseif changed_z < initial_z then
        FACING = "north"
        return
    end

end

local function hasValue (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function isPowered()
    gotoLocation(107, -16, -3645)
    faceDirection("south")
    local conduit = peripheral.wrap("right")

    if conduit.getEnergy() > 0 then
        gotoLocation(HOME_X, HOME_Y, HOME_Z)
        return true
    end
    gotoLocation(HOME_X, HOME_Y, HOME_Z)
    return false
end

local function main()
    defineGlobals()

    determineFacing()
    faceDirection("north")

    gotoLocation(HOME_X, HOME_Y, HOME_Z)

    if peripheral.wrap("right") then
        CURRENT_TOOL = "player-detector"
    elseif
        CURRENT_TOOL = "pickaxe"
    end

    if CURRENT_TOOL == "pickaxe" then
        prev_selection = turtle.getSelectedSlot()
        turtle.select(EXTRA_ITEM)
        turtle.equipRight()
        turtle.select(prev_selection)
    end

    TOOL = peripheral.wrap("right")

    -- Mainloop
    while true do
        if hasValue(TOOL.getOnlinePlayers(), "Canada_TM") then
            turtle.select(EXTRA_ITEM)
            turtle.equipRight()
            if not isPowered() then
                faceDirection("north")
                turtle.select(1)
                turtle.up()
                turtle.place()
                sleep(10)
                turtle.dig()
                turtle.down()
            end
            turtle.select(EXTRA_ITEM)
            turtle.equipRight()
        end
        sleep(15)
    end
end
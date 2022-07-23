local function defineGlobals()
    --[[
        Here I'll put the coordinates of the turtle at
        it's home so that we can refference it later
        to allow the turtle to go back to it's home.
    ]]
    HOME_X, HOME_Y, HOME_Z = 2634, 82, -4459
end

local function searchBoxForItems()
    local inv_contents = peripheral.call("bottom", "list")

    for _, item in ipairs(inv_contents) do
        if (
            string.match(item.name, "stone")
                or string.match(item.name, "_log")
            ) then
            return true
        end
    end
    return false
end

local function faceDirection(direction)

    if direction == FACING then return end

    if direction == "north" then
        if FACING == "east" then
            turtle.turnLeft()
            FACING = direction
            return
        elseif direction == "west" then
            turtle.turnRight()
            FACING = direction
            return
        elseif direction == "south" then
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

local function determineFacing()
    turtle.up()
    local initial_x, _, initial_z = gps.locate()
    turtle.forward()
    local changed_x, _, changed_z = gps.locate()
    turtle.back()
    turtle.down()

    --[[
        This will be used to keep track of the turtles
        current heading so that the turtal will be
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

local function gotoLocation(target_x, target_y, target_z)
    current_x, current_y, current_z = gps.locate(5)

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
        for i = current_x, target_x, 1 do
            turtle.forward()
        end
    elseif current_x > target_x then
        faceDirection("west")
        for i = current_x, target_x, -1 do
            turtle.forward()
        end
    end

    -- Z component
    if current_z < target_z then
        faceDirection("south")
        for i = current_z, target_z, 1 do
            turtle.forward()
        end
    elseif current_z > target_z then
        faceDirection("north")
        for i = current_z, target_z, -1 do
            turtle.forward()
        end
    end

    -- Y component
    if current_y < target_y then
        for i = current_y, target_y, 1 do
            turtle.up()
        end
    elseif current_y > target_y then
        for i = current_y, target_y, -1 do
            turtle.down()
        end
    end
end

local function doFullDaisy()

end

local function main()
    -- Init
    defineGlobals()

    determineFacing()
    faceDirection("south")

    gotoLocation(HOME_X, HOME_Y, HOME_Z)

    -- Mainloop
    while true do
        -- Only do the thing when there's stuff in the box
        while searchBoxForItems() do
            local inv_contents = peripheral.call("bottom", "list")
            local important_items = {}

            for _, item in ipairs(inv_contents) do
                if (
                    string.match(item.name, "stone")
                        or string.match(item.name, "_log")
                    ) then
                    table.insert(important_items, item)
                end
            end
        end
    end
end

main()

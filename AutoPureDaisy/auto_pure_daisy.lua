local function defineGlobals()
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
    FACING = "south"

    --[[
        Here I'll get the coordinates of the turtle at
        it's home so that we can refference it later
        to allow the turtle to go back to it's home.
    ]]
    HOME_X, HOME_Y, HOME_Z = gps.locate(5)
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

local function faceSouth()
    if FACING == "south" then return
    elseif FACING == "east" then
        turtle.turnRight()
        return
    elseif FACING == "west" then
        turtle.turnLeft()
        return
    elseif FACING == "north" then
        turtle.turnLeft()
        turtle.turnLeft()
        return
    end
end

local function determineFacing()
    turtle.up()
    local initial_x, _, initial_z = gps.locate()
    turtle.forward()
    local changed_x, _, changed_z = gps.locate()
    turtle.back()
    turtle.down()

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

local function doFullDaisy()

end

local function main()
    -- Init
    defineGlobals()

    determineFacing()
    faceSouth()

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

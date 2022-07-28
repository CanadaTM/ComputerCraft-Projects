local function defineGlobals()
    --[[
        Here I'll put the coordinates of the turtle at
        it's home so that we can refference it later
        to allow the turtle to go back to it's home.
    ]]
    HOME_X, HOME_Y, HOME_Z = 2634, 82, -4459
    CONVERSION_TIME = 26.5
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
        turtle.back()
        initial_x, _, initial_z = gps.locate()
        turtle.forward()
        changed_x, _, changed_z = gps.locate()
    end

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

local function searchBoxForItems()
    gotoLocation(HOME_X - 1, HOME_Y, HOME_Z)
    local inv_contents = peripheral.call("bottom", "list")

    for i, item in pairs(inv_contents) do
        print(textutils.serialize(item))
        if (
            string.match(item.name, "stone")
                or string.match(item.name, "_log")
            ) then
            return true
        end
    end
    return false
end

local function prepareInventory(item_type, item_list)
    gotoLocation(HOME_X - 1, HOME_Y, HOME_Z)
    INV = peripheral.wrap("bottom")
    TRANSFER_INV = peripheral.wrap("top")
    INV_NAME = peripheral.getName(INV)
    TRANSFER_INV_NAME = peripheral.getName(TRANSFER_INV)

    for index, item in pairs(item_list) do
        if string.match(item.name, item_type) then
            INV.pushItems(TRANSFER_INV_NAME, index)
        end
    end

    for _ = 0, 16, 1 do
        turtle.suckUp()
    end

    gotoLocation(HOME_X, HOME_Y, HOME_Z)
    faceDirection("south")

    local count = 0

    for i = 1, 16, 1 do
        count = count + turtle.getItemCount(i)
    end

    return count
end

local function doFullDaisy()
    --! This assumes that the turtle is above the bottom right corner of the pure daisy, facing toward the top right corner

    -- Placing
    turtle.placeDown()
    turtle.forward()
    for i = 0, 2, 1 do
        turtle.placeDown()
        turtle.forward()
        turtle.placeDown()
        turtle.turnLeft()
        turtle.forward()
    end
    turtle.placeDown()
    turtle.forward()
    turtle.turnLeft()

    sleep(CONVERSION_TIME)

    -- Collecting
    turtle.digDown()
    turtle.forward()
    for i = 0, 2, 1 do
        turtle.digDown()
        turtle.forward()
        turtle.digDown()
        turtle.turnLeft()
        turtle.forward()
    end
    turtle.digDown()
    turtle.forward()
    turtle.turnLeft()
end

local function doPartialDaisy(amount)
    turtle.placeDown()
    if amount >= 2 then
        turtle.forward()
        turtle.placeDown()
    end
    if amount >= 3 then
        turtle.forward()
        turtle.placeDown()
    end
    if amount >= 4 then
        turtle.turnLeft()
        turtle.forward()
        turtle.placeDown()
    end
    if amount >= 5 then
        turtle.forward()
        turtle.placeDown()
    end
    if amount >= 6 then
        turtle.turnLeft()
        turtle.forward()
        turtle.placeDown()
    end
    if amount == 7 then
        turtle.forward()
        turtle.placeDown()
    end
    determineFacing()
    gotoLocation(HOME_X, HOME_Y + 1, HOME_Z + 1)
    faceDirection("south")
    sleep(CONVERSION_TIME + 2)

    turtle.digDown()
    if amount >= 2 then
        turtle.forward()
        turtle.digDown()
    end
    if amount >= 3 then
        turtle.forward()
        turtle.digDown()
    end
    if amount >= 4 then
        turtle.turnLeft()
        turtle.forward()
        turtle.digDown()
    end
    if amount >= 5 then
        turtle.forward()
        turtle.digDown()
    end
    if amount >= 6 then
        turtle.turnLeft()
        turtle.forward()
        turtle.digDown()
    end
    if amount == 7 then
        turtle.forward()
        turtle.digDown()
    end
end

local function convertBlocks(block_type, inventory)
    local item_count = prepareInventory(block_type, inventory)
    local slots_used = math.ceil(item_count / 64)
    local full_ops = math.floor(item_count / 8)
    local final_op = item_count % 8

    -- get in position
    --[[
                o o o
                o d o
                o o o <- going there
            ]]
    turtle.up()
    turtle.forward()

    -- doing full daisy runs
    if full_ops > 8 then
        for i = 1, slots_used, 1 do
            turtle.select(i)
            for _ = 1, 8, 1 do
                doFullDaisy()
            end
        end
    else
        for _ = 1, full_ops, 1 do
            doFullDaisy()
        end
    end

    -- doing the final bit
    doPartialDaisy(final_op)

    determineFacing()
    gotoLocation(HOME_X, HOME_Y, HOME_Z)
    faceDirection("south")
end

local function dumpInventory()
    gotoLocation(HOME_X - 1, HOME_Y, HOME_Z)
    faceDirection("north")
    for i = 1, 16, 1 do
        turtle.select(i)
        turtle.drop()
    end
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
        if searchBoxForItems() then
            local inv_contents = peripheral.call("bottom", "list")
            local important_items = {}

            for index, item in pairs(inv_contents) do
                if (
                    string.match(item.name, "stone")
                        or string.match(item.name, "_log")
                    ) then
                    table.insert(important_items, index, item)
                end
            end

            -- Stone first
            convertBlocks("stone", important_items)

            -- Dump inventory
            dumpInventory()

            -- Logs second
            convertBlocks("_log", important_items)

            -- Dump inventory
            dumpInventory()
        end
    end
end

main()

local function defineGlobals()
    print("Globals Defined!")
end

local function searchBoxForItems()
    local inv_contents = peripheral.call("bottom", "list")

    for i, item in ipairs(inv_contents) do
        if (
            string.match(item.name, "stone")
                or string.match(item.name, "_log")
            ) then
            print("Found either logs or stone!")
            return true
        end
    end
    print("No logs or stone found!")
    return false
end

local function main()
    -- Init
    defineGlobals()

    -- Mainloop
    while true do
        -- Only do the thing when there's stuff in the box
        while searchBoxForItems() do
            print("It's working!")
        end
    end
end

main()

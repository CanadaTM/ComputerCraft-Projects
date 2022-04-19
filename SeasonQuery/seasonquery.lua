Chatbox = peripheral.find("chatBox")
RSI = peripheral.find("redstoneIntegrator")

-- Season Sensor Locations
FallLocation = "north"
WinterLocation = "east"
SpringLocation = "south"
SummerLocation = "west"

local function getSeason()
    if RSI.getInput(FallLocation) then
        return "Fall"
    elseif RSI.getInput(WinterLocation) then
        return "Winter"
    elseif RSI.getInput(SpringLocation) then
        return "Spring"
    elseif RSI.getInput(SummerLocation) then
        return "Summer"
    end
end

local function main()
    local currentSeason = getSeason()

    while true do
        --! looks like this pull event from Advanced Peripherals isn't working(?) so for now it's disabled.
        --!   Uncomment to allow for asking for the current season.
        -- local _, username, message = os.pullEvent("chat")

        -- if string.find(message, "season") and string.find(message, "?") then
        --     Chatbox.sendMessage(
        --         "Well " .. username .. ", It is currently:" .. currentSeason,
        --         "DeeDee Megadoodoo"
        --     )
        -- end

        if getSeason() ~= currentSeason then
            currentSeason = getSeason()

            Chatbox.sendMessage(
                "The season has changed!",
                "DeeDee Megadoodoo"
            )

            sleep(1)

            Chatbox.sendMessage(
                "It is now: " .. currentSeason,
                "DeeDee Megadoodoo"
            )
        end

        sleep(0)
    end
end

main()

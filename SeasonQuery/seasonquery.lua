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
        local _, username, message = os.pullEvent("chat")
        if getSeason() ~= currentSeason then
            currentSeason = getSeason()
            chatBox.sendMessage(
                "The season has changed!",
                "DeeDee Megadoodoo"
            )
            sleep(1)
            chatBox.sendMessage(
                "It is now:" .. currentSeason,
                "DeeDee Megadoodoo"
            )
        end

        if message:find("season") and message:find("?") then
            chatBox.sendMessage(
                "Well " .. username .. ", It is currently:" .. currentSeason,
                "DeeDee Megadoodoo"
            )
        end

        sleep(0)
    end
end

main()

local function defineGlobals()
    ReactorPeriph = ""
    ChatBoxPeriph = ""
    ChatBotName = "ZControl"

    local periphs = peripheral.getNames()

    for _, value in ipairs(periphs) do
        local periph_type = peripheral.getType(value)

        if periph_type == "fissionReactor" then
            ReactorPeriph = value
        elseif periph_type == "chatBox" then
            ChatBoxPeriph = value
        end
    end
end

local function monitor(reactor, chatbox, kill_temp)
    local current_temp = reactor.getTemperature()

    if current_temp > kill_temp then
        reactor.scram()
        chatbox.sendMessage(
            "Reactor stopped due to high temperature.",
            ChatBotName
        )
        return false
    else
        return true
    end
end

local function initialize(reactor, chatbox)
    reactor.scram()
    chatbox.sendMessage(
        "Looks like this program just started, rebooting the reactor to monitor accurately",
        ChatBotName
    )
    reactor.activate()
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function findOptimalBurnRate(reactor)
    reactor.setBurnRate(0)
    local current_burn_rate = 0
    local previous_temp = reactor.getTemperature()
    local increments = {5, 1, 0.1, 0.01}
    local unsafe_rates = {}

    print("Finding optimal burn rate...\n")

    for index, value in ipairs(increments) do
        local safe = true

        print("Testing in increments of " .. value .. "mb/t")

        while safe do

            -- so we can yield
            sleep(0)

            -- increment the burn rate by the current increment.
            current_burn_rate = current_burn_rate + value

            if has_value(unsafe_rates, current_burn_rate) then
                break
            end

            -- setup a variable to keep track of whether or not the temperature is increasing
            local increase_count = 0

            -- set the reactor to the new burn rate and turn on the reactor
            reactor.setBurnRate(current_burn_rate)
            reactor.activate()
            print("Testing if " .. current_burn_rate .. "mb/t is stable...")

            for timer = 0, ((index + 2) * 50), 1 do
                -- get the current temp with 2 decimals precision
                local current_temp = tonumber(string.format("%.2f", reactor.getTemperature()))

                -- this will make sure we don't check the temperature change the first time we loop through
                if timer ~= 0 then

                    -- increase the increase_count variable to note that the temperature increased this loop
                    if current_temp > previous_temp then
                        increase_count = increase_count + 1
                    end

                    -- if we've increased a sufficient number of times this loop, we note it and kill the loop.
                    if increase_count > 20 then
                        -- turn off the reactor
                        reactor.scram()

                        safe = false
                        print(current_burn_rate .. "mb/t was not safe, going to next precision level")

                        -- add the value to the unsafe_rates table so we don't test the rate again
                        table.insert(unsafe_rates, current_burn_rate)

                        -- rollback the burn rate
                        current_burn_rate = current_burn_rate - value
                        previous_temp = current_temp

                        -- allow cooling time
                        sleep(1)
                        break
                    end
                end

                -- set the previous_temp variable to use for the next loop
                previous_temp = current_temp
            end

            if current_burn_rate == reactor.getMaxBurnRate() then
                break
            end

            if safe then
                print("Safe, continuing...")
            end
        end

        if current_burn_rate == reactor.getMaxBurnRate() then
            break
        end
    end
    print(current_burn_rate .. "mb/t is the optimal burn rate.")
    reactor.setBurnRate(current_burn_rate)
    reactor.activate()
end

local function main()
    defineGlobals()

    local reactor = peripheral.wrap(ReactorPeriph)
    local chatbox = peripheral.wrap(ChatBoxPeriph)

    initialize(reactor, chatbox)

    findOptimalBurnRate(reactor, chatbox)

    while true do
        while (
            monitor(reactor, chatbox, 750)
        ) do sleep(0) end
        chatbox.sendMessage(
            "The reactor was stopped before meltdown, do you want to reboot it?",
            ChatBotName
        )
        local _, username, message = os.pullEvent("chat")
        if message:lower() == "yes" and username == "Canada_TM" then
            chatbox.sendMessage(
                "Of course, my liege",
                ChatBotName
            )
        else
            chatbox.sendMessage(
                "Keeping reactor off until you manually reboot it.",
                ChatBotName
            )
        end
    end
end

main()
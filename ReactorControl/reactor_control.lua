local function defineGlobals()
    ReactorPeriph = ""
    ChatBoxPeriph = ""

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
            "Hey idiot, I stopped a meltdown due to your negligence.",
            "ReactorBot"
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
        "ReactorBot"
    )
    reactor.activate()
end

local function findOptimalBurnRate(reactor, chatbox)
    reactor.setBurnRate(0)
    local current_burn_rate, timer = 0, 0
    local safe = true

    -- coarse locating
    while safe do
        sleep(0)
        current_burn_rate = current_burn_rate + 5
        timer = 0
        reactor.setBurnRate(current_burn_rate)
        reactor.activate()
        while reactor.getTemperature() < 750 do
            timer = timer + 1
            sleep(0)
            if timer == 300 then
                break
            end
        end
        reactor.scram()
        if timer ~= 300 then
            sleep(1)
            safe = false
            current_burn_rate = current_burn_rate - 5
        end

        if current_burn_rate == 20 then
            break
        end
    end

    safe = true
    -- medium locating
    while safe and current_burn_rate < 20 do
        sleep(0)
        current_burn_rate = current_burn_rate + 1
        timer = 0
        reactor.setBurnRate(current_burn_rate)
        reactor.activate()
        while reactor.getTemperature() < 750 do
            timer = timer + 1
            sleep(0)
            if timer == 300 then
                break
            end
        end
        reactor.scram()
        if timer ~= 300 then
            sleep(1)
            safe = false
            current_burn_rate = current_burn_rate - 1
        end
    end

    safe = true
    -- fine locating
    while safe and current_burn_rate < 20 do
        sleep(0)
        current_burn_rate = current_burn_rate + 0.1
        timer = 0
        reactor.setBurnRate(current_burn_rate)
        reactor.activate()
        while reactor.getTemperature() < 750 do
            timer = timer + 1
            sleep(0)
            if timer == 600 then
                break
            end
        end
        reactor.scram()
        if timer ~= 600 then
            sleep(1)
            safe = false
            current_burn_rate = current_burn_rate - 0.1
        end
    end

    safe = true
    -- ultrafine locating
    while safe and current_burn_rate < 20 do
        sleep(0)
        current_burn_rate = current_burn_rate + 0.01
        timer = 0
        reactor.setBurnRate(current_burn_rate)
        reactor.activate()
        while reactor.getTemperature() < 750 do
            timer = timer + 1
            sleep(0)
            if timer == 600 then
                break
            end
        end
        reactor.scram()
        if timer ~= 600 then
            sleep(1)
            safe = false
            current_burn_rate = current_burn_rate - 0.01
        end
    end

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
            "ReactorBot"
        )
        local _, username, message = os.pullEvent("chat")
        if message:lower() == "yes" and username == "Canada_TM" then
            chatbox.sendMessage(
                "Of course, my liege",
                "ReactorBot"
            )
        else
            chatbox.sendMessage(
                "Keeping reactor off until you manually reboot it.",
                "ReactorBot"
            )
        end
    end
end

main()
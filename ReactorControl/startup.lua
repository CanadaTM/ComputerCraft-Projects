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

local function main()
    defineGlobals()

    pcall(shell.run("reactor_control"))
    peripheral.wrap(ReactorPeriph).scram()
    peripheral.wrap(ChatBoxPeriph).sendMessage(
        "The reactor_control program crashed, stopping reactor",
        "ReactorBot"
    )
end

main()
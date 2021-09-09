Chatbox = peripheral.find("chatBox")
JamCount = 0

while true do
    local event, username, message = os.pullEvent("chat")

    if message == ":catjam:" then
        JamCount = JamCount + 1
        Chatbox.sendMessage(
            ":catjam: " .. JamCount, "Jambot"
        )
    end

    if message:lower() == "we jamming?" then
        local jam_chance = math.random(100)

        sleep(5)
        if jam_chance == 1 then
            Chatbox.sendMessage(
                "Now is not the time to jam. :feelsbadman:",
                "Jambot"
            )
        elseif jam_chance >= 2 and jam_chance <= 15 then
            Chatbox.sendMessage(
                "I am uncertain if now is the time to jam.",
                "Jambot"
            )
        elseif jam_chance > 15 and jam_chance <= 99 then
            Chatbox.sendMessage(
                ":catjam: We're jamming! :catjam:",
                "Jambot"
            )
        else
            Chatbox.sendMessage(
                ":catjam::catjam::catjam::catjam::catjam:"
                .. ":catjam::catjam::catjam::catjam::catjam:\n"
                .. ":catjam: Real jam hours :catjam:"
                .. ":catjam::catjam::catjam::catjam::catjam:"
                .. ":catjam::catjam::catjam::catjam::catjam:\n",
                "Jambot"
            )
        end
    end
end
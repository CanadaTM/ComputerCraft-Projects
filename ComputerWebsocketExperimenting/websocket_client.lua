json = require("json")

local function connect_websocket()
    local ws, err = http.websocket("ws://localhost:5757/computer")
    if not ws then
        return printError(err)
    end

    ws.send("CC Computer Connected")

    return ws
end

local function handler(ws)
    local terminated = false
    local timer = 1
    while not terminated do
        local message = ws.receive(1)

        if message then
            message = json.decode(message)

            if message["command"] == "eval" then
                print('Trying to run: [ ' .. message["data"] .. ' ]')
                assert(load(message["data"]))()
            end
        end
    end
end

local function main()
    local websocket = connect_websocket()

    handler(websocket)

    --! Don't forget to close the connection!
    websocket.close()
end

main()

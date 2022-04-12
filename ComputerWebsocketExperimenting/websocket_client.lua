local ws, err = http.websocket("ws://localhost:5757")
if not ws then
    return printError(err)
end

ws.send("cc_computer_connected")
local response = ws.receive()
print(response)

-- Don't forget to close the connection!
ws.close()

local ws, err = http.websocket("ws://localhost:5757")
if not ws then
    return printError(err)
end

ws.send("Hello world!")
local response = ws.receive()
assert(response == "Hello world!", "Received wrong response!")
print(response)

-- Don't forget to close the connection!
ws.close()

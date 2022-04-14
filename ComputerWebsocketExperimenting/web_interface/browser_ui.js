const websocket = new WebSocket("ws://localhost:5757/browser");

function ProcessMessage() {
    const input_text = document.getElementById("textbox").value;
    websocket.send("toComputer->eval`" + input_text);
}

function TerminateConnection() {
    websocket.send("terminate");
    websocket.close();
}

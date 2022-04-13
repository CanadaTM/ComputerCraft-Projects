const websocket = new WebSocket("ws://localhost:5757/browser");

websocket.addEventListener("open", (event) => {
    websocket.send("Browser Connected");
});

function delay(time) {
    return new Promise((resolve) => setTimeout(resolve, time));
}

function ProcessMessage() {
    const input_text = document.getElementById("textbox").value;
    websocket.send("toComputer->eval`" + input_text);
}

function TerminateConnection() {
    websocket.send("terminate");
    websocket.close();
}

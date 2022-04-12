const websocket = new WebSocket("ws://localhost:5757");

websocket.addEventListener("open", (event) => {
    websocket.send("browser_connected");
});

function ProcessMessage() {
    const input_text = document.getElementById("textbox").value;
    websocket.send(input_text);

    websocket.onmessage = ({ data }) => {
        const message = document.createElement("P");
        const content = document.createTextNode(data);
        message.appendChild(content);
        document.body.appendChild(message);
    };
}

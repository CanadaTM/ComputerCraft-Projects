import asyncio
import json
from typing import Dict
import websockets


class CustomWebSocketServer:
    def __init__(self, host="127.0.0.1", port=5757):

        self.host: str = host
        self.port: int = port

        self.ws_clients: set = set()

    async def run(self):

        # Queue to allow moving data from client_handler to Task_consumer
        self.queue_rx: asyncio.Queue = asyncio.Queue()

        # Start consumer task
        consumer: asyncio.Task = asyncio.create_task(self.task_consumer())

        # Start and run WS Server to handle incoming connections
        await websockets.serve(self.client_handler, self.host, self.port)

        await asyncio.Future()  # run forever

        await self.queue_rx.join()
        consumer.cancel()

    # Websockets client Handler accepts data and puts it into queue
    async def client_handler(self, ws, path: str):
        print(f"Connected with path '{path}'")
        try:
            # Register ws client
            self.ws_clients.add(ws)

            async for msg_rx in ws:

                if not msg_rx:
                    break

                print(f"RX: {msg_rx}")

                # Add to Queue
                await self.queue_rx.put((msg_rx, path))

        finally:

            self.ws_clients.remove(ws)

            print(f"Disconnected from Path '{path}'")

    async def task_consumer(self):
        print("task consumer start")
        # get elements from Queue
        while True:
            data: str
            path: str
            data, path = await self.queue_rx.get()

            # Process them like storing to file or forward to other code
            print(f"{data = }, {path = }")  # print as stand-in for more complex code

            if path == "/browser" and "toComputer->" in data:

                payload: Dict[str, str] = {
                    "command": data[12:].split("`")[0],
                    "data": data[12:].split("`")[1],
                }
                await self.send_to_computer(payload)

            self.queue_rx.task_done()

    async def send_to_computer(self, payload: Dict[str, str]):
        for ws in self.ws_clients:
            if ws.path == "/computer":
                await ws.send(json.dumps(payload))

    async def computer_watchdog(self):
        pass


if __name__ == "__main__":
    Server = CustomWebSocketServer()
    asyncio.run(Server.run())

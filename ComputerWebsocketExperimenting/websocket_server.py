#!/usr/bin/env python

import asyncio
import websockets


async def handler(websocket):
    await connect_browser(websocket)
    await connect_cc_computer(websocket)

    print("browser and computer connected successfully!")


async def connect_browser(websocket):
    message = await websocket.recv()
    print(f"Recieved: {message}")

    if message == "browser_connected":
        print("Browser connection established")


async def connect_cc_computer(websocket):
    message = await websocket.recv()
    print(f"Recieved: {message}")

    if message == "cc_computer_connected":
        print("ComputerCraft Computer connection established")


async def main():
    stop = asyncio.Future()
    async with websockets.serve(handler, "", 5757):
        await stop


if __name__ == "__main__":
    asyncio.run(main())

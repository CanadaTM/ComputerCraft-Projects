import asyncio
from websockets import serve


async def echo(websocket):
    async for message in websocket:
        await websocket.send(f"{message} from the server")


async def main():
    async with serve(echo, "localhost", 5757):
        await asyncio.Future()  # run forever


asyncio.run(main())

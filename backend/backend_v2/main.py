import asyncio
import websockets
from rooms_manager import RoomManager
from websocket_proxy import WebSocketProxy, handle_connection

room_manager = RoomManager()
websocket_proxy = WebSocketProxy(room_manager)

async def main():
    print("Iniciando el servidor WebSocket en ws://localhost:6789...")
    async with websockets.serve(lambda ws, path: handle_connection(ws, path, websocket_proxy), "localhost", 6789):
        print("Servidor WebSocket corriendo y listo para aceptar conexiones...")
        await asyncio.Future()  # Mantener el servidor activo

if __name__ == "__main__":
    asyncio.run(main())

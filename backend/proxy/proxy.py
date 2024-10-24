from flask import Flask, request, jsonify
import asyncio
import websockets

app = Flask(__name__)

EXTERNAL_WEBSOCKET_URL = ""

# Crear una función async para enviar mensajes y manejar WebSocket por cada solicitud
async def send_message_to_websocket(message):
    async with websockets.connect(EXTERNAL_WEBSOCKET_URL) as websocket:
        try:
            print(f"Enviando mensaje: {message}")  # Log del mensaje enviado
            await websocket.send(message)
            response = await websocket.recv()
            print(f"Respuesta recibida: {response}")  # Log de la respuesta recibida
            return response
        except websockets.ConnectionClosed as e:
            return f"Conexión cerrada por el servidor WebSocket: {str(e)}"
        except Exception as e:
            return f"Error al enviar el mensaje: {str(e)}"

@app.route('/send_message', methods=['POST'])
def send_message():
    message = request.json.get('message')
    if not message:
        return jsonify({"error": "No se recibió ningún mensaje"}), 400

    # Usar asyncio para manejar la comunicación WebSocket
    response = asyncio.run(send_message_to_websocket(message))
    
    return jsonify({"response": response})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

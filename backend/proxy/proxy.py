from flask import Flask, request, jsonify
import json
import websocket

app = Flask(__name__)

# Función para interactuar con WebSocket
def interact_with_websocket(data):
    try:
        ws = websocket.create_connection("ws://127.0.0.1:6789")  # Dirección del WebSocket
        ws.send(json.dumps(data))  # Enviar datos al WebSocket
        response = ws.recv()  # Recibir la respuesta del WebSocket
        ws.close()
        return response
    except Exception as e:
        return json.dumps({"error": f"WebSocket error: {str(e)}"})

# Ruta que recibe la solicitud de Godot
@app.route('/godot_action', methods=['POST'])
def godot_action():
    # Obtener los datos enviados por Godot
    action = request.form.get('action')
    player_name = request.form.get('player_name')
    room_code = request.form.get('room_code')

    if not action or not player_name:
        return jsonify({"error": "Faltan parámetros en la solicitud"}), 400

    if action == "create_room":
        # Crear el JSON que se enviará al WebSocket
        websocket_data = {
            "command": "create_room",
            "player_name": player_name
        }
        
        # Interactuar con el WebSocket
        ws_response = interact_with_websocket(websocket_data)
        
        # Procesar la respuesta del WebSocket
        try:
            ws_response_json = json.loads(ws_response)
            if ws_response_json.get('status') == 'room_created':
                room_code = ws_response_json.get('room_code', 'Desconocido')
                return jsonify({"status": "room_created", "room_code": room_code}), 200
            else:
                return jsonify({"error": "Error al crear la sala"}), 500
        except json.JSONDecodeError:
            return jsonify({"error": "Respuesta no válida del WebSocket"}), 500

    elif action == "join_room":
        if not room_code:
            return jsonify({"error": "Falta el código de la sala"}), 400

        # Crear el JSON que se enviará al WebSocket
        websocket_data = {
            "command": "join_room",
            "player_name": player_name,
            "room_code": room_code
        }
        
        # Interactuar con el WebSocket
        ws_response = interact_with_websocket(websocket_data)
        
        # Procesar la respuesta del WebSocket
        try:
            ws_response_json = json.loads(ws_response)
            if ws_response_json.get('status') == 'joined':
                return jsonify({"status": "joined", "room_code": room_code}), 200
            else:
                return jsonify({"error": ws_response_json.get('error', 'Error desconocido al unirse a la sala')}), 500
        except json.JSONDecodeError:
            return jsonify({"error": "Respuesta no válida del WebSocket"}), 500

    return jsonify({"error": "Acción no reconocida"}), 400

if __name__ == '__main__':
    app.run(debug=True)

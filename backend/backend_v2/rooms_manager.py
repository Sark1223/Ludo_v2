import uuid
from player import Player
from board import Board
from random import choice

class RoomManager:
    def __init__(self):
        self.rooms = {}

    def create_room(self, host_name, websocket):
        room_code = str(uuid.uuid4())[:6]  # Genera un código de sala único de 6 caracteres
        available_colors = ["red", "blue", "green", "yellow"]  # Colores disponibles para los jugadores
        
        # Asigna un color fijo al host o elige aleatoriamente un color
        host_color = available_colors[0]
        
        self.rooms[room_code] = {
            "host": host_name,
            "players": {host_name: Player(host_name, websocket, color=host_color, is_host=True)},
            "board": Board(),
            "is_started": False,
            "turn_order": [],
            "current_turn": 0
        }
        return room_code

    def join_room(self, room_code, player_name, websocket):
        room = self.rooms.get(room_code)
        if room and len(room["players"]) < 4:
            if player_name not in room["players"]:
                # Asignamos un color disponible al nuevo jugador
                assigned_colors = [player.color for player in room["players"].values()]
                available_colors = ["red", "blue", "green", "yellow"]
                available_colors = [color for color in available_colors if color not in assigned_colors]
                
                if not available_colors:
                    return False  # No hay colores disponibles
                
                player_color = available_colors[0]
                player = Player(player_name, websocket, color=player_color)
                room["players"][player_name] = player
                return True
        return False

    def start_game(self, room_code):
        room = self.rooms.get(room_code)
        if room and len(room["players"]) >= 2:
            room["is_started"] = True
            room["turn_order"] = list(room["players"].keys())
            room["current_turn"] = 0
            return True
        return False

    def get_current_player(self, room_code):
        room = self.rooms.get(room_code)
        if room and room["is_started"]:
            turn_order = room["turn_order"]
            return turn_order[room["current_turn"]]
        return None

    def next_turn(self, room_code):
        room = self.rooms.get(room_code)
        if room and room["is_started"]:
            room["current_turn"] = (room["current_turn"] + 1) % len(room["turn_order"])

    def get_room(self, room_code):
        return self.rooms.get(room_code, None)

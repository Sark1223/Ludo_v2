import json
from game_rules import GameRules

class WebSocketProxy:
    def __init__(self, room_manager):
        self.room_manager = room_manager

    async def process_message(self, message, websocket):
        data = json.loads(message)
        command = data.get("command")
        room_code = data.get("room_code")
        player_name = data.get("player_name")
        
        if command == "create_room":
            room_code = self.room_manager.create_room(player_name, websocket)
            return json.dumps({"status": "room_created", "room_code": room_code})

        elif command == "join_room":
            success = self.room_manager.join_room(room_code, player_name, websocket)
            return json.dumps({"status": "joined" if success else "failed"})

        elif command == "start_game":
            started = self.room_manager.start_game(room_code)
            return json.dumps({"status": "started" if started else "waiting_for_players"})

        elif command == "roll_dice":
            room = self.room_manager.get_room(room_code)
            if not room:
                return json.dumps({"status": "error", "message": "Invalid room code"})

            if player_name != self.room_manager.get_current_player(room_code):
                return json.dumps({"status": "error", "message": "Not your turn"})

            dice_roll = data.get("dice_roll")
            player = room["players"].get(player_name)
            if player:
                game_rules = GameRules(room["board"])
                piece_index = data.get("piece_index", 0)  # Índice de la ficha a mover
                move_result = game_rules.move_piece(player, piece_index, dice_roll)

                if move_result["win"]:
                    return json.dumps({"status": "win", "player": player_name})

                self.room_manager.next_turn(room_code)
                return json.dumps({
                    "status": "rolled",
                    "player": player_name,
                    "position": move_result["new_position"],
                    "next_turn": self.room_manager.get_current_player(room_code)
                })

        elif command == "send_message":
            message_content = data.get("message")
            return json.dumps({"status": "message_sent", "message": message_content, "from": player_name})

        return json.dumps({"status": "unknown_command"})


async def handle_connection(websocket, path, websocket_proxy):
    async for message in websocket:
        response = await websocket_proxy.process_message(message, websocket)
        if response:
            await websocket.send(response)

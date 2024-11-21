class Player:
    def __init__(self, name, websocket, color, is_host=False):
        self.name = name
        self.websocket = websocket
        self.color = color
        self.is_host = is_host
        self.pieces = [0, 0, 0, 0]  # Cada jugador tiene 4 piezas
        self.is_safe = [False] * 4
        self.finished_pieces = 0  # Conteo de piezas en la meta

class Board:
    def __init__(self):
        self.safe_zones = [0, 8, 16, 24, 32, 40]  # Zonas seguras genéricas
        self.finish_line = 56  # Última casilla
        self.base_positions = {
            "red": [-1, -2, -3, -4],
            "blue": [-5, -6, -7, -8],
            "green": [-9, -10, -11, -12],
            "yellow": [-13, -14, -15, -16],
        }
        self.final_paths = {
            "red": [57, 58, 59, 60],
            "blue": [61, 62, 63, 64],
            "green": [65, 66, 67, 68],
            "yellow": [69, 70, 71, 72],
        }

    def is_safe_zone(self, position):
        return position in self.safe_zones

    def is_in_final_path(self, color, position):
        return position in self.final_paths[color]

    def reset_to_base(self, color, piece_index):
        return self.base_positions[color][piece_index]

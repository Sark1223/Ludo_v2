class GameRules:
    def __init__(self, board):
        self.board = board

    def move_piece(self, player, piece_index, dice_roll):
        current_position = player.pieces[piece_index]
        
        # Si la pieza está en la base, necesita un 6 para salir
        if current_position < 0:
            if dice_roll == 6:
                player.pieces[piece_index] = 0  # Sale de la base
            return

        # Calcular nueva posición
        new_position = current_position + dice_roll
        
        # Revisar si alcanza la meta
        if new_position > self.board.finish_line:
            excess = new_position - self.board.finish_line
            if excess <= len(self.board.final_paths[player.color]):
                new_position = self.board.final_paths[player.color][excess - 1]
            else:
                new_position = self.board.finish_line  # Rebota en la meta

        # Actualizar posición
        player.pieces[piece_index] = new_position
        player.is_safe[piece_index] = self.board.is_safe_zone(new_position)

    def check_capture(self, players, current_player, piece_index):
        current_piece_position = current_player.pieces[piece_index]
        
        for player in players:
            if player != current_player:
                for i, position in enumerate(player.pieces):
                    if position == current_piece_position and not player.is_safe[i]:
                        # Capturar pieza enemiga y enviarla a la base
                        player.pieces[i] = self.board.reset_to_base(player.color, i)

    def check_win(self, player):
        return player.finished_pieces == 4

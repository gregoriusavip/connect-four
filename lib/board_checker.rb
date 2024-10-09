# frozen-string-literal: true

# Check for winners
module BoardChecker
  def check_winner(last = @last_move)
    return false if last.nil? || @board[last[0]][last[1]].nil?

    @piece = @board[@last_move[0]][@last_move[1]]
    check_horizontal || check_vertical || check_diagonal_right || check_diagonal_left
  end

  def tie?
    !check_winner && @board[0].all? { |piece| !piece.nil? }
  end

  private

  def check_horizontal
    upcoming_pos = [@last_move[1] - 1, @last_move[1] + 1]
    winner_horizontal(upcoming_pos[0], upcoming_pos[1])
  end

  def check_vertical
    upcoming_pos = [@last_move[0] - 1, @last_move[0] + 1]
    winner_vertical(upcoming_pos[0], upcoming_pos[1])
  end

  def check_diagonal_right
    upcoming_pos = [[@last_move[0] + 1, @last_move[1] - 1], [@last_move[0] - 1, @last_move[1] + 1]]
    winner_diagonal_right(upcoming_pos[0], upcoming_pos[1])
  end

  def check_diagonal_left
    upcoming_pos = [[@last_move[0] - 1, @last_move[1] - 1], [@last_move[0] + 1, @last_move[1] + 1]]
    winner_diagonal_left(upcoming_pos[0], upcoming_pos[1])
  end

  def winner_horizontal(prev_pos, next_pos)
    total = count_horizontal_pieces(prev_pos, 1, -1)
    count_horizontal_pieces(next_pos, total, 1).eql? 4
  end

  def winner_vertical(prev_pos, next_pos)
    total = count_vertical_pieces(prev_pos, 1, -1)
    count_vertical_pieces(next_pos, total, 1).eql? 4
  end

  def winner_diagonal_right(prev_pos, next_pos)
    total = count_diagonal_right_pieces(prev_pos, 1, -1)
    count_diagonal_right_pieces(next_pos, total, 1).eql? 4
  end

  def winner_diagonal_left(prev_pos, next_pos)
    total = count_diagonal_left_pieces(prev_pos, 1, -1)
    count_diagonal_left_pieces(next_pos, total, 1).eql? 4
  end

  def count_vertical_pieces(pos, total, acc)
    next_piece = pos.between?(0, @max_row - 1) ? @board[pos][@last_move[1]] : nil
    return total if !@piece.eql?(next_piece) || total.eql?(4)

    count_vertical_pieces(pos + acc, total + 1, acc)
  end

  def count_horizontal_pieces(pos, total, acc)
    next_piece = @board[@last_move[0]][pos]
    return total if !@piece.eql?(next_piece) || total.eql?(4)

    count_horizontal_pieces(pos + acc, total + 1, acc)
  end

  def count_diagonal_right_pieces(pos, total, acc) # rubocop:disable Metrics/AbcSize
    next_piece = pos[0].between?(0, @max_row - 1) && pos[1].between?(0, @max_column - 1) ? @board[pos[0]][pos[1]] : nil
    return total if !@piece.eql?(next_piece) || total.eql?(4)

    pos[0] = pos[0] - acc
    pos[1] = pos[1] + acc
    count_diagonal_right_pieces(pos, total + 1, acc)
  end

  def count_diagonal_left_pieces(pos, total, acc) # rubocop:disable Metrics/AbcSize
    next_piece = pos[0].between?(0, @max_row - 1) && pos[1].between?(0, @max_column - 1) ? @board[pos[0]][pos[1]] : nil
    return total if !@piece.eql?(next_piece) || total.eql?(4)

    pos[0] = pos[0] + acc
    pos[1] = pos[1] + acc
    count_diagonal_left_pieces(pos, total + 1, acc)
  end
end

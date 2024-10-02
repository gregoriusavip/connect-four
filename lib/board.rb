# frozen-string-literal: true

# row n by column m Connect Four board
class Board
  attr_reader :board, :last_move

  def initialize(row = 6, column = 7)
    @max_row = row
    @max_column = column
    @board = Array.new(row) { Array.new(column) }
  end

  def add_piece(piece, column)
    return nil unless column.between?(1, @max_column)

    cur_row = @max_row - 1
    cur_row -= 1 until board[cur_row][column - 1].nil? || cur_row.negative?
    return nil if cur_row.negative?

    @last_move = [cur_row, column - 1]
    board[cur_row][column - 1] = piece
  end
end

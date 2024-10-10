# frozen-string-literal: true

require_relative '../lib/board'

describe Board do
  describe '#add_piece' do
    max_column = 7
    max_row = 6

    context 'when adding any piece to an empty board' do
      subject(:empty_board) { described_class.new }

      it 'returns the piece if the piece is sucessfully added to the board' do
        result = empty_board.add_piece(:piece, 1)
        expect(result).to eq(:piece)
      end

      it "returns nil if the piece is added to a column bigger than #{max_column}" do
        result = empty_board.add_piece(:piece, max_column + 1) # out of range
        expect(result).to be_nil
      end

      it 'does not update last_move if the piece failed to be added' do
        expect { empty_board.add_piece(:piece, max_column + 1) }.not_to(change(empty_board, :last_move))
      end

      it 'updates last_move if the piece is sucessfully added' do
        column = 1
        expect { empty_board.add_piece(:piece, column) }.to change(empty_board, :last_move).to [5, column - 1]
      end

      it 'returns nil if the piece is added to a column less than 1' do
        result = empty_board.add_piece(:piece, 0) # out of range
        expect(result).to be_nil
      end

      1.upto(7) do |n|
        it "puts the piece to the lowest row, column #{n}" do
          expect { empty_board.add_piece(:piece, n) }.to change {
            empty_board.board[max_row - 1][n - 1]
          }.from(nil).to(:piece)
        end
      end
    end

    context 'when adding any piece with the lowest row filled' do
      subject(:lowest_filled_board) { described_class.new }

      before do # fill the lowest column
        1.upto(7) { |n| lowest_filled_board.add_piece(:piece, n) }
      end

      1.upto(7) do |n|
        it "puts the piece to the 2nd lowest row, column #{n}" do
          expect { lowest_filled_board.add_piece(:piece, n) }.to change {
            lowest_filled_board.board[max_row - 2][n - 1]
          }.from(nil).to(:piece)
        end
      end
    end

    context 'when the first column is filled' do
      subject(:filled_column_board) { described_class.new }

      before do # fill the first column
        max_column.times { filled_column_board.add_piece(:piece, 1) }
      end

      it 'does not change the board from adding new piece on a filled first column' do
        expect { filled_column_board.add_piece(:new_piece, 1) }.not_to(change(filled_column_board, :board))
      end

      it 'returns nil from adding new piece on a filled first column' do
        result = filled_column_board.add_piece(:new_piece, 1)
        expect(result).to be_nil
      end

      it 'changes the board when filling 2nd column' do
        expect { filled_column_board.add_piece(:new_piece, 2) }.to(change(filled_column_board, :board))
      end
    end
  end

  describe '#check_winner' do
    subject(:winner_game) { described_class.new }

    context 'when no move has been done' do
      it 'returns false' do
        result = winner_game.check_winner(nil)
        expect(result).to be false
      end
    end

    context 'when last move contains no winning pattern' do
      it 'returns false' do
        winner_game.add_piece(:piece, 5)
        result = winner_game.check_winner
        expect(result).to be false
      end
    end

    context 'when last move contains horizontal winning pattern' do
      it 'returns true' do
        1.upto(4) { |column| winner_game.add_piece(:piece, column) }
        result = winner_game.check_winner
        expect(result).to be true
      end
    end

    context 'when last move contains vertical winning pattern' do
      it 'returns true' do
        4.times { winner_game.add_piece(:piece, 3) }
        result = winner_game.check_winner
        expect(result).to be true
      end
    end

    context 'when last move contains diagonal right winning pattern' do
      before do # create diagonal right winning pattern
        win_piece = :win_piece
        dud_piece = :dud_piece
        1.upto(3) do |i|
          i.times { winner_game.add_piece(dud_piece, i + 1) }
        end
        4.times { |i| winner_game.add_piece(win_piece, i + 1) }
      end

      it 'returns true' do
        result = winner_game.check_winner
        expect(result).to be true
      end
    end

    context 'when last move contains diagonal left winning pattern' do
      before do # create diagonal left winning pattern
        win_piece = :win_piece
        dud_piece = :dud_piece
        column = 4
        1.upto(3) do |i|
          i.times { winner_game.add_piece(dud_piece, column) }
          column -= 1
        end
        column = 5
        4.times do
          winner_game.add_piece(win_piece, column)
          column -= 1
        end
      end

      it 'returns true' do
        result = winner_game.check_winner
        expect(result).to be true
      end
    end
  end

  describe '#tie?' do
    context 'when the board is empty board' do
      subject(:no_tie_board) { described_class.new }

      it 'returns false' do
        result = no_tie_board.tie?
        expect(result).to be false
      end
    end

    context 'when the board has no moves remaining' do
      subject(:tie_board) { described_class.new }

      before do # fill the board
        dud_piece = :dud_piece
        columns = 6
        rows = 6
        rows.times do |row|
          columns.times { tie_board.add_piece(dud_piece, row + 1) }
        end

        (columns - 1).times { tie_board.add_piece(dud_piece, 7) }
      end

      it 'returns true if the last move contains no winning patter' do
        tie_board.add_piece(:piece, 7)
        result = tie_board.tie?
        expect(result).to be true
      end

      it 'returns false if the last move contains a winning pattern' do
        tie_board.add_piece(:dud_piece, 7)
        result = tie_board.tie?
        expect(result).to be false
      end
    end
  end
end

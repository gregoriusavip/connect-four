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

    context 'when adding any piece with the lowest and 2nd lowest row filled' do
      subject(:third_row_board) { described_class.new }

      before do # fill the lowest and 2nd lowest column
        2.times { 1.upto(7) { |n| third_row_board.add_piece(:piece, n) } }
      end

      1.upto(7) do |n|
        it "puts the piece to the 3rd lowest row, column #{n}" do
          expect { third_row_board.add_piece(:piece, n) }.to change {
            third_row_board.board[max_row - 3][n - 1]
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
end

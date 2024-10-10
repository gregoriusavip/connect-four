# frozen-string-literal: true

require_relative '../lib/connect_four'
require_relative '../lib/board'

describe ConnectFour do
  describe '#play_game' do
    subject(:game_ends) { described_class.new(end_board) }

    let(:end_board) { instance_double(Board) }

    before do
      allow(end_board).to receive(:add_piece)
      allow(game_ends).to receive(:player_input)
    end

    context 'when the board detects an ending sequence' do
      it 'sends the message to check if there is a winner once if there is a winning sequence' do
        allow(end_board).to receive_messages(check_winner: true)
        game_ends.play_game
        expect(end_board).to have_received(:check_winner).once
      end

      it 'ends the game if a tie is detected' do
        allow(end_board).to receive_messages(check_winner: false, tie?: true)
        game_ends.play_game
        expect(end_board).to have_received(:tie?).once
      end

      it 'ends the game if there is a winner after 4 moves' do
        allow(end_board).to receive(:tie?).and_return(false)
        allow(end_board).to receive(:check_winner).and_return(false, false, false, true)
        game_ends.play_game
        expect(end_board).to have_received(:check_winner).exactly(4).times
      end

      it 'ends the game if there is a tie after 4 moves' do
        allow(end_board).to receive(:tie?).and_return(false, false, false, true)
        allow(end_board).to receive(:check_winner).and_return(false)
        game_ends.play_game
        expect(end_board).to have_received(:tie?).exactly(4).times
      end
    end

    context 'when the game is in progress' do
      before do
        allow(end_board).to receive(:tie?).and_return(false)
        allow(end_board).to receive(:check_winner).and_return(false, false, false, true)
      end

      it "asks for player's input at least once" do
        game_ends.play_game
        expect(game_ends).to have_received(:player_input).at_least(1)
      end

      it 'sends message to add piece at least once' do
        game_ends.play_game
        expect(end_board).to have_received(:add_piece).at_least(1)
      end
    end
  end

  describe '#player_input' do
    subject(:game_input) { described_class.new }

    context 'when the input is 42 then 4' do
      let(:invalid_input) { '42' }
      let(:valid_input) { '4' }

      before do
        allow(game_input).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game_input).to receive(:transform_input).and_return(nil, 4)
      end

      it 'returns 4 as an integer' do
        result = game_input.player_input
        expect(result).to eq(4)
      end

      it 'asks for user input twice' do
        game_input.player_input
        expect(game_input).to have_received(:gets).twice
      end
    end

    context 'when the input is 7' do
      let(:valid_input) { '7' }

      before do
        allow(game_input).to receive_messages(gets: valid_input, transform_input: 7)
      end

      it 'returns 7 as an integer' do
        result = game_input.player_input
        expect(result).to eq(7)
      end

      it 'asks for user input once' do
        game_input.player_input
        expect(game_input).to have_received(:gets).once
      end
    end
  end
end

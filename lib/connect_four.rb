# frozen-string-literal: true

require_relative('board')

# A game of connect four
class ConnectFour
  def initialize(board = Board.new)
    @board = board
    @players = %i[A B]
  end

  def play_game
    turn = 0
    loop do
      player = @players[turn % 2]
      turn += 1 unless player_turn(player).nil?
      break if game_over?(player)
    end
  end

  def transform_input(input)
    return nil unless input.match?(/^\s*[1-9]+\s*$/)

    input = input.to_i
    input.between?(1, 7) ? input : nil
  end

  def player_input
    loop do
      puts('Input a number from 1 to 7')
      input = gets.chomp
      validated_input = transform_input(input)
      validated_input.nil? ? puts("#{input} is not a valid input") : (return validated_input)
    end
  end

  private

  def player_turn(player)
    puts "Player's #{player} turn"
    @board.add_piece(player, player_input)
  end

  def game_over?(player)
    if @board.check_winner
      puts "Congratulations! #{player}"
      return true
    elsif @board.tie?
      puts "It's a tie!"
      return true
    end
    false
  end
end

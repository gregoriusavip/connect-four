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
      player_turn(player).nil? ? (puts 'piece could not be added') : turn += 1
      break if game_over?(player)
    end
    @board.print_board
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

  def transform_input(input)
    return nil unless input.match?(/^\s*[1-9]+\s*$/)

    input = input.to_i
    input.between?(1, 7) ? input : nil
  end

  def player_turn(player)
    @board.print_board
    puts "Player's #{player} turn"
    @board.add_piece(player, player_input)
  end

  def game_over?(player)
    if @board.check_winner
      puts "Congratulations! #{player}. You have won the game!"
      return true
    elsif @board.tie?
      puts "It's a tie!"
      return true
    end
    false
  end
end

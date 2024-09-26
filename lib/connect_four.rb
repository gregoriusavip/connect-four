# frozen-string-literal: true

# A game of connect four
class ConnectFour
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
end

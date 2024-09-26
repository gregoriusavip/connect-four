# frozen-string-literal: true

# A game of connect four
class ConnectFour
  def validate_input(input)
    return nil unless input.match?(/^\s*[1-9]+\s*$/)

    input = input.to_i
    input.between?(1, 7) ? input : nil
  end

  def player_input
    loop do
      input = gets.chomp
      validated_input = validate_input(input)
      validated_input.nil? ? puts("#{input} is not a valid input") : (return validated_input)
    end
  end
end

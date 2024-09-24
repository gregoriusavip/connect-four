# frozen-string-literal: true

# A game of connect four
class ConnectFour
  def validate_input(input)
    return nil unless input.match?(/^\s*[1-9]+\s*$/)

    input = input.chomp.to_i
    input.between?(1, 7) ? input : nil
  end
end

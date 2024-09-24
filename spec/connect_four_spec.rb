# frozen-string-literal: true

require_relative '../lib/connect_four'

describe ConnectFour do
  describe '#validate_input' do
    subject(:game_validation) { described_class.new }

    context 'when testing inputs from 1 to 7 as a string' do
      1.upto(7) do |n|
        it "returns #{n} when the input is #{n}" do
          result = game_validation.validate_input(n.to_s)
          expect(result).to be(n)
        end
      end
    end

    context 'when testing inputs outside of the 1 to 7 range' do
      out_of_range = ['0', '8', '-5', '12'].freeze

      out_of_range.each do |input|
        it "returns nil when the input is #{input}" do
          result = game_validation.validate_input(input)
          expect(result).to be_nil
        end
      end
    end

    context 'when testing inputs with a mix of numerical and nonnumerical' do
      mixed_inputs = { '5@' => nil, '@5' => nil, ' _3 ' => nil, '3_' => nil, 'a4' => nil, '5 5' => nil,
                       '  3  ' => 3, ' 5' => 5 }

      mixed_inputs.each do |input, value|
        it "returns #{value.inspect} when the input is #{input}" do
          result = game_validation.validate_input(input)
          expect(result).to be(value)
        end
      end
    end
  end
end

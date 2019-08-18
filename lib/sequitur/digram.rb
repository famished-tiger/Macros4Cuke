# frozen_string_literal: true

# File: digram.rb

module Sequitur # Module for classes implementing the Sequitur algorithm
  # In linguistics, a digram is a sequence of two letters.
  # In Sequitur, a digram is a sequence of two consecutive symbols that
  # appear in a production rule. Each symbol in a digram
  # can be a terminal or not.
  class Digram
    # The sequence of two consecutive grammar symbols.
    #   The two symbols should respond to the :hash message.
    attr_reader(:symbols)

    # An unique hash key of the digram
    attr_reader(:key)

    # The production in which the digram occurs
    attr_reader(:production)

    # Constructor.
    # A digram represents a sequence of two symbols
    # (that appears in a rhs of a production).
    # Terminal symbols must respond to the :hash message.
    # @param symbol1 [StringOrSymbol] First element of the digram
    # @param symbol2 [StringOrSymbol] Second element of the digram
    # @param aProduction [Production] Production in which the RHS
    #   the sequence symbol1 symbol2 appears.
    def initialize(symbol1, symbol2, aProduction)
      @symbols = [symbol1, symbol2]
      @key = symbol1.hash.to_s(16) + ':' + symbol2.hash.to_s(16)
      @production = aProduction
    end

    # Equality testing.
    #   true iff keys of both digrams are equal, false otherwise
    # @param other [Digram] another to compare with
    # @return [true/false]
    def ==(other)
      return key == other.key
    end

    # Does the digram consists of twice the same symbols?
    # @return [true/false] true when symbols.first == symbols.last
    def repeating?
      return symbols[0] == symbols[1]
    end
  end # class
end # module

# End of file

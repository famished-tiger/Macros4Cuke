# frozen_string_literal: true

require 'sequitur' # Load the Sequitur library

#
# Purpose: show how to apply Sequitur on a stream of integer values
#
input_sequence = [1, 2, 1, 2, 3, 1, 2, 3, 4, 1, 2, 3, 4, 5]

# Generate the grammar from the sequence
grammar = Sequitur.build_from(input_sequence)


# Use a formatter to display the grammar rules on the console output
formatter = Sequitur::Formatter::BaseText.new(STDOUT)

# Now render the rules
formatter.render(grammar.visitor)

# Rendered output is:
# start : P1 P2 P3 P3 5.
# P1 : 1 2.
# P2 : P1 3.
# P3 : P2 4.

# Playing a bit with the API
# Access last symbol from rhs of start production:
last_symbol_p0 = grammar.start.rhs.symbols[-1]
puts last_symbol_p0 # => 5

# Access first symbol from rhs of P1 production:
first_symbol_p1 = grammar.productions[1].rhs.symbols[0]

puts first_symbol_p1 # => 1

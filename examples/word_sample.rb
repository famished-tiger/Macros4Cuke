# frozen_string_literal: true

require 'sequitur' # Load the Sequitur library

#
# Purpose: show how to apply Sequitur on a stream of text words
#

# Raw input is one String containing repeated sentences...
raw_input = <<-SNIPPET
Error: unknown character '?' at position 6
Error: illegal character '%' at position 20
Error: unknown character '/' at position 9
SNIPPET

# Convert into a sequence of words
input_sequence = raw_input.scan(/\w+/)
# Generate the grammar from the sequence
grammar = Sequitur.build_from(input_sequence)


# Use a formatter to display the grammar rules on the console output
formatter = Sequitur::Formatter::BaseText.new(STDOUT)

# Now render the rules
formatter.render(grammar.visitor)

# Rendered output is:
# start : P2 6 Error illegal P1 20 P2 9.
# P1 : character at position.
# P2 : Error unknown P1.

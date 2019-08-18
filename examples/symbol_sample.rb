# frozen_string_literal: true

require 'sequitur' # Load the Sequitur library

#
# Purpose: show how to apply Sequitur on a stream of Symbol values
#
input_sequence = %i[
  aa bb aa bb cc
  aa bb cc dd aa
  bb cc dd ee
]

# Generate the grammar from the sequence
grammar = Sequitur.build_from(input_sequence)

# Use a formatter to display the grammar rules on the console output
formatter = Sequitur::Formatter::BaseText.new(STDOUT)

# Now render the rules
formatter.render(grammar.visitor)

# Rendered output is:
# start : P1 P2 P3 P3 ee.
# P1 : aa bb.
# P2 : P1 cc.
# P3 : P2 dd.

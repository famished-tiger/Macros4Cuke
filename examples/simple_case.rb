# frozen_string_literal: true

require 'sequitur' # Load the Sequitur library

# Purpose: show how to apply Sequitur on a stream of single characters
input_sequence = 'ababcabcdabcde' # Let's analyze this string

# The SEQUITUR algorithm will detect the repeated 'ab' pattern
# and will generate a context-free grammar that represents the input string
grammar = Sequitur.build_from(input_sequence)

# To display the grammar rules on the console output
# We use a formatter
formatter = Sequitur::Formatter::BaseText.new(STDOUT)

# Now render the rules. Each rule is displayed with the format:
# rule_id : a_sequence_grammar_symbols.
# Where:
# - rule_id is either 'start' or a name like 'Pxxxx' (xxxx is a sequential number)
# - a grammar symbol is either a terminal symbol
# (i.e. a character from the input) or a rule id
formatter.render(grammar.visitor)

# Rendered output is:
# start : P1 P2 P3 P3 e.
# P1 : a b.
# P2 : P1 c.
# P3 : P2 d.

# frozen_string_literal: true

require 'sequitur' # Load the Sequitur library

# Purpose: demo to show that sequitur gem works on example from sequitur.info website
input_sequence = <<-SNIPPET
pease porridge hot,
pease porridge cold,
pease porridge in the pot,
nine days old.

some like it hot,
some like it cold,
some like it in the pot,
nine days old.
SNIPPET

grammar = Sequitur.build_from(input_sequence)

# To display the grammar rules on the console output
# We use a formatter
formatter = Sequitur::Formatter::BaseText.new(STDOUT)

# Now render the rules.
formatter.render(grammar.visitor)

# Rendered output is:
# start : P2 P8 P3 P10 P3 P12 P9 P8 P11 P10 P11 P12.
# P1 : e  .
# P2 : p e a s P4 r r i d g P1.
# P3 : P5 P2.
# P4 : P1 p o.
# P5 : ,
# .
# P6 : i n.
# P7 : o l d.
# P8 : h o t.
# P9 : s o m P1 l i k P1 i t  .
# P10 : c P7.
# P11 : P5 P9.
# P12 : P6   t h P4 t P5 n P6 P1 d a y s P7 .

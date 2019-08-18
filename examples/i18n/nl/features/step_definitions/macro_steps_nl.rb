# frozen_string_literal: true

# "Vertaling" in het Nederlands van macrostappen van Macros4Cuke
# Dit zijn stappen definities dat rechstreeks het API van Macros4Cuke gebruiken


Gegeven(/^dat ik de stap "(?:Gegeven dat|Als|Dan) ik \[((?:[^\\\]]|\\.)+)\](:?)" definieër als:$/) do |macro_phrase, colon_capture, template|
  use_table = (colon_capture == ':')
  add_macro(macro_phrase, template, use_table)
end


Als(/^ik \[((?:[^\\\]]|\\.)+)\]$/) do |macro_phrase|
  # This will call the macro with the given phrase
  invoke_macro(macro_phrase)
end


Als(/^ik \[([^\]]+)\]:$/) do |macro_phrase, table_argument|
  # Ensure that the second argument is of the correct type
  unless table_argument.kind_of?(Cucumber::Ast::Table)
    error_message = 'Deze stap vereist een tabel als parameter.'
    raise(Macros4Cuke::DataTableNotFound, error_message)
  end

  # This will call the macro with the given phrase.
  # The second argument consists of an array with couples
  # of the kind: [argument name, actual value]
  invoke_macro(macro_phrase, table_argument.raw)
end

# End of file

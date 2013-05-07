# encoding: utf-8
# Définitions de pas de scénarios utilisant Macros4Cuke.


Etantdonné(/^que je crée le pas "(?:Soit|Quand|Alors) j(?:e |')\[((?:[^\\\]]|\\.)+)\](:?)" qui équivaut à:$/) do |macro_phrase, colon_capture, template|
  use_table = (colon_capture == ':')
  add_macro(macro_phrase, template, use_table)
end


Quand(/^j(?:e |')\[((?:[^\\\]]|\\.)+)\]$/) do |macro_phrase|
  invoke_macro(macro_phrase)  # This will call the macro with the given phrase
end


Quand(/^j(?:e |')\[([^\]]+)\]:$/) do |macro_phrase, table_argument|
  # Ensure that the second argument is of the correct type
  unless table_argument.kind_of?(Cucumber::Ast::Table)
     raise Macros4Cuke::DataTableNotFound, "This step must have a data table as an argument."
  end

  # This will call the macro with the given phrase.
  # The second argument consists of an array with couples of the kind: [argument name, actual value]
  invoke_macro(macro_phrase, table_argument.raw)
end

# End of file
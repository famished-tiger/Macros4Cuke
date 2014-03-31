# encoding: utf-8
# "Traduction" en Français des macro-pas de Macros4Cuke
# Ce sont des définitions de pas faisant directement appel à l'API de Macros4Cuke


Etantdonné(/^que je crée le pas "(?:Soit|Quand|Alors) j(?:e |')\[((?:[^\\\]]|\\.)+)\](:?)" qui équivaut à:$/) do |macro_phrase, colon_capture, template|
  use_table = (colon_capture == ':')
  add_macro(macro_phrase, template, use_table)
end


Quand(/^j(?:e |')\[((?:[^\\\]]|\\.)+)\]$/) do |macro_phrase|
  # This will call the macro with the given phrase
  invoke_macro(macro_phrase)
end


Quand(/^j(?:e |')\[([^\]]+)\]:$/) do |macro_phrase, table_argument|
  # Ensure that the second argument is of the correct type
  unless table_argument.kind_of?(Cucumber::Ast::Table)
    error_message = 'Ce pas doit avoir un tableau comme paramètre.'
    fail(Macros4Cuke::DataTableNotFound, error_message)
  end

  # This will call the macro with the given phrase.
  # The second argument consists of an array with couples
  # of the kind: [argument name, actual value]
  invoke_macro(macro_phrase, table_argument.raw)
end

# End of file
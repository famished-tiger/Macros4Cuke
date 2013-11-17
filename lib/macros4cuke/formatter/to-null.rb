# File: to-null.rb

require_relative 'all-notifications'

module Macros4Cuke # Module used as a namespace

# Namespace for all formatters of MacroCollection and MacroStep objects
module Formatter

# A macro-step formatter that doesn't produce any output.
# It fully implements the expected interface of formatters but
# its methods are NOOP (i.e. they do nothing).
# This formatter can be useful when one wants to discard
# any formatted output.
class ToNull

  public

  # Tell which notifications the formatter subscribes to.
  def implements()
    return Formatter::AllNotifications
  end
  
  def on_collection(aLevel, aMacroCollection)
    ; # Do nothing
  end
  
  def on_collection_end(aLevel)
    ; # Do nothing
  end

  def on_step(aLevel, aMacroStep)
    ; # Do nothing
  end
  
  def on_step_end(aLevel)
    ; # Do nothing
  end

  def on_phrase(aLevel, aPhraseText, useTable)
    ; # Do nothing
  end

  def on_renderer(aLevel, aRenderer)
    ; # Do nothing
  end
  
  def on_renderer_end(aLevel)
    ; # Do nothing
  end

  def on_source(aLevel, aSourceText)
    ; # Do nothing
  end
  
  def on_static_text(aLevel, aText)
    ; # Do nothing
  end
  
  def on_comment(aLevel, aComment)
    ; # Do nothing
  end
  
  def on_eol(aLevel)
    ; # Do nothing
  end
  
  def on_placeholder(aLevel, aPlaceHolderName)
    ; # Do nothing
  end
  
  def on_section(aLevel, aSectionName)
    ; # Do Nothing
  end
  
  def on_section_end(aLevel)
    ; # Do Nothing
  end


end # class

end # module

end # module

# End of file

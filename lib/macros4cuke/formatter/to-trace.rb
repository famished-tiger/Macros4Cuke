# File: to-trace.rb

require_relative 'all-notifications'

module Macros4Cuke # Module used as a namespace

# Namespace for all formatters of MacroCollection and MacroStep objects
module Formatter

# A macro-step formatter that outputs in the given IO the formatting events.
# Can be useful in tracing the visit sequence inside
# a given macro-step collection.
class ToTrace
  # The IO where the formatter's output will be written to.
  attr_reader(:io)


  def initialize(anIO)
    @io = anIO
  end

  public

  # Tell which notifications the formatter subscribes to.
  def implements()
    return Formatter::AllNotifications
  end

  def on_collection(aLevel, aMacroCollection)
    trace_event(aLevel, __method__)
  end

  def on_collection_end(aLevel)
    trace_event(aLevel, __method__)
  end

  def on_step(aLevel, aMacroStep)
    trace_event(aLevel, __method__)
  end

  def on_step_end(aLevel)
    trace_event(aLevel, __method__)
  end

  def on_phrase(aLevel, aPhraseText, useTable)
    trace_event(aLevel, __method__)
  end

  def on_renderer(aLevel, aRenderer)
    trace_event(aLevel, __method__)
  end

  def on_renderer_end(aLevel)
    trace_event(aLevel, __method__)
  end

  def on_source(aLevel, aSourceText)
    trace_event(aLevel, __method__)
  end

  def on_static_text(aLevel, aStaticText)
    trace_event(aLevel, __method__)
  end

  def on_comment(aLevel, aComment)
    trace_event(aLevel, __method__)
  end

  def on_eol(aLevel)
    trace_event(aLevel, __method__)
  end

  def on_placeholder(aLevel, aPlaceHolderName)
    trace_event(aLevel, __method__)
  end

  def on_section(aLevel, aSectionName)
    trace_event(aLevel, __method__)
  end

  def on_section_end(aLevel)
    trace_event(aLevel, __method__)
  end

  private

  def indentation(aLevel)
    return '  ' * aLevel
  end

  def trace_event(aLevel, anEvent)
    io.puts "#{indentation(aLevel)}#{anEvent}"
  end


end # class

end # module

end # module

# End of file

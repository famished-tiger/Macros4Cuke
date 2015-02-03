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
      # Tell which notifications the formatter subscribes to.
      def implements()
        return Formatter::AllNotifications
      end

      def on_collection(_, _)
        ; # Do nothing
      end

      def on_collection_end(_)
        ; # Do nothing
      end

      def on_step(_, _)
        ; # Do nothing
      end

      def on_step_end(_)
        ; # Do nothing
      end

      def on_phrase(_, _, _)
        ; # Do nothing
      end

      def on_renderer(_, _)
        ; # Do nothing
      end

      def on_renderer_end(_)
        ; # Do nothing
      end

      def on_source(_, _)
        ; # Do nothing
      end

      def on_static_text(_, _)
        ; # Do nothing
      end

      def on_comment(_, _)
        ; # Do nothing
      end

      def on_eol(_)
        ; # Do nothing
      end

      def on_placeholder(_, _)
        ; # Do nothing
      end

      def on_section(_, _)
        ; # Do Nothing
      end

      def on_section_end(_)
        ; # Do Nothing
      end
    end # class
  end # module
end # module

# End of file

module Macros4Cuke # Module used as a namespace
  # Module containing all classes implementing the simple template engine
  # used internally in Macros4Cuke.
  module Templating
    # Class used internally by the template engine.
    # Represents an end of line that must be rendered as such.
    class EOLine
      # Render an end of line.
      # This method has the same signature as the {Engine#render} method.
      # @return [String] An end of line marker. Its exact value is OS-dependent.
      def render(_, _)
        return "\n"
      end
    end # class
  end # module
end # module

# End of file

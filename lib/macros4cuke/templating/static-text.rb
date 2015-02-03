# File: static-text.rb


module Macros4Cuke # Module used as a namespace
  # Module containing all classes implementing the simple template engine
  # used internally in Macros4Cuke.
  module Templating
    # Class used internally by the template engine.
    # Represents a static piece of text from a template.
    # A static text is a text that is reproduced verbatim
    # when rendering a template.
    class StaticText
      # The static text extracted from the original template.
      attr_reader(:source)


      # @param aSourceText [String] A piece of text extracted
      #   from the template that must be rendered verbatim.
      def initialize(aSourceText)
        @source = aSourceText
      end

      public

      # Render the static text.
      # This method has the same signature as the {Engine#render} method.
      # @return [String] Static text is returned verbatim ("as is")
      def render(_, _)
        return source
      end
    end # class
  end # module
end # module

# End of file

# frozen_string_literal: true

# File: eo-line.rb


module Macros4Cuke # Module used as a namespace
  # Module containing all classes implementing the simple template engine
  # used internally in Macros4Cuke.
  module Templating
    # Class used internally by the template engine.
    # Represents a comment from a template.
    # A static text is a text that is reproduced verbatim
    # when rendering a template.
    class Comment
      # The comment as extracted from the original template.
      attr_reader(:source)


      # @param aSourceText [String] A piece of text extracted
      #   from the template that must be rendered verbatim.
      def initialize(aSourceText)
        @source = aSourceText
      end

      # Render the comment.
      # Comments are rendered as empty text. This is necessary because
      # Cucumber::RbSupport::RbWorld#steps complains when it sees a comment.
      # This method has the same signature as the {Engine#render} method.
      # @return [String] Empty string ("as is")
      def render(_, _)
        return ''
      end
    end # class
  end # module
end # module

# End of file

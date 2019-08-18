# frozen_string_literal: true

# File: placeholder.rb
# Purpose: Implementation of the Placeholder class.

require_relative 'unary-element' # Load the superclass


module Macros4Cuke # Module used as a namespace
# Module containing all classes implementing the simple template engine
# used internally in Macros4Cuke.
module Templating
  # Class used internally by the template engine.
  # Represents a named placeholder in a template, that is,
  # a name placed between <..> in the template.
  # At rendition, a placeholder is replaced by the text value
  # that is associated with it.
  class Placeholder < UnaryElement
    # Render the placeholder given the passed arguments.
    # This method has the same signature as the {Engine#render} method.
    # @return [String] The text value assigned to the placeholder.
    #   Returns an empty string when no value is assigned to the placeholder.
    def render(aContextObject, theLocals)
      actual_value = retrieve_value_from(aContextObject, theLocals)

      result = case actual_value
                 when NilClass
                   ''

                 when Array
                   # TODO: Move away from hard-coded separator.
                   actual_value.join('<br/>')

                 when String
                   actual_value
                 else
                   actual_value.to_s
               end

      return result
    end
  end # class
end # module
end # module

# End of file

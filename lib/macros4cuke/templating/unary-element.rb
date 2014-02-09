# File: unary-element.rb
# Purpose: Implementation of the Section and ConditionalSection classes.


module Macros4Cuke # Module used as a namespace

  # Base class used internally by the template engine.
  # The generalization of any element from a template that has one variable
  # whose actual value influences the rendition.
  class UnaryElement
    # The name of the placeholder/variable.
    attr_reader(:name)

    # @param aVarName [String] The name of the placeholder from a template.
    def initialize(aVarName)
      @name = aVarName
    end

    protected

    # This method has the same signature as the {Engine#render} method.
    # @return [Object] The actual value from the locals or context
    # that is assigned to the variable.
    def retrieve_value_from(aContextObject, theLocals)
      actual_value = theLocals[name]
      if actual_value.nil? && aContextObject.respond_to?(name.to_sym)
        actual_value = aContextObject.send(name.to_sym)
      end

      return actual_value
    end

  end # class

end # module

# End of file

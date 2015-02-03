# File: section.rb
# Purpose: Implementation of the Section and ConditionalSection classes.

require_relative 'unary-element' # Load the superclass


module Macros4Cuke # Module used as a namespace
# Module containing all classes implementing the simple template engine
# used internally in Macros4Cuke.
module Templating
# Base class used internally by the template engine.
# Represents a section in a template, that is,
# a set of template elements for which its rendition depends
# on the value of a variable.
class Section  < UnaryElement
  # The child elements of the section
  attr_reader(:children)

  # @param aVarName [String] The name of the placeholder from a template.
  def initialize(aVarName)
    super(aVarName)
    @children = []
  end

  public

  # Add a child element as member of the section
  def add_child(aChild)
    children << aChild
  end

  # Retrieve all placeholder names that appear in the template.
  # @return [Array] The list of placeholder names.
  def variables()
    all_vars = children.each_with_object([]) do |a_child, subResult|
      case a_child
        when Placeholder
          subResult << a_child.name
        when Section
          subResult.concat(a_child.variables)
      end
    end

    return all_vars.flatten.uniq
  end


  # Render the placeholder given the passed arguments.
  # This method has the same signature as the {Engine#render} method.
  # @return [String] The text value assigned to the placeholder.
  #   Returns an empty string when no value is assigned to the placeholder.
  def render(_, _)
    msg = "Method Section.#{__method__} must be implemented in subclass."
    fail(NotImplementedError, msg)
  end
end # class


# A specialized section in a template for which its rendition
# depends on the (in)existence of an actual value bound to the variable name.
class ConditionalSection < Section
  # A boolean that indicates whether the rendition condition is
  # the existence of a value for the variable (true)
  # or its non-existence (false).
  attr_reader(:existence)

  # @param aVarName [String] The name of the placeholder from a template.
  # @param renderWhenExisting [boolean] When true, render the children elements
  #   if a value exists for the variable.
  def initialize(aVarName, renderWhenExisting = true)
    super(aVarName)
    @existence = renderWhenExisting
  end

  public

  # Render the placeholder given the passed arguments.
  # This method has the same signature as the {Engine#render} method.
  # @return [String] The text value assigned to the placeholder.
  #   Returns an empty string when no value is assigned to the placeholder.
  def render(aContextObject, theLocals)
    actual_value = retrieve_value_from(aContextObject, theLocals)
    if (!actual_value.nil? && existence) || (actual_value.nil? && !existence)
      # Let render the children
      result = children.each_with_object('') do |a_child, sub_result|
        sub_result << a_child.render(aContextObject, theLocals)
      end
    else
      result = ''
    end

    return result
  end


  # @return [String] The original text representation of the tag.
  def to_s()
    return "<?#{name}>"
  end
end # class
SectionEndMarker = Struct.new(:name)
end # module
end # module

# End of file

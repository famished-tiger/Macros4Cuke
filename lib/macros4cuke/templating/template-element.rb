# File: template-element.rb
# Purpose: Implementation of core classes used in the template engine.


require_relative '../exceptions' # Load the custom exception classes.



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
  def render(aContextObject, theLocals)
    return source
  end
end # class


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

  public

  # Render the comment.
  # Comments are rendered as empty text. This is necessary because
  # Cucumber::RbSupport::RbWorld#steps complains when it sees a comment.
  # This method has the same signature as the {Engine#render} method.
  # @return [String] Empty string ("as is")
  def render(aContextObject, theLocals)
    return ''
  end
end # class


# Class used internally by the template engine.
# Represents an end of line that must be rendered as such.
class EOLine

  public

  # Render an end of line.
  # This method has the same signature as the {Engine#render} method.
  # @return [String] An end of line marker. Its exact value is OS-dependent.
  def render(aContextObject, theLocals)
    return "\n"
  end
end # class

end # module

end # module

# End of file

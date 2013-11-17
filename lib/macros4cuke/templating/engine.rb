# File: engine.rb
# Purpose: Implementation of the MacroStep class.

require 'strscan' # Use the StringScanner for lexical analysis.
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



# Class used internally by the template engine.  
# Represents a named placeholder in a template, that is, 
# a name placed between <..> in the template.  
# At rendition, a placeholder is replaced by the text value
# that is associated with it. 
class Placeholder < UnaryElement

  public
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
      else
        # Do nothing
      end
    end
    
    return all_vars.flatten.uniq
  end


  # Render the placeholder given the passed arguments.
  # This method has the same signature as the {Engine#render} method.
  # @return [String] The text value assigned to the placeholder. 
  #   Returns an empty string when no value is assigned to the placeholder.
  def render(aContextObject, theLocals)
    msg = "Method Section.#{__method__} must be implemented in subclass."
    fail(NotImplementedError, msg)
  end    

end # class


# A specialized section in a template for which its rendition
# depends on the (in)existence of an actual value bound to the variable name.
class ConditionalSection < Section
  # A boolean that indicates whether the rendition condition is 
  # the existence of a value for the variable (true)
  # or its inexistence (false).
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


# A very simple implementation of a templating engine.  
# Earlier versions of Macros4Cuke relied on the logic-less 
# Mustache template engine.  
# But it was decided afterwards to replace it by a very simple 
# template engine.  
# The reasons were the following:  
# - Be closer to the usual Gherkin syntax (parameters of scenario outlines 
#     use chevrons <...>, 
#     while Mustache use !{{...}} delimiters),  
# - Feature files are meant to be simple, so should the template engine be. 
class Engine
  # The regular expression that matches a space, 
  # any punctuation sign or delimiter that is forbidden
  # between chevrons <...> template tags.
  DisallowedSigns = begin 
    # Use concatenation (+) to work around Ruby bug!
    forbidden =  ' !"#' + "$%&'()*+,-./:;<=>?[\\]^`{|}~" 
    all_escaped = [] 
    forbidden.each_char { |ch| all_escaped << Regexp.escape(ch) }
    pattern = all_escaped.join('|')
    Regexp.new(pattern)
  end

  # The original text of the template is kept here.
  attr_reader(:source)
  
  # The internal representation of the template text
  attr_reader(:representation)
  
  # Builds an Engine and compiles the given template text into
  #  an internal representation.
  # @param aSourceTemplate [String] The template source text. 
  #   It may contain zero or tags enclosed between chevrons <...>.
  def initialize(aSourceTemplate)
    @source = aSourceTemplate
    @representation = compile(aSourceTemplate)
  end

public
  # Render the template within the given scope object and 
  # with the locals specified.
  # The method mimicks the signature of the Tilt::Template#render method.
  # @param aContextObject [anything] context object to get actual values
  #   (when not present in the locals Hash).
  # @param theLocals [Hash] Contains one or more pairs of the form:
  #   tag/placeholder name => actual value.
  # @return [String] The rendition of the template given 
  #  the passed argument values.
  def render(aContextObject = Object.new, theLocals)
    return '' if @representation.empty?

    prev = nil
    result = @representation.each_with_object('') do |element, subResult|
      # Output compaction rules:
      # -In case of consecutive eol's only one is rendered.
      # -In case of comment followed by one eol, both aren't rendered
      unless element.is_a?(EOLine) && 
        (prev.is_a?(EOLine) || prev.is_a?(Comment))
        subResult << element.render(aContextObject, theLocals)
      end
      prev = element
    end

    return result
  end

  
  # Retrieve all placeholder names that appear in the template.
  # @return [Array] The list of placeholder names.
  def variables()
    # The result will be cached/memoized...
    @variables ||= begin
      vars = @representation.each_with_object([]) do |element, subResult|
        case element
        when Placeholder          
          subResult << element.name
        
        when Section
          subResult.concat(element.variables)
        
        else
          # Do nothing
        end
      end
      
      vars.flatten.uniq
    end
    
    return @variables
  end

  # Class method. Parse the given line text into a raw representation.
  # @return [Array] Couples of the form:
  # [:static, text], [:comment, text] or [:dynamic, tag text]
  def self.parse(aTextLine)
    scanner = StringScanner.new(aTextLine)
    result = []

    if scanner.check(/\s*#/)  # Detect comment line
      result << [:comment, aTextLine]
    else
      until scanner.eos?
        # Scan tag at current position...
        tag_literal = scanner.scan(/<(?:[^\\<>]|\\.)*>/)
        unless tag_literal.nil?
          result << [:dynamic, tag_literal.gsub(/^<|>$/, '')] 
        end
        
        # ... or scan plain text at current position
        literal = scanner.scan(/(?:[^\\<>]|\\.)+/)
        result << [:static, literal] unless literal.nil? 
        identify_parse_error(aTextLine) if tag_literal.nil? && literal.nil?
      end
    end

    return result
  end

private

  # Called when the given text line could not be parsed.
  # Raises an exception with the syntax issue identified.
  # @param aTextLine [String] A text line from the template.  
  def self.identify_parse_error(aTextLine)
    # Unsuccessful scanning: we typically have improperly balanced chevrons.
    # We will analyze the opening and closing chevrons...
     # First: replace escaped chevron(s)
    no_escaped = aTextLine.gsub(/\\[<>]/, '--')

    # var. equals count_of(<) -  count_of(>): can only be 0 or temporarily 1
    unbalance = 0

    no_escaped.each_char do |ch|
      case ch
      when '<' then unbalance += 1 
      when '>' then unbalance -= 1              
      end
      
      fail(StandardError, "Nested opening chevron '<'.") if unbalance > 1
      fail(StandardError, "Missing opening chevron '<'.") if unbalance < 0
    end
    
    fail(StandardError, "Missing closing chevron '>'.") if unbalance == 1 
  end
  
  
  # Create the internal representation of the given template.
  def compile(aSourceTemplate)
    # Split the input text into lines.
    input_lines = aSourceTemplate.split(/\r\n?|\n/)
    
    # Parse the input text into raw data.
    raw_lines = input_lines.map do |line| 
      line_items = self.class.parse(line)
      line_items.each do |(kind, text)|
        # A tag text cannot be empty nor blank
        if (kind == :dynamic) && text.strip.empty?
          fail(EmptyArgumentError.new(line.strip))
        end
      end
      
      line_items
    end
    
    compiled_lines = raw_lines.map { |line| compile_line(line) }
    return compile_sections(compiled_lines.flatten)
  end
  
  # Convert the array of raw entries (per line) 
  # into full-fledged template elements.
  def compile_line(aRawLine)
    line_rep = aRawLine.map { |couple| compile_couple(couple) }
    
    # Apply the rule: when a line just consist of spaces 
    # and a section element, then remove all the spaces from that line.
    section_item = nil
    line_to_squeeze = line_rep.all? do |item|
      case item
      when StaticText
        item.source =~ /\s+/
        
      when Section, SectionEndMarker
        if section_item.nil?
          section_item = item
          true
        else
          false
        end
      else
        false
      end
    end
    if line_to_squeeze && !section_item.nil?
      line_rep = [section_item]
    else
      line_rep_ending(line_rep)
    end
    
    return line_rep
  end


  # Apply rule: if last item in line is an end of section marker, 
  # then place eoline before that item. 
  # Otherwise, end the line with a eoline marker.  
  def line_rep_ending(theLineRep)
    if theLineRep.last.is_a?(SectionEndMarker)
      section_end = theLineRep.pop
      theLineRep << EOLine.new
      theLineRep << section_end
    else
      theLineRep << EOLine.new
    end  
  end

  
  # @param aCouple [Array] a two-element array of the form: [kind, text]
  # Where kind must be one of :static, :dynamic
  def compile_couple(aCouple)
    (kind, text) = aCouple

    result = case kind
    when :static then StaticText.new(text)
    when :comment then Comment.new(text)
    when :dynamic then parse_tag(text)
    end

    return result
  end


  # Parse the contents of a tag entry.
  # @param aText [String] The text that is enclosed between chevrons.
  def parse_tag(aText)
    # Recognize the first character
    if aText =~ /^[\?\/]/
      matching = DisallowedSigns.match(aText[1..-1])
    else
      # Disallow punctuation and delimiter signs in tags.
      matching = DisallowedSigns.match(aText)
    end
    fail(InvalidCharError.new(aText, matching[0])) if matching
    
    result = case aText[0, 1]
      when '?'
        ConditionalSection.new(aText[1..-1], true)
        
      when '/'
        SectionEndMarker.new(aText[1..-1])
      else
        Placeholder.new(aText)
    end

    return result
  end
  
  # Transform a flat sequence of elements into a hierarchy of sections.
  # @param flat_sequence [Array] a linear list of elements (including sections)
  def compile_sections(flat_sequence)
    open_sections = []  # The list of nested open sections
    
    compiled = flat_sequence.each_with_object([]) do |element, subResult|
      case element
      when Section
        open_sections << element
      
      when SectionEndMarker           
        validate_section_end(element, open_sections)
        subResult << open_sections.pop
       
      else
        if open_sections.empty?
          subResult << element
        else
          open_sections.last.add_child(element)
        end
      end 
    end
    
    unless open_sections.empty?
      error_message =  "Unterminated section #{open_sections.last}."
      fail(StandardError, error_message)
    end
    
    return compiled
  end
  
  # Validate the given end of section marker taking into account 
  # the open sections.
  def validate_section_end(marker, sections)
    msg_prefix = "End of section</#{marker.name}> "
    
    if sections.empty?
      msg = 'found while no corresponding section is open.'
      fail(StandardError, msg_prefix + msg)
    end
    if marker.name != sections.last.name
      msg = "doesn't match current section '#{sections.last.name}'."
      fail(StandardError, msg_prefix + msg)
    end
  end
 
end # class

end # module

end # module

# End of file

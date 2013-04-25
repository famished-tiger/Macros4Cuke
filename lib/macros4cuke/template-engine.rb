# File: template-engine.rb
# Purpose: Implementation of the MacroStep class.

require 'strscan' # Use the StringScanner for lexical analysis.

module Macros4Cuke # Module used as a namespace



class StaticRep
  attr_reader(:source)
  
  def initialize(aSourceText)
    @source = aSourceText
  end
  
public
  def render(aContextObject = nil, theLocals)
    return source
  end
end # class


class VariableRep
  attr_reader(:name)
  
  def initialize(aVarName)
    @name = aVarName
  end
  
public
  # The signature of this method should comply to the Tilt API.
  # Actual values from the 'locals' Hash take precedence over the context object.
  def render(aContextObject, theLocals)
    actual_value = theLocals[name]
    if actual_value.nil?
      actual_value = aContextObject.send(name.to_sym) if aContextObject.respond_to?(name.to_sym)
      actual_value = '' if actual_value.nil?
    end
    
    return actual_value.is_a?(String) ? actual_value : actual_value.to_s
  end  
  
end # class


class EOLRep
public
  def render(aContextObject, theLocals)
    return "\n"
  end
end # class


class TemplateEngine
  # The original text of the template is kept here.
  attr_reader(:source)
  
  # Constructor.
  # [aSourceTemplate]
  def initialize(aSourceTemplate)
    @source = aSourceTemplate
    @representation = compile(aSourceTemplate)
  end

public
  def render(aContextObject = nil, theLocals)
    return '' if @representation.empty?
    context = aContextObject.nil? ? Object.new : aContextObject
    
    result = @representation.each_with_object('') do |element, subResult|
      subResult << element.render(context, theLocals)
    end
    
    return result
  end
  
  # Return all variable names that appear in the template.
  def variables()
    # The result will be cached/memoized...
    @variables ||= begin
      vars = @representation.select { |element| element.is_a?(VariableRep) }
      vars.map(&:name)
    end
    
    return @variables
  end

  # Class method. Parse the given line text.
  # Returns an array of couples.
  def self.parse(aTextLine)
    scanner = StringScanner.new(aTextLine)
    result = []
    
    until scanner.eos?
      # Scan tag at current position...
      tag_literal = scanner.scan(/<(?:[^\\<>]|\\.)*>/)
      result << [:dynamic, tag_literal.gsub(/^<|>$/, '')] unless tag_literal.nil?
      
      # ... or scan plain text at current position
      text_literal = scanner.scan(/(?:[^\\<>]|\\.)+/)
      result << [:static, text_literal] unless text_literal.nil?
      
      if tag_literal.nil? && text_literal.nil?
        # Unsuccessful scanning: we have improperly balanced chevrons.
        # We will analyze the opening and closing chevrons...
        no_escaped = aTextLine.gsub(/\\[<>]/, "--")  # First: replace escaped chevron(s)
        unbalance = 0 # = count of < -  count of > (can only be 0 or -temporarily- 1)

        no_escaped.scan(/(.)/) do |match|
          case match[0]
            when '<'
              unbalance += 1 
            when '>'  
              unbalance -= 1              
          end
          
          raise StandardError, "Nested opening chevron '<'." if unbalance > 1
          raise StandardError, "Missing opening chevron '<'." if unbalance < 0
        end
        
        raise StandardError, "Missing closing chevron '>'." if unbalance == 1
        raise StandardError, "Cannot parse:\n'#{aTextLine}'"
      end
    end
    
    return result
  end

private
  # Create the internal representation of the given template.
  def compile(aSourceTemplate)
    # Split the input text into lines.
    input_lines = aSourceTemplate.split(/\r\n?|\n/)
    
    # Parse the input text into raw data.
    raw_lines = input_lines.map { |line| self.class.parse(line) }
    
    compiled_lines = raw_lines.map { |line| compile_line(line) }
    return compiled_lines.flatten()
  end
  
  
  def compile_line(aRawLine)
    line_rep = aRawLine.map { |couple| compile_couple(couple) }
    line_rep << EOLRep.new
  end

  
  # [aCouple] a two-element array of the form: [kind, text]
  # Where kind must be one of :static, :dynamic
  def compile_couple(aCouple)
    (kind, text) = aCouple
    
    result = case kind
      when :static
        StaticRep.new(text) 
      when :dynamic
        VariableRep.new(text)
      else
        raise StandardError, "Internal error: Don't know template element of kind #{kind}"
      end
    
    return result
  end
  
end # class

end # module

# End of file
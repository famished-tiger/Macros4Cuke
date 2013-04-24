# File: template-engine.rb
# Purpose: Implementation of the MacroStep class.

require 'strscan' # Use the StringScanner for lexical analysis.

module Macros4Cuke # Module used as a namespace


class TemplateEngine

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

end # class

end # module

# End of file
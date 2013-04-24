# File: macro-step.rb
# Purpose: Implementation of the MacroStep class.

require 'mustache'  # Load the Mustache template library

module Macros4Cuke # Module used as a namespace

# In essence, a macro step object represents a Cucumber step that is itself
# an aggregation of lower-level Cucumber steps.
class MacroStep
  # A Mustache instance that expands the steps upon request.
  attr_reader(:renderer)
  
  # Name of the macro as derived from the macro phrase.
  attr_reader(:name)
  
  # The list of macro arguments that appears in the macro phrase.
  attr_reader(:phrase_args)
  
  # The list of macro argument names (as appearing in the Mustache template and in the macro phrase).
  attr_reader(:args)

  
  # Constructor.
  # [aMacroPhrase] The text from the macro step definition that is between the square brackets.
  # [theSubsteps] The source text of the steps to be expanded upon macro invokation.
  def initialize(aMacroPhrase, theSubsteps)
    @name = self.class.macro_key(aMacroPhrase, :definition)
    
    # Retrieve the macro arguments embedded in the phrase.
    @phrase_args = scan_arguments(aMacroPhrase, :definition)
    @args = @phrase_args.dup()
    
    # Manipulate the substeps source text (e.g. remove comment lines)
    substeps_processed = preprocess(theSubsteps)
    
    # The expansion text is a Mustache template
    @renderer = Mustache.new
    renderer.template = substeps_processed
    
    # Retrieve the Mustache tag names from the template and add them as macro arguments    
    add_tags_multi(renderer.template.tokens())
    @args = @args.flatten.uniq.sort
  end
  
  
  # Compute the identifier of the macro from the given macro phrase.
  # A macro phrase is a text that must start with a recognised verb and may contain zero or more placeholders.
  # In definition mode, a placeholder is delimited by double or triple mustaches (accolades)
  # In invokation mode, a placeholder is delimited by double quotes.
  # The rule for building the identifier are:
  # - Leading and trailing space(s) are removed.
  # - Each underscore character is removed.
  # - Every sequence of one or more space(s) is converted into an underscore
  # - Each placeholder (i.e. = delimiters + enclosed text) is converted into a letter X.
  # - The endings are transformed as follows: ] => '', ]: => _T 
  # Example:
  # Consider the macro phrase: 'create the following "contactType" contact]:'
  # The resulting macro_key is: 'create_the_following_X_contact_T'
  def self.macro_key(aMacroPhrase, mode)
    stripped_phrase = aMacroPhrase.strip # Remove leading ... trailing space(s)
    
    # Remove every underscore
    stripped_phrase.gsub!(/_/, '')
    
    # Replace all consecutive whitespaces by an underscore    
    stripped_phrase.gsub!(/\s+/, '_')
    
    
    # Determine the pattern to isolate each argument/parameter with its delimiters
    pattern = case mode
      when :definition
        /\{{2,3}[^}]*\}{2,3}/
      when :invokation
        /"([^\\"]|\\.)*"/

    end
    
    # Each text between quotes or mustaches is replaced by the letter X
    normalized = stripped_phrase.gsub(pattern, 'X')
    
    # Drop the "]" ending or replace the "]:# ending by "_T"
    key = if normalized.end_with?("]")
      normalized.chop()
    else
      normalized.sub(/\]:/, '_T')
    end
    
    return key
  end  
  
  
  # Render the steps from the template, given the values
  # taken by the parameters
  # [macro_parameters] a Hash with pairs of the kind: macro argument name => value
  def expand(macro_parameters)
    return renderer.render(macro_parameters)
  end

  
  # Build a Hash from the given raw data.
  # [aPhrase] an instance of the macro phrase.
  # [rawData] An Array of couples.
  # Each couple is of the form: argument name, a value.
  # Multiple rows with same argument name are acceptable.
  def validate_params(aPhrase, rawData)
    macro_parameters = {}
    
    # Retrieve the value(s) per variable in the phrase.
    quoted_values = scan_arguments(aPhrase, :invokation)
    quoted_values.each_with_index do |val, index|
      macro_parameters[phrase_args[index]] = val
    end
    

    unless rawData.nil?
      rawData.each do |(key, value)|
        raise UnknownArgumentError.new(key) unless @args.include? key
        if macro_parameters.include? key
          if macro_parameters[key].kind_of?(Array)
             macro_parameters[key] << value
          else
            macro_parameters[key] = [macro_parameters[key], value]
          end
        else
          macro_parameters[key] = value
        end
      end
    end
    
    return macro_parameters
  end


  
private
  # Retrieve from the macro phrase, all the text between "mustaches" or double quotes.
  # Returns an array. Each of its elements corresponds to quoted text.
  # Example:
  # aMacroPhrase = 'a "qualifier" text with "quantity" placeholders.'
  # Results in : ["qualifier", "quantity"]
  # [aMacroPhrase] A phrase
  # [mode] one of the following: :definition, :invokation
  def scan_arguments(aMacroPhrase, mode)
    # determine the syntax of the arguments/parameters
    # as a regular expression with one capturing group
    pattern = case mode
      when :definition
        /{{{([^}]*)}}}|{{([^}]*)}}/ # Two capturing groups!...
      when :invokation
        /"((?:[^\\"]|\\.)*)"/
      else
        raise InternalError, "Internal error: Unknown mode argument #{mode}"
    end
    raw_result = aMacroPhrase.scan(pattern)
    return raw_result.flatten.compact
  end
  
  # Return the substeps text after some transformation
  # [theSubstepsSource] The source text of the steps to be expanded upon macro invokation.
  def preprocess(theSubstepsSource)
    # Split text into lines
    lines = theSubstepsSource.split(/\r\n?|\n/)
    
    # Reject comment lines. This necessary because Cucumber::RbSupport::RbWorld#steps complains when it sees a comment.
    processed = lines.reject { |a_line| a_line =~ /\s*#/ }
    
    return processed.join("\n")
  end

  # Visit an array of tokens of which the first element is the :multi symbol.
  # Every found template variable is added to the 'args' attribute.
  # [tokens] An array that begins with the :multi symbol
  def add_tags_multi(tokens)
    first_token = tokens.shift
    unless first_token == :multi
      raise InternalError, "Expecting a :multi token instead of a #{first_token}"
    end
    
    tokens.each do |an_opcode|
      case an_opcode[0]
        when :static
          # Do nothing...
          
        when :mustache
          add_tags_mustache(an_opcode)
          
        when String
          #Do nothing...
        else
          raise InternalError, "Unknown Mustache token type #{an_opcode.first}"
      end
    end
  end
  
  # [mustache_opcode] An array with the first element being :mustache
  def add_tags_mustache(mustache_opcode)
    mustache_opcode.shift() # Drop the :mustache symbol
    
    case mustache_opcode[0]
      when :etag
        triplet = mustache_opcode[1]
        raise InternalError, "expected 'mustache' token instead of '#{triplet[0]}'" unless triplet[0] == :mustache
        raise InternalError, "expected 'fetch' token instead of '#{triplet[1]}'" unless triplet[1] == :fetch
        @args << triplet.last
        
      when :fetch
        @args << mustache_opcode.last
      
      when :section
        add_tags_section(mustache_opcode)

      else
        raise InternalError, "Unknown Mustache token type #{mustache_opcode.first}"        
    end
  end
  
  
  def add_tags_section(opcodes)
    opcodes.shift() # Drop the :section symbol
    
    opcodes.each do |op|
      case op[0]
        when :mustache
          add_tags_mustache(op)
          
        when :multi
          add_tags_multi(op)
          
        when String
          return
        else
          raise InternalError, "Unknown Mustache token type #{op.first}"
      end
    end
  end
  
end # class

end # module


# End of file
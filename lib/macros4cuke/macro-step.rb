# File: macro-step.rb
# Purpose: Implementation of the MacroStep class.


require_relative 'exceptions'
require_relative 'template-engine'

module Macros4Cuke # Module used as a namespace

# In essence, a macro step object represents a Cucumber step that is itself
# an aggregation of lower-level Cucumber steps.
class MacroStep
  # A template engine that expands the substeps upon request.
  attr_reader(:renderer)
  
  # Unique key of the macro as derived from the macro phrase.
  attr_reader(:key)
  
  # The list of macro arguments that appears in the macro phrase.
  attr_reader(:phrase_args)
  
  # The list of macro argument names (as appearing in the substeps and in the macro phrase).
  attr_reader(:args)

  
  # Constructor.
  # [aMacroPhrase] The text from the macro step definition that is between the square brackets.
  # [theSubsteps] The source text of the steps to be expanded upon macro invokation.
  # [useTable] A boolean that indicates whether a table should be used to pass actual values.
  def initialize(aMacroPhrase, theSubsteps, useTable)
    @key = self.class.macro_key(aMacroPhrase, useTable, :definition)
    
    # Retrieve the macro arguments embedded in the phrase.
    @phrase_args = scan_arguments(aMacroPhrase, :definition)
    @args = @phrase_args.dup()
    
    # Manipulate the substeps source text
    substeps_processed = preprocess(theSubsteps)

    @renderer = TemplateEngine.new(substeps_processed)
    @args.concat(renderer.variables)
    @args.uniq!
  end
  
  
  # Compute the identifier of the macro from the given macro phrase.
  # A macro phrase is a text that must start with a recognised verb and may contain zero or more placeholders.
  # In definition mode, a placeholder is delimited by chevrons <..>
  # In invokation mode, a placeholder is delimited by double quotes.
  # The rule for building the identifier are:
  # - Leading and trailing space(s) are removed.
  # - Each underscore character is removed.
  # - Every sequence of one or more space(s) is converted into an underscore
  # - Each placeholder (i.e. = delimiters + enclosed text) is converted into a letter X.
  # - when useTable is true, concatenate: _T 
  # Example:
  # Consider the macro phrase: 'create the following "contactType" contact]:'
  # The resulting macro_key is: 'create_the_following_X_contact_T'
  # [aMacroPhrase] The text from the macro step definition that is between the square brackets.
  # [useTable] A boolean that indicates whether a table should be used to pass actual values.
  # [mode] one of the following: :definition, :invokation
  def self.macro_key(aMacroPhrase, useTable, mode)
    stripped_phrase = aMacroPhrase.strip # Remove leading ... trailing space(s)
    
    # Remove every underscore
    stripped_phrase.gsub!(/_/, '')
    
    # Replace all consecutive whitespaces by an underscore    
    stripped_phrase.gsub!(/\s+/, '_')
    
    
    # Determine the pattern to isolate each argument/parameter with its delimiters
    pattern = case mode
      when :definition
        /<(?:[^\\<>]|\\.)*>/
      when :invokation
        /"([^\\"]|\\.)*"/

    end
    
    # Each text between quotes or chevron is replaced by the letter X
    normalized = stripped_phrase.gsub(pattern, 'X')
    
    key = normalized + (useTable ? '_T' : '')
    
    return key
  end  
  
  
  # Render the steps from the template, given the values
  # taken by the parameters
  # [aPhrase] an instance of the macro phrase.
  # [rawData] An Array of couples.
  # Each couple is of the form: argument name, a value.
  # Multiple rows with same argument name are acceptable.
  def expand(aPhrase, rawData)
    params = validate_params(aPhrase, rawData)
    return renderer.render(nil, params)
  end

private  
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
      rawData.each do |(a_key, value)|
        raise UnknownArgumentError.new(a_key) unless @args.include? a_key
        if macro_parameters.include? a_key
          if macro_parameters[a_key].kind_of?(Array)
             macro_parameters[a_key] << value
          else
            macro_parameters[a_key] = [macro_parameters[a_key], value]
          end
        else
          macro_parameters[a_key] = value
        end
      end
    end
    
    return macro_parameters
  end


  

  # Retrieve from the macro phrase, all the text between <..> or double quotes.
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
        /<((?:[^\\<>]|\\.)*)>/
        # /{{{([^}]*)}}}|{{([^}]*)}}/ # Two capturing groups!...
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

end # class

end # module


# End of file
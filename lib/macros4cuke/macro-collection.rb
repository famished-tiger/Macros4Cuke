# File: macro-collection.rb
# Purpose: Implementation of the MacroCollection class.

require 'singleton'  # We'll use the Singleton design pattern for this class.
require_relative "macro-step"

module Macros4Cuke # Module used as a namespace

# Represents a container of macros.
# It gather all the macros encountered by Cucumber while "executing" the feature files.
class MacroCollection
  include Singleton # Use the Singleton design pattern.

  # A Hash with pairs of the form: phrase => MacroStep object
  attr_reader(:macro_steps)

  # Init the pool if it was not done yet.
  def init()
    @macro_steps = {} if @macro_steps.nil?
  end
  
public
  # Return true iff the host has a macro with the given key.
  def has_macro?(aPhrase, mode)
    key = MacroStep::macro_key(aPhrase, mode)
    return @macro_steps.include? key
  end
  
  
  # Add a new macro.
  # Pre-condition: there is no existing macro with the same key.
  # [aPhrase] The text that is enclosed between the square brackets.
  # [aTemplate] A text that consists of a sequence of Cucumber steps.
  # [useTable] A boolean that indicates whether a table should be used to pass actual values.
  def add_macro(aPhrase, aTemplate, useTable)
    new_macro = MacroStep.new(aPhrase, aTemplate, useTable)
    
    # Prevent collision of macros (macros with same phrase).
    # This can occur if a macro was defined in a background section.
    # An exception is raised if the phrase syntax of both macros are the     
    raise DuplicateMacroError.new(aPhrase) if find_macro(aPhrase, useTable)
    
    @macro_steps[new_macro.key] = new_macro    

  end
  
  # Render the steps associated to the macro with given phrase
  # and (optionally) given a table of values.
  # Return the rendered steps as a text.
  # [aPhrase] an instance of the macro phrase.
  # [rawData] An Array of couples.
  # Each couple is of the form: argument name, a value.
  # Multiple rows with same argument name are acceptable.  
  def render_steps(aPhrase, rawData = nil)
    useTable = ! rawData.nil?
    macro = find_macro(aPhrase, useTable) 
    raise UnknownMacroError.new(aPhrase) if macro.nil?

    # Render the steps
    return  macro.expand(aPhrase, rawData)
  end

private
  # Retrieve the macro, given a phrase.
  def find_macro(aMacroPhrase, useTable)
    return @macro_steps[MacroStep::macro_key(aMacroPhrase, useTable, :invokation)]
  end

end # class

end # module


# End of file
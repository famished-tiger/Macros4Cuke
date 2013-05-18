# encoding: utf-8
# File: macro-collection.rb
# Purpose: Implementation of the MacroCollection class.

require 'singleton'  # We'll use the Singleton design pattern for this class.
require_relative "macro-step"

module Macros4Cuke # Module used as a namespace

# Represents a container of macros.  
# It gathers all the macros encountered by Cucumber while "executing"
# the feature files.
# @note This is a singleton class: there is only one macro collection object.
class MacroCollection
  include Singleton # Use the Singleton design pattern.

  # @!attribute [r] macro_steps.
  #   A Hash with pairs of the form: macro key => MacroStep object

  
public
  # Add a new macro.
  # Pre-condition: there is no existing macro with the same key.
  # @param aPhrase [String] The text that is enclosed between 
  # the square brackets.
  # @param aTemplate [String] A text that consists of a sequence of sub-steps.
  # @param useTable [boolean] A flag indicating whether a table should be 
  # used to pass actual values.
  def add_macro(aPhrase, aTemplate, useTable)
    new_macro = MacroStep.new(aPhrase, aTemplate, useTable)
    
    # Prevent collision of macros (macros with same phrase).
    # This can occur if a macro was defined in a background section.
    # An exception is raised if the phrase syntax of both macros are the     
    raise DuplicateMacroError.new(aPhrase) if find_macro(aPhrase, useTable)
    
    macro_steps[new_macro.key] = new_macro    

  end

  # Render the steps associated to the macro with given phrase
  # and (optionally) given a table of values.
  # Return the rendered steps as a text.
  # @param aPhrase [String] an instance of the macro phrase.
  # @param rawData [Array or nil] An Array with coupples of the form:
  # [macro argument name, a value]. 
  #   Multiple rows with same argument name are acceptable.
  # @return [String]
  def render_steps(aPhrase, rawData = nil)
    useTable = ! rawData.nil?
    macro = find_macro(aPhrase, useTable) 
    raise UnknownMacroError.new(aPhrase) if macro.nil?

    # Render the steps
    return  macro.expand(aPhrase, rawData)
  end


  # Clear/remove all macro definitions from the collection.
  # Post-condition: we are back to the same situation as 
  # no macro was ever defined.
  def clear()
    macro_steps.clear()
  end

  
  # Read accessor for the @macro_steps attribute.
  def macro_steps()
    @macro_steps ||= {}
    return @macro_steps
  end
  
private
  # Retrieve the macro, given a phrase.
  def find_macro(aMacroPhrase, useTable)
    key = MacroStep.macro_key(aMacroPhrase, useTable, :invokation)
    return macro_steps[key]
  end

end # class

end # module


# End of file
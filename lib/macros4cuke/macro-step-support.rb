# File: macro-step-support.rb

require_relative 'exceptions'
require_relative 'macro-collection'

module Macros4Cuke # Module used as a namespace

# Mix-in module that should be extending World objects in Cucumber.  
# Synopsis (in env.rb):  
#   
#   require 'macros4cuke'  
#   ...  
#   # Extend the world object with this module.
#   World(Macros4Cuke::MacroStepSupport) 
#    
module MacroStepSupport
public

  # Add a new macro.
  # Pre-condition: there is no existing macro with the same key.
  # @param aPhrase [String] The text that is enclosed between 
  # the square brackets [...].
  # @param aTemplate [String] The text template that consists of a sequence
  # of sub-steps.
  # @param useTable [boolean] A flag that indicates whether a table should be
  # used to pass actual values.
  def add_macro(aPhrase, aTemplate, useTable)
    MacroCollection.instance.add_macro(aPhrase, aTemplate, useTable)
  end


  # Invoke a macro with given phrase and (optionally) a table of values
  # @param aPhraseInstance [String] an instance of the macro phrase. 
  # That is, the text between [...] and with zero or more actual values.
  # @param rawData [Array or nil] An Array with coupples of the form: 
  # [macro argument name, a value].
  # Multiple rows with same argument name are acceptable.  
  def invoke_macro(aPhraseInstance, rawData = nil)
    # Generate a text rendition of the step to be executed.
    collection = MacroCollection.instance()
    rendered_steps = collection.render_steps(aPhraseInstance, rawData)
    
    # Let Cucumber execute the sub-steps
    steps(rendered_steps)
  end


  # Clear (remove) all the macro-step definitions.
  # After this, we are in the same situation when no macro-step 
  # was ever defined.
  def clear_macros()
    MacroCollection.instance.clear()
  end

end # module

end # module


# End of file
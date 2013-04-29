# File: macro-step-support.rb

require_relative "exceptions"
require_relative "macro-collection"

module Macros4Cuke # Module used as a namespace

# Mix-in module that should be extending World objects in Cucumber.
# Synopsis (in env.rb):
# require 'macros4cuke'
# ...
# World(Macros4Cuke::MacroStepSupport) # Extend the world object with this module.
#
module MacroStepSupport

  # Callback invoked when a World object is extend(ed) with this module.
  def self.extended(world)
    # Add & initialize an instance variable for macro support.  
    MacroCollection::instance.init()
  end


public

  # Add a new macro.
  # Pre-condition: there is no existing macro with the same key.
  # [aPhrase] The text that is enclosed between the square brackets.
  # [aTemplate] A text that consists of a sequence of Cucumber steps.
  # [useTable] A boolean that indicates whether a table should be used to pass actual values.
  def add_macro(aPhrase, aTemplate, useTable)
    MacroCollection::instance.add_macro(aPhrase, aTemplate, useTable)
  end

  
  # Invoke a macro with given phrase and (optionally) a table of values
  # [aPhrase] an instance of the macro phrase.
  # [rawData] An Array of couples.
  # Each couple is of the form: argument name, a value.
  # Multiple rows with same argument name are acceptable.  
  def invoke_macro(aPhrase, rawData = nil)
    # Generate a text rendition of the step to be executed.
    rendered_steps = MacroCollection::instance.render_steps(aPhrase, rawData)
    
    # Execute the steps
    steps(rendered_steps)
  end

end # module

end # module

# End of file
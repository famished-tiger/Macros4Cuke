# File: macro-step-support.rb

require_relative "macro-step"

module Macros4Cuke # Module used as a namespace

# Mix-in module that should be extending World objects of Cucumber.
# Synopsis (in env.rb): 
module MacroStepSupport 

  # Callback invoked when a World object is extend(ed) with this module.
  def self.extended(world)
    # Add & initialize an instance variable for macro support.
    world.clear_macro_steps()
  end

  
public
  # Remove all macro steps
  def clear_macro_steps()
    @macro_steps = {}
  end
  
  # Return true iff the host has a macro with the given key.
  def has_macro?(aMacroPhrase, mode)
    key = MacroStep::macro_key(aMacroPhrase, mode)
    return @macro_steps.include? key
  end
  
  # Add a new macro.
  # Pre-condition: there is no existing macro with the same key.
  def add_macro(aPhrase, aTemplate)
    if has_macro?(aPhrase, :definition)
      raise StandardError, "Macro step for '[#{aPhrase}' already exist."
    else
      new_macro = MacroStep.new(aPhrase, aTemplate)
      @macro_steps[new_macro.name] = new_macro
    end
  end
  
  # Retrieve the macro, given a phrase.
  def find_macro(aMacroPhrase)
    return @macro_steps[MacroStep::macro_key(aMacroPhrase, :invokation)]
  end

end # module

end # module

# End of file
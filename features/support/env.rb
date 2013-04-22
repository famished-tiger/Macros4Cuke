# encoding: utf-8	You should see a paragraph character: §
# File: env.rb
# Purpose: Allow Cucumber to load the sample application configuration and hooks.
# It also demonstrate what to do in your env.rb file to use the Macros4Cuke gem.


# Macros4Cuke step one: Load modules and classes from the gem.
require 'macros4cuke'  


module Macros4Cuke  # Use the module as a namespace

=begin 
 Class created just for testing and demonstration purposes.
 Its instance, will record the output emitted by the steps.
=end
class TracingWorld
  # Will contain the text emitted by the steps
  attr_reader(:trace_steps)
  
  
  def initialize()
    # Constructor  
    @trace_steps = []
  end
  
public

  
end # class

end # module

# For testing purpose we override the default Cucumber behaviour
# making our world object an instance of the TracingWorld class
World { Macros4Cuke::TracingWorld.new }


# Macros4Cuke step two: extend the world object with the mix-in module
# that adds the support for macros in Cucumber.
World(Macros4Cuke::MacroStepSupport)

# That's all folks!...


# End of file
# encoding: utf-8	You should see a paragraph character: §
# File: env.rb
# Purpose: Allow Cucumber to load the sample application configuration
# and hooks.
# It also demonstrate what to do in your env.rb file 
# to use the Macros4Cuke gem.

begin
  require 'simplecov'
rescue LoadError => exc
  # Gobble silently the exception if simplecov isn't installed.
end

module DemoMacros4Cuke  # Use the module as a namespace

 
# Class created just for testing and demonstration purposes.
# Its instance, will record the output emitted by the steps.

class TracingWorld
  # Will contain the text emitted by the steps
  attr_reader(:trace_steps)
  
  
  def initialize()
    # Constructor  
    @trace_steps = []
  end
  
public
  # Write the given text to the error console
  
  def show(someText)
    $stderr.puts(someText)
  end

  
end # class

end # module

# For testing purpose we override the default Cucumber behaviour
# making our world object an instance of the TracingWorld class
World { DemoMacros4Cuke::TracingWorld.new }



# End of file
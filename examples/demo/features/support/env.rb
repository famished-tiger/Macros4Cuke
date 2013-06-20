# File: env.rb


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
    # Replace every \" sequence by genuine "
    unescaped = someText.gsub(/\\"/, '"')
    $stderr.puts(unescaped)
  end

  
end # class

end # module

# For testing purpose we override the default Cucumber behaviour
# making our world object an instance of the TracingWorld class
World { DemoMacros4Cuke::TracingWorld.new }


# End of file
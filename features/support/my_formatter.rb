module Macros4Cuke # Module used as a namespace

require 'pp'

class MyFormatter
  attr_reader(:ostream)

  def initialize(_, io, _)
    @ostream = io
  end
  
  
  def step_name(_, step_match, _, _, _, _)
    pp step_match
    pp step_match.instance_variables
    
    # Returns a Cucumber::RbSupport::RbStepDefinition
    pp step_match.instance_variable_get(:@step_definition).class
    pp step_match.instance_variable_get(:@step_definition).object_id
    pp step_match.instance_variable_get(:@name_to_match)
    pp step_match.instance_variable_get(:@step_arguments)
  end
end # class

end # module

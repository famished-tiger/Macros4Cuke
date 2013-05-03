# File: macro-step_spec.rb

require_relative '../spec_helper'
require_relative '../../lib/macros4cuke/macro-step-support'	# The class under test


module Macros4Cuke	# Open the module to avoid lengthy qualified names

# Class created just for testing purposes.
class MyWorld
  include Macros4Cuke::MacroStepSupport
end # class

describe MacroStepSupport do
  # Rule to build a bland world object
  let(:world) do  
    w = Object.new
    w.extend(Macros4Cuke::MacroStepSupport)
    w
  end
  
  context "Defining macro(s):" do
    let(:m1_phrase) { "enter the credentials" }
    let(:m1_substeps) do
      ssteps = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Submit"      
SNIPPET
      ssteps
    end
    it "should add valid new macro" do
      lambda { world.add_macro(m1_phrase, m1_substeps, true) }.should_not raise_error
    end
    
    it "should complain when entering the same macro again" do
      # Error case: trying to register another macro with same key/phrase.
      error_message = "A macro-step with phrase 'enter the credentials' already exist."
      lambda { world.add_macro(m1_phrase, m1_substeps, true) }.should raise_error(Macros4Cuke::DuplicateMacroError, error_message)
    end
    
    it "should complain macro uses no table and phrase is parameterless" do
      # Error case: substeps have arguments, but the macro has no mechanism to pass the needed data.
      error_message = "The sub-step argument 'userid' does not appear in the phrase."
      lambda { world.add_macro("fill in the credentials", m1_substeps, false) }.should raise_error(Macros4Cuke::UnreachableSubstepArgument, error_message)    
    end
  end # context

end # describe

end # module


# End of file
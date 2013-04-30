# File: macro-step_spec.rb


require_relative '../spec_helper'
require_relative '../../lib/macros4cuke/macro-step'	# The class under test



module Macros4Cuke	# Open the module to avoid lengthy qualified names

describe MacroStep do
  let(:sample_phrase) { "enter my credentials as <userid>" }
  
  let(:sample_template) do
    snippet = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Submit"
SNIPPET

  snippet
end

  # Default instantiation rule
  subject { MacroStep.new(sample_phrase, sample_template, true) }


  context "Creation & initialization" do
    it "should be created with a phrase, substeps and a table use indicator" do
      lambda { MacroStep.new(sample_phrase, sample_template, true) }.should_not raise_error     
    end
    
      
    it "should complain when a sub-step argument can never be assigned a value via the phrase" do
      error_message = "The sub-step argument 'password' does not appear in the phrase."
      lambda { MacroStep.new(sample_phrase, sample_template, false) }.should raise_error(Macros4Cuke::UnreachableSubstepArgument, error_message)   
    end
    
    
    it "should complain when an argument from the phrase never occurs in a substep" do
      a_phrase = "enter my credentials as <foobar>"
      error_message = "The phrase argument 'foobar' does not appear in a sub-step."
      lambda { MacroStep.new(a_phrase, sample_template, true) }.should raise_error(Macros4Cuke::UselessPhraseArgument, error_message)   
    end    

  
    it "should know its key" do
      subject.key.should == "enter_my_credentials_as_X_T"
    end
  
    it "should know the tags(placeholders) from its phrase" do
      subject.phrase_args.should == %w[userid]
    end
    
    it "should know the tags(placeholders) from its phrase and template" do
      subject.args.should == %w[userid password]    
    end
    
  end # context
  
  
  context "Provided services" do
  
    let(:phrase_instance) {%Q|enter my credentials as "nobody"|}
    
    it "should render the substeps" do
      text = subject.expand(phrase_instance, [ ['password', 'no-secret'] ])
      expectation = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "nobody"
  And I fill in "Password" with "no-secret"
  And I click "Submit"
SNIPPET
      
      text.should == expectation
    end
    
    it "should render steps even when one argument has no actual value" do
      # Special case: password has no value...
      text = subject.expand(phrase_instance, [ ])
      expectation = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "nobody"
  And I fill in "Password" with ""
  And I click "Submit"
SNIPPET
      
      text.should == expectation    
    end
    
    it "should complain when an unknown variable is used" do
      # Error case: there is no macro argument called <unknown>
      error_message = "Unknown macro-step argument 'unknown'."
      lambda { subject.expand(phrase_instance, [ ['unknown', 'anything'] ]) }.should raise_error(UnknownArgumentError, error_message)
    end

  end # context
  

end # describe

end # module

# End of file
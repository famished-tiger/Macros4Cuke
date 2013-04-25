# File: macro-step_spec.rb


require_relative '../spec_helper'
require_relative '../../lib/macros4cuke/macro-step'	# The class under test



module Macros4Cuke	# Open the module to avoid lengthy qualified names

describe MacroStep do
  let(:sample_phrase) { "enter my credentials as <userid>]:" }
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
  subject { MacroStep.new(sample_phrase, sample_template) }


  context "Creation & initialization" do
    it "should be created with a phrase and a template" do
      lambda { MacroStep.new(sample_phrase, sample_template) }.should_not raise_error
    end

  
    it "should know its key/name" do
      subject.name.should == "enter_my_credentials_as_X_T"
    end
  
    it "should know the tags(placeholders) from its phrase" do
      subject.phrase_args.should == %w[userid]
    end
    
    it "should know the tags(placeholders) from its phrase and template" do
      subject.args.should == %w[userid password]    
    end
    
  end # context
  
  
  context "Provided services" do
    it "should render the substeps" do
    end
  end # context
  

end # describe

end # module

# End of file
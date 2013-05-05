# encoding: utf-8 -- You should see a paragraph character: §
# File: macro-collection_spec.rb

require_relative '../spec_helper'
require_relative '../../lib/macros4cuke/macro-collection'	# Load the class under test

module Macros4Cuke # Open this namespace to get rid of module qualifier prefixes

describe MacroCollection do

  let(:singleton) { MacroCollection.instance() }

  context "Initialization:" do
    it "should be empty" do
      singleton.macro_steps.should be_empty
    end

  end

  context "Provided services:" do
    let(:sample_substeps) do
      snippet = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Submit"
SNIPPET

      snippet
    end

    it "should accept the addition of a new macro-step" do
      phrase = "[enter my credentials]"
      lambda { singleton.add_macro(phrase, sample_substeps, true)}.should_not raise_error
      singleton.should have(1).macro_steps

      # Error case: inserting another macro with same phrase.
      error_message = "A macro-step with phrase '[enter my credentials]' already exist."
      lambda { singleton.add_macro(phrase, sample_substeps, true) }.should raise_error(Macros4Cuke::DuplicateMacroError, error_message)
    end
  end

end # describe

end # module


# End of file
# File: macro-step_spec.rb

require_relative '../spec_helper'

# The class under test
require_relative '../../lib/macros4cuke/macro-step-support'


module Macros4Cuke # Open the module to avoid lengthy qualified names
# Class created just for testing purposes.
class MyWorld
  include Macros4Cuke::MacroStepSupport

  # The list of encountered sub-steps
  attr_reader(:substeps)

  # Let's mimicks the behaviour of a Cucumber::RbSupport::RbWorld
  def steps(substep_text)
    @substeps ||= []
    @substeps << substep_text
  end
end # class

describe MacroStepSupport do
  # Rule to build a custom world object
  let(:world) { MyWorld.new }

  let(:phrase1) { 'enter the credentials' }

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

  # Start from a clean situation
  before(:all) do
    MacroCollection.instance.clear
  end


  context 'Defining macro(s):' do
    it 'should add valid new macro' do
      expect { world.add_macro phrase1, m1_substeps, true }.not_to raise_error
    end

    it 'should complain when entering the same macro again' do
      # Error case: trying to register another macro with same key/phrase.
      error_type = Macros4Cuke::DuplicateMacroError
      msg = "A macro-step with phrase 'enter the credentials' already exists."
      expect { world.add_macro(phrase1, m1_substeps, true) }.to raise_error(
        error_type, msg)
    end

    it 'should complain macro uses no table and phrase is parameterless' do
      # Error case: substeps have arguments,
      # but the macro has no mechanism to pass the needed data.
      phrase = 'fill in the credentials'
      msg = "The sub-step argument 'userid' does not appear in the phrase."
      expect { world.add_macro(phrase, m1_substeps, false) }.to raise_error(
        Macros4Cuke::UnreachableSubstepArgument, msg)
    end
  end # context

  context 'Invoking macro(s):' do
    it 'should complain when invoking an unknown macro-step' do
      phrase_unknown = 'dream of a perfect world'
      msg = "Unknown macro-step with phrase: 'dream of a perfect world'."
      expect { world.invoke_macro(phrase_unknown) }.to raise_error(
        Macros4Cuke::UnknownMacroError, msg)
    end

    it "should call the 'steps' method with substeps and variables" do
      # Notice that the call syntax can be used inside step definitions
      world.invoke_macro(phrase1, [%w(userid nobody), %w(password none)])

      # Check that the 'steps' method was indeed called with correct argument
      param_assignments = { '<userid>' => 'nobody', '<password>' => 'none' }
      expected_text = m1_substeps.gsub(/<\S+>/, param_assignments)
      expect(world.substeps.first).to eq(expected_text)
    end
  end # context

  context 'Clearing macro(s):' do
    it 'should clear all macros' do
      expect { world.clear_macros }.not_to raise_error

      # Control the post-condition
      expect(MacroCollection.instance.macro_steps).to be_empty
    end
  end # context
end # describe
end # module


# End of file

# encoding: utf-8
# File: macro-step_spec.rb


require_relative '../spec_helper'
require_relative '../../lib/macros4cuke/macro-step'	# The class under test



module Macros4Cuke	# Open the module to avoid lengthy qualified names

describe MacroStep do
  let(:sample_phrase) { 'enter my credentials as <userid>' }

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


  context 'Creation & initialization:' do
    it 'should be created with a phrase, substeps and a table use indicator' do
      expect { MacroStep.new(sample_phrase, sample_template, true) }.not_to raise_error
    end


    it 'should complain when a sub-step argument can never be assigned a value via the phrase' do
      msg = "The sub-step argument 'password' does not appear in the phrase."
      expect { MacroStep.new(sample_phrase, sample_template, false) }.to raise_error(
        Macros4Cuke::UnreachableSubstepArgument, msg)
    end


    it 'should complain when an argument in phrase never occurs in substeps' do
      phrase = 'enter my credentials as <foobar>'
      msg = "The phrase argument 'foobar' does not appear in a sub-step."
      expect { MacroStep.new(phrase, sample_template, true) }.to raise_error(
        Macros4Cuke::UselessPhraseArgument, msg)
    end


    it 'should know its key' do
      expect(subject.key).to eq('enter_my_credentials_as_X_T')
    end

    it 'should know the tags(placeholders) from its phrase' do
      expect(subject.phrase_args).to eq(%w[userid])
    end

    it 'should know the tags(placeholders) from its phrase and template' do
      expect(subject.args).to eq(%w[userid password])
    end

  end # context


  context 'Provided services:' do

    let(:phrase_instance) { %Q|enter my credentials as "nobody"| }
    it 'should render the substeps' do
      text = subject.expand(phrase_instance, [ %w(password no-secret) ])
      expectation = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "nobody"
  And I fill in "Password" with "no-secret"
  And I click "Submit"
SNIPPET

      expect(text).to eq(expectation)
    end

    it 'should render steps even when one argument has no actual value' do
      # Special case: password has no value...
      text = subject.expand(phrase_instance, [ ])
      expectation = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "nobody"
  And I fill in "Password" with ""
  And I click "Submit"
SNIPPET

      expect(text).to eq(expectation)
    end

    it 'should un-escape the double-quotes for phrase arguments' do
      specific_phrase = %q|enter my credentials as "quotable\""|
      text = subject.expand(specific_phrase, [ %w(password no-secret) ])
      expectation = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "quotable""
  And I fill in "Password" with "no-secret"
  And I click "Submit"
SNIPPET

      expect(text).to eq(expectation)
    end


    it 'should complain when an unknown variable is used' do
      # Error case: there is no macro argument called <unknown>
      error_message = "Unknown macro-step argument 'unknown'."
      args = [ %w(unknown anything) ]
      expect { subject.expand(phrase_instance, args) }.to raise_error(
        UnknownArgumentError, error_message)
    end


    it 'should complain when argument gets a value from phrase and table' do
      # Error case: there is no macro argument called <unknown>
      phrase = %Q|enter my credentials as "nobody"|
      msg = "The macro argument 'userid' has value 'nobody' and 'valueTable'."
      args = [ %w(userid someone), %w(password no-secret) ]
       expect { subject.expand(phrase, args) }.to raise_error(
        AmbiguousArgumentValue, msg)
    end


    it 'should expand built-in variables' do
      phrase = 'do nothing useful'
      substeps = <<-SNIPPET
  Given I travel through:
  <quotes>
  London
  Paris
  San Francisco
  <quotes>
SNIPPET

      instance = MacroStep.new(phrase, substeps, true)
      actual = instance.expand(phrase, [])
      expected = substeps.gsub(/<quotes>/, '"""')
      expect(actual).to eq(expected)
    end


  end # context

end # describe

end # module

# End of file
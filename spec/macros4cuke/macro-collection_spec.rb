# frozen_string_literal: true

# File: macro-collection_spec.rb

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/macros4cuke/macro-collection'

module Macros4Cuke # Open this namespace to avoid module qualifier prefixes
describe MacroCollection do
  let(:singleton) { MacroCollection.instance }

  before(:all) do
    MacroCollection.instance.clear
  end

  context 'Initialization:' do
    it 'should be empty' do
      expect(singleton.macro_steps).to be_empty
    end
  end # context

  context 'Provided services:' do
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

    it 'should accept the addition of a new macro-step' do
      phrase = '[enter my credentials]'
      args = [phrase, sample_substeps, true]
      expect { singleton.add_macro(*args) }.not_to raise_error
      expect(singleton.macro_steps.size).to eq(1)

      # Error case: inserting another macro with same phrase.
      exc = Macros4Cuke::DuplicateMacroError
      msg = "A macro-step with phrase '[enter my credentials]' already exists."
      expect { singleton.add_macro(*args) }.to raise_error(exc, msg)
    end

    it 'should return the rendition of a given macro-step' do
      phrase = '[enter my credentials]'
      input_values = [ %w[userid nobody], %w[password no-secret] ]
      rendered = singleton.render_steps(phrase, input_values)
      expected = <<-SNIPPET
  Given I landed in the homepage
  When I click "Sign in"
  And I fill in "Username" with "nobody"
  And I fill in "Password" with "no-secret"
  And I click "Submit"
SNIPPET
      expect(rendered).to eq(expected)
    end
  end # context
end # describe
end # module

# End of file

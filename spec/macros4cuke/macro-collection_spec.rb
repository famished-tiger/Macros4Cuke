# encoding: utf-8 -- You should see a paragraph character: §
# File: macro-collection_spec.rb

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/macros4cuke/macro-collection'

module Macros4Cuke # Open this namespace to avoid module qualifier prefixes

describe MacroCollection do

  let(:singleton) { MacroCollection.instance() }

  context 'Initialization:' do
    it 'should be empty' do
      expect(singleton.macro_steps).to be_empty
    end

  end

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
      expect(singleton).to have(1).macro_steps

      # Error case: inserting another macro with same phrase.
      msg = "A macro-step with phrase '[enter my credentials]' already exist."
      expect { singleton.add_macro(*args) }.to raise_error(
        Macros4Cuke::DuplicateMacroError, msg)
    end

    it 'should return the rendition of a given macro-step' do
      phrase = '[enter my credentials]'
      input_values = [ ['userid', 'nobody'], ['password', 'no-secret'] ]
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
    

  end

end # describe

end # module


# End of file
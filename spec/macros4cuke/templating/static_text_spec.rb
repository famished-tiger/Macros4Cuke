# File: placeholder_spec.rb
require_relative '../../spec_helper'

# Load the classes under test
require_relative '../../../lib/macros4cuke/templating/static-text'

module Macros4Cuke
module Templating # Open this namespace to get rid of module qualifier prefixes
describe StaticText do
  let(:sample_text) { 'Some text' }
  
  subject { StaticText.new(sample_text) }

  context 'Creation and initialization:' do
    it 'should be created with a text' do
      expect { StaticText.new(sample_text) }.not_to raise_error
    end
    
    it 'should know its source text' do
      expect(subject.source).to eq(sample_text)
    end
    
  end # context
  
  context 'Provided services:' do
    it 'should render the source text as is' do
      context = double('fake_context')
      locals = double('fake_locals')
      
      expect(subject.render(context, locals)).to eq(sample_text)
    end
  
  end # context  
end # describe
end # module
end # module

# End of file

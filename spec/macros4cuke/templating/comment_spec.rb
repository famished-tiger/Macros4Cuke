# File: placeholder_spec.rb

require_relative '../../spec_helper'

# Load the classes under test
require_relative '../../../lib/macros4cuke/templating/template-element'

module Macros4Cuke

module Templating # Open this namespace to get rid of module qualifier prefixes


describe Comment do
  let(:sample_text) { 'Some text' }
  
  subject { Comment.new(sample_text) }

  context "Creation and initialization:" do
    it 'should be created with a text' do
      expect { Comment.new(sample_text) }.not_to raise_error
    end
    
    it 'should know its source text' do
      expect(subject.source).to eq(sample_text)
    end
    
  end # context
  
  context "Provided services:" do
    it 'should render tan empty text' do
      context = double('fake_context')
      locals = double('fake_locals')
      
      expect(subject.render(context, locals)).to be_empty
    end
  
  end # context  

end # describe

end # module

end # module

# End of file
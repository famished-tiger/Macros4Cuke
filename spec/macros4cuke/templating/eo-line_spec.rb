# File: eo-line_spec.rb

require_relative '../../spec_helper'

# Load the classes under test
require_relative '../../../lib/macros4cuke/templating/eo-line'

module Macros4Cuke
module Templating # Open this namespace to get rid of module qualifier prefixes
describe EOLine do
  subject { EOLine.new }

  context 'Creation and initialization:' do
    it 'should be created without argument' do
      expect { EOLine.new }.not_to raise_error
    end   
  end # context
  
  context 'Provided services:' do
    it 'should render a new line' do
      context = double('fake_context')
      locals = double('fake_locals')
      
      expect(subject.render(context, locals)).to eq("\n")
    end
  
  end # context  
end # describe
end # module
end # module

# End of file

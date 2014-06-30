# File: to-null_spec.rb

require_relative '../../spec_helper'

# Load mix-in module for creating a sample collection of macro-steps
require_relative '../use-sample-collection'


require_relative '../../../lib/macros4cuke/formatting-service'
# Load the class under test
require_relative '../../../lib/macros4cuke/formatter/to-null'

module Macros4Cuke

module Formatter # Open this namespace to get rid of module qualifier prefixes

describe ToNull do
  include UseSampleCollection # Add convenience methods for sample collection

  before(:all) do
    # Fill the collection of macro-steps with sample steps
    fill_collection
  end

  after(:all) do
    # Clear the collection to prevent interference between spec files
    macro_coll.clear
  end


  context 'Initialization:' do
    it 'should be created without parameter' do
      expect { ToNull.new }.not_to raise_error
    end

    it 'should react to all the notifications' do
      instance = ToNull.new
      expect(instance.implements).to eq(Formatter::AllNotifications)
    end

  end # context


  context 'Provided services:' do
    # Default instantiation rule
    subject { ToNull.new }

    it 'should render a given macro-step collection' do
      service = FormattingService.new
      service.register(subject)
      expect { service.start!(macro_coll) }.not_to raise_error
    end
  end # context

end # describe

end # module

end # module


# End of file

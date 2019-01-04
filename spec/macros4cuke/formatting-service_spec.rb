# File: collection-walker_spec.rb

require_relative '../spec_helper'

# Load mix-in module for creating a sample collection of macro-steps
require_relative 'use-sample-collection'


# Load the class under test
require_relative '../../lib/macros4cuke/formatting-service'

module Macros4Cuke # Open this namespace to avoid module qualifier prefixes
describe FormattingService do
  include UseSampleCollection # Add convenience methods for sample collection

  # Default instantiation rule
  subject { FormattingService.new }

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
      expect { FormattingService.new }.not_to raise_error
    end

    it 'has no formatter at start' do
      expect(subject.formatters).to be_empty
    end
  end # context


  context 'Provided services:' do
    it 'should know its registered formatter(s)' do
      formatter1 = double('fake_one')
      events = [:on_collection]
      expect(formatter1).to receive(:implements).once.and_return(events)
      subject.register(formatter1)
      expect(subject.formatters.size).to eq(1)

      formatter2 = double('fake_two')
      expect(formatter2).to receive(:implements).once.and_return([:on_step])
      subject.register(formatter2)
      expect(subject.formatters.size).to eq(2)

      expect(subject.formatters).to eq([formatter1, formatter2])
    end

    it "should complain when a formatter doesn't implement notifications" do
      formatter1 = double('formatter')
      expect(formatter1).to receive(:implements).once.and_return([])
      err_type = Macros4Cuke::NoFormattingEventForFormatter
      err_msg = 'Formatter RSpec::Mocks::Double does not'\
      ' support any formatting event.'
      expect { subject.register(formatter1) }.to raise_error(err_type, err_msg)
    end

    it 'should complain when a formatter uses an unknown formatting event' do
      notifications = %i[
        on_collection on_collection_end non_standard on_step on_step_end
      ]
      formatter = double('formatter')
      expect(formatter).to receive(:implements).once.and_return(notifications)
      err_type = Macros4Cuke::UnknownFormattingEvent
      err_msg = "Formatter RSpec::Mocks::Double uses\
 the unknown formatting event 'non_standard'."
      expect { subject.register(formatter) }.to raise_error(err_type, err_msg)
    end

    it 'should support formatters using a subset of possible notifications' do
      # Case: formatter that supports a few notifications only
      formatter1 = double('formatter')
      supported_notifications = %i[
        on_collection on_collection_end on_step on_step_end
      ]
      expect(formatter1).to receive(:implements)
        .at_least(69).times
        .and_return(supported_notifications)
      subject.register(formatter1)

      # Test the notifications send to the formatter
      expect(formatter1).to receive(:on_collection).once do |level, coll|
        expect(level).to eq(0)
        expect(coll).to eq(macro_coll)
      end

      expect(formatter1).to receive(:on_step).twice do |level, a_step|
        expect(level).to eq(1)
        expect(macro_coll.macro_steps.values).to include(a_step)
      end

      expect(formatter1).to receive(:on_step_end).twice do |level, arg|
        expect(level).to eq(1)
        expect(arg).to be_nil
      end

      expect(formatter1).to receive(:on_collection_end).once do |level, arg|
        expect(level).to eq(0)
        expect(arg).to be_nil
      end
      subject.start!(macro_coll)
    end

    it 'should support multiple formatters' do
      formatter1 = double('formatter')
      supported_notifications = [:on_collection]
      expect(formatter1).to receive(:implements)
        .at_least(69 * 3).times
        .and_return(supported_notifications)

      # Cheating: registering three times the same formatter...
      3.times { subject.register(formatter1) }

      # ... then the collection is formatted three times
      expect(formatter1).to receive(:on_collection).at_least(3).times
      subject.start!(macro_coll)
    end
  end # context
end # describe
end # module


# End of file

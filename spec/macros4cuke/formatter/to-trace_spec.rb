# frozen_string_literal: true

# File: to-trace_spec.rb
require 'stringio'
require_relative '../../spec_helper'

# Load mix-in module for creating a sample collection of macro-steps
require_relative '../use-sample-collection'


require_relative '../../../lib/macros4cuke/formatting-service'
# Load the class under test
require_relative '../../../lib/macros4cuke/formatter/to-trace'

module Macros4Cuke
module Formatter # Open this namespace to get rid of module qualifier prefixes
describe ToTrace do
  include UseSampleCollection # Add convenience methods for sample collection

  let(:destination) { StringIO.new }

  before(:all) do
    # Fill the collection of macro-steps with sample steps
    fill_collection
  end

  after(:all) do
    # Clear the collection to prevent interference between spec files
    macro_coll.clear
  end


  context 'Initialization:' do
    it 'should be created with an IO parameter' do
      expect { ToTrace.new(destination) }.not_to raise_error
    end

    it 'should react to all the notifications' do
      instance = ToTrace.new(destination)
      expect(instance.implements).to eq(Formatter::AllNotifications)
    end
  end # context


  context 'Provided services:' do
    # Default instantiation rule
    subject { ToTrace.new(destination) }

    # The expected event trace for the sample collection
    let(:expected_trace) do
      trace_details = <<-SNIPPET
on_collection
  on_step
    on_phrase
    on_renderer
      on_source
      on_static_text
      on_eol
      on_static_text
      on_eol
      on_static_text
      on_placeholder
      on_static_text
      on_eol
      on_static_text
      on_placeholder
      on_static_text
      on_eol
      on_static_text
      on_eol
    on_renderer_end
  on_step_end
  on_step
    on_phrase
    on_renderer
      on_source
      on_static_text
      on_placeholder
      on_static_text
      on_eol
      on_static_text
      on_placeholder
      on_static_text
      on_eol
      on_static_text
      on_placeholder
      on_static_text
      on_eol
      on_static_text
      on_placeholder
      on_static_text
      on_eol
      on_static_text
      on_placeholder
      on_static_text
      on_eol
      on_static_text
      on_placeholder
      on_static_text
      on_eol
      on_eol
      on_comment
      on_eol
      on_comment
      on_eol
      on_comment
      on_eol
      on_section
        on_static_text
        on_placeholder
        on_static_text
        on_eol
      on_section_end
      on_eol
      on_comment
      on_eol
      on_comment
      on_eol
      on_comment
      on_eol
      on_section
        on_static_text
        on_placeholder
        on_static_text
        on_eol
      on_section_end
      on_static_text
      on_eol
    on_renderer_end
  on_step_end
on_collection_end
SNIPPET

      trace_details
    end


    it 'should render the trace event for a given macro-step collection' do
      service = FormattingService.new
      service.register(subject)
      expect { service.start!(macro_coll) }.not_to raise_error
      expect(subject.io.string).to eq(expected_trace)
    end
  end # context
end # describe
end # module
end # module


# End of file

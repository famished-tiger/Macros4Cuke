# frozen_string_literal: true

# File: collection-walker_spec.rb

require_relative '../spec_helper'

# Load mix-in module for creating a sample collection of macro-steps
require_relative 'use-sample-collection'

# Load the class under test
require_relative '../../lib/macros4cuke/coll-walker-factory'

module Macros4Cuke # Open this namespace to avoid module qualifier prefixes
describe CollWalkerFactory do
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
      expect { CollWalkerFactory.new }.not_to raise_error
    end
  end # context

  context 'Provided factory services:' do
    # Default factory instantiation
    subject { CollWalkerFactory.new }

    it 'should build a walker for the given macro collection' do
      walker = subject.build_walker(macro_coll)
      expect(walker).to be_kind_of(Enumerator)
    end
  end # context

  context 'Provided walker services:' do
    # Default walker instantiation
    subject do
      factory = CollWalkerFactory.new
      factory.build_walker(macro_coll)
    end


    it 'should notify the start of the visit of the collection' do
      initial_event = subject.next
      expect(initial_event).to eq([:on_collection, 0, macro_coll])
    end

    it 'should notify the visit of a first macro step' do
      1.times { subject.next }
      first_step = subject.next
      step1 = macro_coll.macro_steps.values[0]
      expect(first_step).to eq([:on_step, 1, step1])
    end

    it 'should notify the visit of the phrase of the first macro step' do
      2.times { subject.next }
      first_phrase = subject.next
      sample_phrase1 = UseSampleCollection::SamplePhrase1
      expect(first_phrase).to eq([:on_phrase, 2, sample_phrase1, true])
    end

    it 'should notify the visit of the substeps renderer of the first step' do
      3.times { subject.next }
      first_step = macro_coll.macro_steps.values[0]
      first_renderer = subject.next
      expectation = [:on_renderer, 2, first_step.renderer]
      expect(first_renderer).to eq(expectation)
    end

    it 'should notify the visit of the internal representation of substeps' do
      first_step = macro_coll.macro_steps.values[0]
      substep_chunks = first_step.renderer.representation
      4.times { subject.next }
      text_representation = subject.next
      expectation = [:on_source, 3, first_step.renderer.source]
      expect(text_representation).to eq(expectation)

      first_substep_piece = subject.next
      expectation = [:on_static_text, 3, substep_chunks[0].source]
      expect(first_substep_piece).to eq(expectation)

      second_substep_piece = subject.next
      expect(second_substep_piece).to eq([:on_eol, 3, nil])

      third_substep_piece = subject.next
      expectation = [:on_static_text, 3, substep_chunks[2].source]
      expect(third_substep_piece).to eq(expectation)

      fourth_substep_piece = subject.next
      expect(fourth_substep_piece).to eq([:on_eol, 3, nil])

      fifth_substep_piece = subject.next
      expectation = [:on_static_text, 3, substep_chunks[4].source]
      expect(fifth_substep_piece).to eq(expectation)

      sixth_substep_piece = subject.next
      expectation = [:on_placeholder, 3, substep_chunks[5].name]
      expect(sixth_substep_piece).to eq(expectation)

      seventh_substep_piece = subject.next
      expectation = [:on_static_text, 3, substep_chunks[6].source]
      expect(seventh_substep_piece).to eq(expectation)

      eighth_substep_piece = subject.next
      expect(eighth_substep_piece).to eq([:on_eol, 3, nil])

      ninth_substep_piece = subject.next
      expectation = [:on_static_text, 3, substep_chunks[8].source]
      expect(ninth_substep_piece).to eq(expectation)

      tenth_substep_piece = subject.next
      expectation = [:on_placeholder, 3, substep_chunks[9].name]
      expect(tenth_substep_piece).to eq(expectation)

      eleventh_substep_piece = subject.next
      expectation = [:on_static_text, 3, substep_chunks[10].source]
      expect(eleventh_substep_piece).to eq(expectation)

      twelfth_substep_piece = subject.next
      expect(twelfth_substep_piece).to eq([:on_eol, 3, nil])

      thirtieth_substep_piece = subject.next
      expectation = [:on_static_text, 3, substep_chunks[12].source]
      expect(thirtieth_substep_piece).to eq(expectation)

      fourteenth_substep_piece = subject.next
      expect(fourteenth_substep_piece).to eq([:on_eol, 3, nil])

      fifteenth_substep_piece = subject.next
      expect(fifteenth_substep_piece).to eq([:on_renderer_end, 2, nil])
    end

    it 'should notify the visit of a following macro step' do
      (4 + 15 + 1).times { subject.next }
      end_step = subject.next
      expect(end_step).to eq([:on_step_end, 1, nil])
      a_step = subject.next
      expect(a_step).to eq([:on_step, 1, macro_coll.macro_steps.values[1]])
    end

    it 'should notify the visit of the phrase of a following macro step' do
      (4 + 16 + 2).times { subject.next }
      phrase = subject.next
      sample_phrase = UseSampleCollection::SamplePhrase2
      expect(phrase).to eq([:on_phrase, 2, sample_phrase, true])
    end

    it 'should notify the visit of the substeps of a following step' do
      (4 + 16 + 3).times { subject.next }
      a_renderer = subject.next
      second_step = macro_coll.macro_steps.values[1]
      expect(a_renderer).to eq([:on_renderer, 2, second_step.renderer])
    end

    it 'should notify the visit in substeps of following step' do
      second_step = macro_coll.macro_steps.values[1]
      substep_chunks = second_step.renderer.representation.dup
      substep_chunks.map! do |ck|
        if ck.is_a?(Templating::Section)
          [ck, ck.children, ck].flatten
        else
          ck
        end
      end
      substep_chunks.flatten!

      (4 + 16 + 4).times { subject.next }
      substeps_text = subject.next
      expectation = [:on_source, 3, second_step.renderer.source]
      expect(substeps_text).to eq(expectation)

      first_substep_piece = subject.next
      expectation = [:on_static_text, 3, substep_chunks[0].source]
      expect(first_substep_piece).to eq(expectation)

      [
        [:on_placeholder, 3, :name], # 0
        [:on_static_text, 3, :source], # 1
        [:on_eol, 3, nil], # 2
        [:on_static_text, 3, :source], # 3
        [:on_placeholder, 3, :name], # 4
        [:on_static_text, 3, :source], # 5
        [:on_eol, 3, nil], # 6
        [:on_static_text, 3, :source], # 7
        [:on_placeholder, 3, :name], # 8
        [:on_static_text, 3, :source], # 9
        [:on_eol, 3, nil], # 10
        [:on_static_text, 3, :source], # 11
        [:on_placeholder, 3, :name], # 12
        [:on_static_text, 3, :source], # 13
        [:on_eol, 3, nil], # 14
        [:on_static_text, 3, :source], # 15
        [:on_placeholder, 3, :name], # 16
        [:on_static_text, 3, :source], # 17
        [:on_eol, 3, nil], # 18
        [:on_static_text, 3, :source], # 19
        [:on_placeholder, 3, :name], # 20
        [:on_static_text, 3, :source], # 21
        [:on_eol, 3, nil], # 22
        [:on_eol, 3, nil], # 23
        [:on_comment, 3, :source], # 24
        [:on_eol, 3, nil], # 25
        [:on_comment, 3, :source], # 26
        [:on_eol, 3, nil], # 27
        [:on_comment, 3, :source], # 28
        [:on_eol, 3, nil], # 29
        [:on_section, 3, :name], # 30
        [:on_static_text, 4, :source], # 31
        [:on_placeholder, 4, :name], # 32
        [:on_static_text, 4, :source], # 33
        [:on_eol, 4, nil], # 34
        [:on_section_end, 3, nil], # 35
        [:on_eol, 3, nil], # 36
        [:on_comment, 3, :source], # 37
        [:on_eol, 3, nil], # 38
        [:on_comment, 3, :source], # 39
        [:on_eol, 3, nil], # 40
        [:on_comment, 3, :source], # 41
        [:on_eol, 3, nil], # 42
        [:on_section, 3, :name], # 43
        [:on_static_text, 4, :source], # 44
        [:on_placeholder, 4, :name], # 45
        [:on_static_text, 4, :source], # 46
        [:on_eol, 4, nil], # 47
        [:on_section_end, 3, nil], # 48
        [:on_static_text, 3, :source], # 49
        [:on_eol, 3, nil], # 50
        [:on_renderer_end, 2, nil], # 51
        [:on_step_end, 1, nil], # 52
        [:on_collection_end, 0, nil] # 53
      ].each_with_index do |event, i|
        actual = subject.next
        expect(actual[0]).to eq(event[0])
        expect(actual[1]).to eq(event[1])
        if event[2]
          expected_obj = substep_chunks[i + 1]
          expect(actual[2]).to eq(expected_obj.send(event[2]))
        end
      end
      expect { subject.next }.to raise_error(StopIteration)
    end

    # Must be last test script since it pollutes the macro-collection
    it 'should complain when visiting an unsupported node' do
      first_step = macro_coll.macro_steps.values[0]
      first_step.renderer.representation.insert(2, :not_a_valid_element)
      err_type = Macros4Cuke::InternalError
      err_msg = "Don't know how to format a Symbol."
      expect { subject.each { |_| } }.to raise_error(err_type, err_msg)
    end
  end # context
end # describe
end # module


# End of file

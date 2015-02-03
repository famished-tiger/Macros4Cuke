# File: placeholder_spec.rb

require_relative '../../spec_helper'

# Load the classes under test
require_relative '../../../lib/macros4cuke/templating/placeholder'

module Macros4Cuke
module Templating # Open this namespace to get rid of module qualifier prefixes
describe Placeholder do
  # Default instantiation rule
  subject { Placeholder.new('foobar') }

  context 'Creation and initialization:' do
    it 'should be created with a variable name' do
      expect { Placeholder.new('foobar') }.not_to raise_error
    end

    it 'should know the name of its variable' do
      expect(subject.name).to eq('foobar')
    end
  end # context

  context 'Provided services:' do
    it 'should render an empty string when no actual value is absent' do
      # Case: context has no value associated to 'foobar'
      rendered_text = subject.render(Object.new, {})
      expect(rendered_text).to be_empty

      # Case: locals Hash has a nil value associated to 'foobar'
      rendered_text = subject.render(Object.new, 'foobar' => nil)
      expect(rendered_text).to be_empty

      # Case: context object has a nil value associated to 'foobar'
      context = Object.new
      def context.foobar  # Add singleton method foobar that returns nil
        nil
      end
      rendered_text = subject.render(context, {})
      expect(rendered_text).to be_empty
    end

    it 'should render the actual value bound to the placeholder' do
      # Case: locals Hash has a value associated to 'foobar'
      rendered_text = subject.render(Object.new, 'foobar' => 'hello')
      expect(rendered_text).to eq('hello')

      # Case: context object has a value associated to 'foobar'
      context = Object.new
      def context.foobar # Add singleton method foobar that returns 'world'
        'world'
      end
      rendered_text = subject.render(context, {})
      expect(rendered_text).to eq('world')
    end
  end # context
end # describe
end # module
end # module

# End of file

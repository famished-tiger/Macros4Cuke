# encoding: utf-8 -- You should see a paragraph character: §
# File: section_spec.rb

require_relative '../../spec_helper'
require_relative '../../../lib/macros4cuke/templating/engine'	# Load the classes under test

module Macros4Cuke

module Templating # Open this namespace to get rid of module qualifier prefixes


describe Placeholder do
  # Default instantiation rule
  subject { Placeholder.new('foobar') }

  context "Creation and initialization:" do

    it "should be created with a variable name" do
      lambda { Placeholder.new('foobar') }.should_not raise_error
    end
    
    it "should know the name of its variable" do 
      subject.name.should == 'foobar'
    end    

  end # context 

  context "Provided services:" do 
    it "should render an empty string when no actual value is bound to the placeholder" do
      # Case: context has no value associated to 'foobar'
      rendered_text = subject.render(Object.new, {})
      rendered_text.should be_empty
      
      # Case: locals Hash has a nil value associated to 'foobar'
      rendered_text = subject.render(Object.new, {'foobar' => nil})
      rendered_text.should be_empty

      # Case: context object has a nil value associated to 'foobar'
      context = Object.new
      def context.foobar; nil; end  # Add singleton method foobar that returns nil
      rendered_text = subject.render(context, {})
      rendered_text.should be_empty        
    end
    
    it "should render the actual value bound to the placeholder" do
      # Case: locals Hash has a value associated to 'foobar'
      rendered_text = subject.render(Object.new, {'foobar' => 'hello'})
      rendered_text.should == 'hello'

      # Case: context object has a value associated to 'foobar'
      context = Object.new
      def context.foobar; 'world'; end  # Add singleton method foobar that returns 'world'
      rendered_text = subject.render(context, {})
      rendered_text.should == 'world'       
    end
  
  end # context

end # describe

end # module

end # module

# End of file
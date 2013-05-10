# encoding: utf-8 -- You should see a paragraph character: §
# File: section_spec.rb

require_relative '../../spec_helper'
require_relative '../../../lib/macros4cuke/templating/engine'	# Load the classes under test

module Macros4Cuke

module Templating # Open this namespace to get rid of module qualifier prefixes

# Spec for abstract class Section.
describe Section do
  # Default instantiation rule
  subject { Section.new('foobar') } 
  
  # Return a list of possible child elements
  let(:sample_children) do
    [ StaticText.new("Hello "),
      Placeholder.new("user"),
      EOLine.new
    ]
  end 

  context "Creation and initialization" do
 
    it "should be created with a variable name" do
      lambda { Section.new('foobar') }.should_not raise_error 
    end
    
    it "should know the name of its variable" do 
      subject.name.should == 'foobar'
    end

    it "should have no child at start" do
      subject.should have(0).children
    end    
  
  end # context
  
  context "Provided services:" do  
    it "should add child element(s)" do
      sample_children.each do |a_child|
        subject.add_child(a_child)
      end

      # Control that the addition work as expected
      subject.children.should == sample_children
    end
    
    it "should know the name all child placeholders" do
      # Case: simple flat list of children
      sample_children.each { |a_child| subject.add_child(a_child) }
      subject.variables.should == [ 'user' ]
      
      # Case: at least one child is a group    
      parent = Section.new('son')
      [ 
        subject,
        StaticText.new("Bye "),
        Placeholder.new("firstname"),
        EOLine.new
      ].each { |a_child| parent.add_child(a_child) } 

      parent.variables.should == [ 'user', 'firstname']
      
    end
    
    
    it "should expect that its subclasses render the children" do
      error_message = "Method Section::render must be implemented in subclass(es)."
      lambda {subject.send(:render, Object.new, {}) }.should raise_error(NotImplementedError, error_message)
    end
    
  end # context

end # describe




describe ConditionalSection do

  context "Creation and initialization:" do

    it "should be created with a variable name and a boolean" do
      lambda { ConditionalSection.new('foobar', false) }.should_not raise_error
      lambda { ConditionalSection.new('foobar', true) }.should_not raise_error
    end

    it "should know whether the rendition on existence of actual value or not" do
      [false, true].each do |existence|
        instance = ConditionalSection.new('foobar', existence)
        instance.existence.should == existence
      end
    end

  end # context

  context "Provided services:" do
    # Return a list of possible child elements
    let(:sample_children) do
      [ StaticText.new("Hello "),
        Placeholder.new("user"),
        EOLine.new
      ]
    end

    # Default instantiation rule
    subject { ConditionalSection.new('foobar', true) }
    
    it "should know its original source text" do
      subject.to_s.should == '<?foobar>'
    end

    it "should render its children when conditions are met" do
      # Adding the children
      sample_children.each { |a_child| subject.add_child(a_child) }

      # Case of an existing actual
      locals = {'user' => "joe", "foobar" => 'exists' }
      rendered_text = subject.render(Object.new, locals)
      expected_text = "Hello joe\n"
      rendered_text.should == expected_text

      # Case of a conditional section that should be rendering when value is non-existing.
      instance = ConditionalSection.new('foobar', false)
      sample_children.each { |a_child| instance.add_child(a_child) }

      # Case of a non-existing actual
      locals = {'user' => "joe" }
      rendered_text = instance.render(Object.new, locals)
      rendered_text.should == expected_text
    end

    it "should render noting when conditions are'nt met" do
      # Adding the children
      sample_children.each { |a_child| subject.add_child(a_child) }

      # Case of a non-existing actual
      locals = {'user' => "joe"}
      rendered_text = subject.render(Object.new, locals)
      rendered_text.should == ""

      # Case of a conditional section that should be rendering when value is non-existing.
      instance = ConditionalSection.new('foobar', false)
      sample_children.each { |a_child| instance.add_child(a_child) }

      # Case of a non-existing actual
      locals = {'user' => "joe", "foobar" => 'exists' }
      rendered_text = instance.render(Object.new, locals)
      rendered_text.should == ""
    end

  end # context

end # describe

end # module

end # module

# End of file
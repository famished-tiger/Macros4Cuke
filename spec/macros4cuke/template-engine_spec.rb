# encoding: utf-8 -- You should see a paragraph character: §
# File: template-engine_spec.rb

require_relative '../spec_helper'
require_relative '../../lib/macros4cuke/template-engine'	# Load the class under test

module Macros4Cuke # Open this namespace to get rid of module qualifier prefixes

describe TemplateEngine do
  let(:sample_template) do
      source = <<-SNIPPET
  Given I landed in the homepage
  # The credentials are entered here
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Sign in"
SNIPPET
    end

  # Rule for default instantiation 
  subject { TemplateEngine.new sample_template }


  context "Class services" do
    # Convenience method used to shorten method call.
    def parse_it(aText)
      return TemplateEngine::parse(aText)
    end

    # remove enclosing chevrons <..> (if any)
    def strip_chevrons(aText)
      return aText.gsub(/^<|>$/, '')
    end

    it "should parse an empty text line" do
      # Expectation: result should be an empty array.
      parse_it('').should be_empty
    end

    it "should parse a text line without tag" do
      sample_text = 'Mary has a little lamb'
      result = parse_it(sample_text)

      # Expectation: an array with one couple: [:static, the source text]
      result.should have(1).items
      result[0].should == [:static, sample_text]
    end

    it "should parse a text line that consists of just a tag" do
      sample_text = '<some_tag>'
      result = parse_it(sample_text)

      # Expectation: an array with one couple: [:static, the source text]
      result.should have(1).items
      result[0].should == [:dynamic, strip_chevrons(sample_text)]
    end

    it "should parse a text line with a tag at the start" do
      sample_text = '<some_tag>some text'
      result = parse_it(sample_text)

      # Expectation: an array with two couples: [dynamic, 'some_tag'][:static, some text]
      result.should have(2).items
      result[0].should == [:dynamic, 'some_tag']
      result[1].should == [:static,  'some text']
    end

    it "should parse a text line with a tag at the end" do
      sample_text = 'some text<some_tag>'
      result = parse_it(sample_text)

      # Expectation: an array with two couples: [:static, some text] [dynamic, 'some_tag']
      result.should have(2).items
      result[0].should == [:static,  'some text']
      result[1].should == [:dynamic, 'some_tag']
    end

    it "should parse a text line with a tag in the middle" do
      sample_text = 'begin <some_tag> end'
      result = parse_it(sample_text)

      # Expectation: an array with three couples:
      result.should have(3).items
      result[0].should == [:static,  'begin ']
      result[1].should == [:dynamic, 'some_tag']
      result[2].should == [:static,  ' end']
    end

    it "should parse a text line with two tags in the middle" do
      sample_text = 'begin <some_tag>middle<another_tag> end'
      result = parse_it(sample_text)

      # Expectation: an array with items couples:
      result.should have(5).items
      result[0].should == [:static ,  'begin ']
      result[1].should == [:dynamic, 'some_tag']
      result[2].should == [:static , 'middle']
      result[3].should == [:dynamic, 'another_tag']
      result[4].should == [:static,  ' end']

      # Case: two consecutive tags
      sample_text = 'begin <some_tag><another_tag> end'
      result = parse_it(sample_text)

      # Expectation: an array with four couples:
      result.should have(4).items
      result[0].should == [:static,  'begin ']
      result[1].should == [:dynamic, 'some_tag']
      result[2].should == [:dynamic, 'another_tag']
      result[3].should == [:static,  ' end']
    end

    it "should parse a text line with escaped chevrons" do
      sample_text = 'Mary has a \<little\> lamb'
      result = parse_it(sample_text)

      # Expectation: an array with one couple: [:static, the source text]
      result.should have(1).items
      result[0].should == [:static, sample_text]
    end

    it "should parse a text line with escaped chevrons in a tag" do
      sample_text = 'begin <some_\<\\>weird\>_tag> end'
      result = parse_it(sample_text)

      # Expectation: an array with three couples:
      result.should have(3).items
      result[0].should == [:static,  'begin ']
      result[1].should == [:dynamic, 'some_\<\\>weird\>_tag']
      result[2].should == [:static,  ' end']
    end

    it "should complain if a tag misses an closing chevron" do
      sample_text = 'begin <some_tag\> end'
      error_message = "Missing closing chevron '>'."
      lambda { parse_it(sample_text) }.should raise_error(StandardError, error_message)
    end

  end # context

  context "Creation and initialization" do

    it "should accept an empty template text" do
      lambda { TemplateEngine.new '' }.should_not raise_error
    end

    it "should be created with a template text" do
      lambda { TemplateEngine.new sample_template }.should_not raise_error
    end

    it "should know the source text" do
      subject.source.should == sample_template

      # Case of an empty template
      instance = TemplateEngine.new ''
      instance.source.should be_empty
    end
  end
  
  context "Provided services" do
  
    it "should know the variable(s) it contains" do
      subject.variables == [:userid, :password]

      # Case of an empty source template text
      instance = TemplateEngine.new ''
      instance.variables.should be_empty
    end
    
    it "should render the text given the actuals" do
      locals = {'userid' => "johndoe"}
      
      rendered_text = subject.render(nil, locals)
      expected = <<-SNIPPET
  Given I landed in the homepage
  # The credentials are entered here
  And I fill in "Username" with "johndoe"
  And I fill in "Password" with ""
  And I click "Sign in"
SNIPPET

      # Place actual value in context object
      Context = Struct.new(:userid, :password)
      context = Context.new("sherlock", "holmes")
      rendered_text = subject.render(context, {'userid' => 'susan'})
      expected = <<-SNIPPET
  Given I landed in the homepage
  # The credentials are entered here
  And I fill in "Username" with "susan"
  And I fill in "Password" with "holmes"
  And I click "Sign in"
SNIPPET
      

      # Case of an empty source template text
      instance = TemplateEngine.new ''
      instance.render(nil, {}).should be_empty
    end
  end

end # describe

end # module

# End of file
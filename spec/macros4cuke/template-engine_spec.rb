# encoding: utf-8 -- You should see a paragraph character: §
# File: template-engine_spec.rb

require_relative '../spec_helper'
require_relative '../../lib/macros4cuke/template-engine'	# Load the class under test

module Macros4Cuke # Open this namespace to get rid of module qualifier prefixes

describe TemplateEngine do

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

end # describe

end # module

# End of file
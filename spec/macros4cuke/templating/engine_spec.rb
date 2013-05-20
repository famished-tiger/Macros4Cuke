# encoding: utf-8 -- You should see a paragraph character: §
# File: engine_spec.rb

require_relative '../../spec_helper'

# Load the class under test
require_relative '../../../lib/macros4cuke/templating/engine'


module Macros4Cuke

module Templating # Open this namespace to get rid of module qualifier prefixes


describe Engine do
  # Sample template (consisting of a sequence of steps)
  let(:sample_template) do
      source = <<-SNIPPET
  Given I landed in the homepage
  # The credentials are entered here
  And I fill in "Username" with "<userid>"
  And I fill in "Password" with "<password>"
  And I click "Sign in"
SNIPPET

      source
    end
    
  # Template containing two conditional sections
  let(:sophisticated_template) do
      source = <<-SNIPPET
  When I fill in "firstname" with "<firstname>"
  And I fill in "lastname" with "<lastname>"
<?address>  And I fill in "address" with "<address>"</address>
  <?birthdate>
  And I fill in "birthdate" with "<birthdate>"
  </birthdate>
<?dummy></dummy>
  And I click "Register"
SNIPPET

    source
    end    
  
  

  # Rule for default instantiation
  subject { Engine.new sample_template }


  context "Class services" do
    # Helper method.
    # Remove enclosing chevrons <..> (if any)
    def strip_chevrons(aText)
      return aText.gsub(/^<|>$/, '')
    end

    it "should parse an empty text line" do
      # Expectation: result should be an empty array.
      Engine.parse('').should be_empty
    end

    it "should parse a text line without tag" do
      sample_text = 'Mary has a little lamb'
      result = Engine.parse(sample_text)

      # Expectation: an array with one couple: 
      # [:static, the source text]
      result.should have(1).items
      result[0].should == [:static, sample_text]
    end

    it "should parse a text line that consists of just a tag" do
      sample_text = '<some_tag>'
      result = Engine.parse(sample_text)

      # Expectation: an array with one couple: 
      # [:static, the source text]
      result.should have(1).items
      result[0].should == [:dynamic, strip_chevrons(sample_text)]
    end

    it "should parse a text line with a tag at the start" do
      sample_text = '<some_tag>some text'
      result = Engine.parse(sample_text)

      # Expectation: an array with two couples: 
      # [dynamic, 'some_tag'][:static, some text]
      result.should have(2).items
      result[0].should == [:dynamic, 'some_tag']
      result[1].should == [:static,  'some text']
    end

    it "should parse a text line with a tag at the end" do
      sample_text = 'some text<some_tag>'
      result = Engine.parse(sample_text)

      # Expectation: an array with two couples: 
      # [:static, some text] [dynamic, 'some_tag']
      result.should have(2).items
      result[0].should == [:static,  'some text']
      result[1].should == [:dynamic, 'some_tag']
    end

    it "should parse a text line with a tag in the middle" do
      sample_text = 'begin <some_tag> end'
      result = Engine.parse(sample_text)

      # Expectation: an array with three couples:
      result.should have(3).items
      result[0].should == [:static,  'begin ']
      result[1].should == [:dynamic, 'some_tag']
      result[2].should == [:static,  ' end']
    end

    it "should parse a text line with two tags in the middle" do
      sample_text = 'begin <some_tag>middle<another_tag> end'
      result = Engine.parse(sample_text)

      # Expectation: an array with items couples:
      result.should have(5).items
      result[0].should == [:static ,  'begin ']
      result[1].should == [:dynamic, 'some_tag']
      result[2].should == [:static , 'middle']
      result[3].should == [:dynamic, 'another_tag']
      result[4].should == [:static,  ' end']

      # Case: two consecutive tags
      sample_text = 'begin <some_tag><another_tag> end'
      result = Engine.parse(sample_text)

      # Expectation: an array with four couples:
      result.should have(4).items
      result[0].should == [:static,  'begin ']
      result[1].should == [:dynamic, 'some_tag']
      result[2].should == [:dynamic, 'another_tag']
      result[3].should == [:static,  ' end']
    end

    it "should parse a text line with escaped chevrons" do
      sample_text = 'Mary has a \<little\> lamb'
      result = Engine.parse(sample_text)

      # Expectation: an array with one couple: [:static, the source text]
      result.should have(1).items
      result[0].should == [:static, sample_text]
    end

    it "should parse a text line with escaped chevrons in a tag" do
      sample_text = 'begin <some_\<\\>weird\>_tag> end'
      result = Engine.parse(sample_text)

      # Expectation: an array with three couples:
      result.should have(3).items
      result[0].should == [:static,  'begin ']
      result[1].should == [:dynamic, 'some_\<\\>weird\>_tag']
      result[2].should == [:static,  ' end']
    end

    it "should complain if a tag misses an closing chevron" do
      sample_text = 'begin <some_tag\> end'
      error_message = "Missing closing chevron '>'."
      ->(){ Engine.parse(sample_text) }.should raise_error(
        StandardError, error_message)
    end

    it  "should complain if a text misses an opening chevron" do
      sample_text = 'begin <some_tag> > end'
      error_message = "Missing opening chevron '<'."
      ->(){ Engine.parse(sample_text) }.should raise_error(
        StandardError, error_message)
    end

    it  "should complain if a text has nested opening chevrons" do
      sample_text = 'begin <<some_tag> > end'
      error_message = "Nested opening chevron '<'."
      ->(){ Engine.parse(sample_text) }.should raise_error(
        StandardError, error_message)
    end

  end # context

  context "Creation and initialization" do

    it "should accept an empty template text" do
      ->(){ Engine.new '' }.should_not raise_error
    end

    it "should be created with a template text" do
      ->(){ Engine.new sample_template }.should_not raise_error
    end

    it "should know the source text" do
      subject.source.should == sample_template

      # Case of an empty template
      instance = Engine.new ''
      instance.source.should be_empty
    end
    
    it "should accept conditional section" do
      ->(){ Engine.new sophisticated_template }.should_not raise_error
      instance = Engine.new sophisticated_template
      elements = instance.instance_variable_get(:@representation)
      sections = elements.select { |e| e.is_a?(Section) }
      names = sections.map { |e| e.to_s }
      names.should == %w(<?address> <?birthdate> <?dummy>)
    end

    it "should complain when a placeholder is empty or blank" do
      text_w_empty_arg = sample_template.sub(/userid/, '')
      msg = %q(An empty or blank argument occurred in 'And I fill in "Username" with "<>"'.)
      ->(){ Engine.new text_w_empty_arg }.should 
        raise_error(Macros4Cuke::EmptyArgumentError, msg)
    end

    it "should complain when a placeholder contains an invalid character" do
      text_w_empty_arg = sample_template.sub(/userid/, 'user%id')
      msg = "The invalid sign '%' occurs in the argument/tag 'user%id'."
      ->(){ Engine.new text_w_empty_arg }.should 
        raise_error(Macros4Cuke::InvalidCharError, msg)
    end
    
    it "should complain when a section has no closing tag" do
      # Removing an end of section tag...
      text_w_open_section = sophisticated_template.sub(/<\/address>/, '')

      error_message = "Unterminated section <?address>."
      ->(){ Engine.new text_w_open_section}.should 
        raise_error(StandardError, error_message)
    end
    
    it "should complain when a closing tag has no corresponding opening tag" do
      # Replacing an end of section tag by another...
      text_w_wrong_end = sophisticated_template.sub(/<\/address>/, '</foobar>')

      msg = "End of section</foobar> doesn't match current section 'address'."
      ->(){ Engine.new text_w_wrong_end }.should 
        raise_error(StandardError, msg)
    end
    
    it "should complain when a closing tag is found without opening tag" do
      # Replacing an end of section tag by another...
      wrong_end = sophisticated_template.sub(/<\?birthdate>/, '</foobar>')
      msg = "End of section</foobar> found while no corresponding section is open."
      ->(){ Engine.new wrong_end }.should 
        raise_error(StandardError, msg)
    end    
    
  end # context

  context "Provided services" do

    it "should know the variable(s) it contains" do
      # Case using the sample template
      subject.variables == [:userid, :password]

      # Case of an empty source template text
      instance = Engine.new ''
      instance.variables.should be_empty
    end


    it "should ignore variables/placeholders in comments" do
      substeps = "  # Comment 1 <miscellaneous>\n" + sample_template
      substeps += "  #\n Comment 2 <haphazard>"
      instance = Engine.new substeps
      instance.variables == [:userid, :password]
    end


    it "should render the text given the actuals" do
      locals = { 'userid' => "johndoe" }

      rendered_text = subject.render(Object.new, locals)
      expected = <<-SNIPPET
  Given I landed in the homepage
  # The credentials are entered here
  And I fill in "Username" with "johndoe"
  And I fill in "Password" with ""
  And I click "Sign in"
SNIPPET

      rendered_text.should == expected

      # Case of an actual that's not a String
      locals = { 'userid' => "johndoe", "password" => 12345 }
      rendered_text = subject.render(Object.new, locals)
      expected = <<-SNIPPET
  Given I landed in the homepage
  # The credentials are entered here
  And I fill in "Username" with "johndoe"
  And I fill in "Password" with "12345"
  And I click "Sign in"
SNIPPET

      rendered_text.should == expected


      # Place actual value in context object
      Context = Struct.new(:userid, :password)
      context = Context.new("sherlock", "holmes")
      rendered_text = subject.render(context, { 'userid' => 'susan' })
      expected = <<-SNIPPET
  Given I landed in the homepage
  # The credentials are entered here
  And I fill in "Username" with "susan"
  And I fill in "Password" with "holmes"
  And I click "Sign in"
SNIPPET

      rendered_text.should == expected


      # Case of an empty source template text
      instance = Engine.new ''
      instance.render(nil, {}).should be_empty
    end
    
    
    it "should render conditional sections" do
      instance = Engine.new(sophisticated_template)
      
      locals = { 'firstname' => "Anon", 
        "lastname" => "Eemoos" ,
        "birthdate" => "1976-04-21"
        }
      rendered_text = instance.render(Object.new, locals)
      expected = <<-SNIPPET
  When I fill in "firstname" with "Anon"
  And I fill in "lastname" with "Eemoos"
  And I fill in "birthdate" with "1976-04-21"
  And I click "Register"
SNIPPET

      rendered_text.should == expected
      
      # Redo with another context
      locals["birthdate"] = nil
      locals["address"] = "122, Mercer Street"
      
      rendered_text = instance.render(Object.new, locals)
      expected = <<-SNIPPET
  When I fill in "firstname" with "Anon"
  And I fill in "lastname" with "Eemoos"
  And I fill in "address" with "122, Mercer Street"
  And I click "Register"
SNIPPET

      rendered_text.should == expected      
    end
    

    it "should render multivalued actuals" do
      locals = { 'userid' => %w(johndoe yeti) } # Silly case

      rendered_text = subject.render(Object.new, locals)
      expected = <<-SNIPPET
  Given I landed in the homepage
  # The credentials are entered here
  And I fill in "Username" with "johndoe<br/>yeti"
  And I fill in "Password" with ""
  And I click "Sign in"
SNIPPET

      rendered_text.should == expected
    end
  end # context

end # describe

end # module

end # module

# End of file
# File: macro_steps.rb
# Purpose: step definitions that help to build macro-steps
# (i.e. a Cucumber step that is equivalent to a sequence of sub-steps)

require_relative './macros4cuke/macro-collection'
require_relative './macros4cuke/formatting-service'
require_relative './macros4cuke/formatter/to-gherkin'


# This step is used to define a macro-step
# Example:
#  Given I define the step "When I [log in as <userid>]" to mean:
#  """
#  Given I landed in the homepage
#  When I click "Sign in"
#  And I fill in "Username" with "<userid>"
#  And I fill in "Password" with "unguessable"
#  And I click "Submit"
#  """
# The regexp has two capturing group: one for the phrase,
# a second for the terminating colon (:)
# The regular expression uses the /x option in order to split it in pieces
Given(%r{^I\sdefine\sthe\sstep\s" # Fixed part of defining step
    (?:Given|When|Then|\*)\s  # ... A keyword that starts the new step
    I\s\[((?:[^\\\]]|\\.)+)\](:?) # ...I followed by text in square brackets
  "\sto\smean:$}x) do |macro_phrase, colon_capture, template|
  use_table = (colon_capture == ':')
  add_macro(macro_phrase, template, use_table)
end


# This step is used to invoke a simple macro-step
# Example:
#  When I [log in as "guest"]
#
When(/^I \[((?:[^\\\]]|\\.)+)\]$/) do |macro_phrase|
  invoke_macro(macro_phrase) # This will call the macro with the given phrase
end


# This step is used to invoke a macro-step with a data table argument.
# Notice the presence of an ending colon character ':'
# after the closing bracket ']'
# Example:
#  When I [enter my credentials as]:
#  |userid  |guest      |
#  |password|unguessable|
When(/^I \[([^\]]+)\]:$/) do |macro_phrase, table_argument|
  # Ensure that the second argument is of the correct type
  # unless table_argument.is_a?(Cucumber::Ast::Table)
  unless table_argument.is_a?(Cucumber::MultilineArgument::DataTable)
    raise(Macros4Cuke::DataTableNotFound.new(macro_phrase))
  end

  # This will call the macro with the given phrase.
  # The second argument consists of an array
  # with couples of the kind: [argument name, actual value]
  invoke_macro(macro_phrase, table_argument.raw)
end


# This step will list all the encountered macro-step definitions
# and will collect them in a single feature file.
# the file is saved in the current working directory
# when Cucumber is closing down.
When(/I want to list all the macros in the file "([^"]+)"$/) do |filepath|
  at_exit do
    output = File.open(filepath, 'w')
    formatter = Macros4Cuke::Formatter::ToGherkin.new(output)

    service = Macros4Cuke::FormattingService.new
    service.register(formatter)
    service.start!(Macros4Cuke::MacroCollection.instance)
  end
end


# End of file

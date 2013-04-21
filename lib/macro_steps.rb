# File: macro_steps.rb
# Purpose: step definitions that help to build macro-steps (i.e. a step that is equivalent to a sequence of steps)



=begin This step is used to define a macro-step
Example:
  Given I define the step <When I [create the following {{contactType}} contact]:> to mean:
  """
  # In the next step we use triple curly brace in order to get un-escaped text
  When I select "<type>" from "type"
	When I fill in "name" with "{{{name}}}"
	And I fill in "companyName" with "{{companyName}}"
	And I fill in "companyName2" with "{{companyName2}}"
  """
=end
Given(/^I define the step <When I \[([^\]]+\]:?)> to mean:$/) do |macro_phrase, template|
  add_macro(macro_phrase, template)
end

=begin This step is used to invoke a simple macro-step
# Example:
  # Here we define a simple macro-step
  Given I define the step <When I [fly from {{origin}} to {{destination}} via {{waypoint}}]> to mean:
  """ 
    When I display the text "Departure: {{origin}}."
    When I display the text "Stop at: {{waypoint}}."
    When I display the text "Destination {{destination}}."
  """
=end
When(/^I \[([^\]]+\])$/) do |macro_phrase|
  macro = find_macro(macro_phrase) 
  raise StandardError, "Undefined macro step for '[#{macro_phrase}'." if macro.nil?
  
  # Retrieve macro argument names and their associated value from the table
  params = macro.validate_params(macro_phrase, nil)

  # Render the steps
  rendered_steps = macro.expand(params)
  
  # Execute the steps
  steps(rendered_steps)
end


# This step is used to invoke a macro-step with a table argument.
# Example:
#  When I [create the following "Registrant" contact]:
#  |name|John Doe|
#  |city|Gotham City|
#  |street| Main street|
#  |street3| Small street|
When(/^I \[([^\]]+\]:)$/) do |macro_phrase, table_argument|
  macro = find_macro(macro_phrase) 
  raise StandardError, "Undefined macro step for '#{macro_phrase}'." if macro.nil?
  
  unless table_argument.kind_of?(Cucumber::Ast::Table)
     raise StandardError, "This step must have a table as an argument."
  end
  
  # Retrieve macro argument names and their associated value from the table
  params = macro.validate_params(macro_phrase, table_argument.rows_hash())

  # Render the steps
  rendered_steps = macro.expand(params)
  
  # Execute the steps
  steps(rendered_steps)
end


# End of file
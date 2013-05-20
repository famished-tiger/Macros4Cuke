# encoding: utf-8
# File: demo_steps.rb
# A few step definitions for demo and testing purpose.

When(/^I landed in the homepage$/) do
  trace_steps << 'Invoked step: ... I landed in the homepage'
end

When(/^I click "([^"]*)"$/) do |element|
  trace_steps << "Invoked step: ... I click \"#{element}\""
end


When(/^I fill in "(.*?)" with "(.*?)"$/) do |element, text|
  trace_steps << "Invoked step: ... I fill in \"#{element}\" with \"#{text}\""
end


Then(/^I expect the following step trace:$/) do |step_text|
  trace_steps.should == step_text.split(/\r?\n|\n/)
end


# This step is used for testing a particular exception
When(/^I generate a DataTableNotFound exception$/) do
  wrong = <<-SNIPPET
  When I [fill in the form with]:
  """
    Should be a table instead of triple quote string
  """
SNIPPET
  begin
    steps(wrong)
  rescue Macros4Cuke::DataTableNotFound => exc
    msg = "The step with phrase [fill in the form with]: requires a data table."
    exc.message.should == msg
  end
end


# End of file
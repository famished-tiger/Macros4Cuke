# File: demo_steps.rb
# A few step definitions for demo and testing purpose.

When(/^I landed in the homepage$/) do
  # trace_steps << 'Invoked step: ... I landed in the homepage'
end

When(/^I click "([^"]*)"$/) do |element|
  msg = 'Invoked step: ... I click '
  msg << "\"#{element}\""
  # trace_steps << msg
end


When(/^I fill in "(.*?)" with "(.*?)"$/) do |element, text|
  msg = "Invoked step: ... I fill in \"#{element}\" with "
  msg << "\"#{text}\""
  # trace_steps << msg
end


Then(/^I expect the following step trace:$/) do |step_text|
  # trace_steps.should == step_text.split(/\r?\n|\n/)
  expect(substeps_trace.chomp).to eq(step_text)
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
    phrase = '[fill in the form with]:'
    msg = "The step with phrase #{phrase} requires a data table."
    expect(exc.message).to eq(msg)
  end
end


# End of file

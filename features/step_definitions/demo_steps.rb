# File: demo_steps.rb
# A few step definitions for demo and testing purpose.

When(/^I landed in the homepage$/) do
  trace_steps << %Q|Invoked step: ... I landed in the homepage|
end

When(/^I click "([^"]*)"$/) do |element|
  trace_steps << %Q|Invoked step: ... I click "#{element}"|
end


When(/^I fill in "(.*?)" with "(.*?)"$/) do |element, text|
  trace_steps << %Q|Invoked step: ... I fill in "#{element}" with "#{text}"|
end


Then(/^I expect the following step trace:$/) do |step_text|
  trace_steps.should == step_text.split(/\r?\n|\n/)
end


# End of file
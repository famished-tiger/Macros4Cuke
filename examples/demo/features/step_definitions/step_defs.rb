# File: demo_steps.rb
# A few step definitions for demo and testing purpose.

When(/^I leave '(.*)'$/) do |city|
  show "I leave #{city}"
end


When(/^I visit (\S+)$/) do |city|
 show "I visit #{city}"
end


# This step uses a multiline text argument
When(/^I visit the cities:$/) do |cities_raw|
 cities = cities_raw.split(/\r\n?|\n/)
 cities.each { |city| show "I visit #{city}" }
end


When(/^I arrive in (.+)$/) do |city|
  show "I arrive in #{city}"
end


When(/^I type \"([^"]*)\"$/) do |text|
  show text
end

# End of file

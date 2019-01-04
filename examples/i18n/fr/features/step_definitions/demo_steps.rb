# Quelques définitions de pas de scénarios Cucumber.

require 'stringio'

Quand(/^j'imprime "(.*?)" à l'écran$/) do |some_text|
  $stderr.puts some_text
end

Quand(/^je garde "(.*?)" en mémoire$/) do |some_text|
  @output ||= StringIO.new('')
  @output.puts some_text
end

Alors(/^je m'attends à voir:$/) do |result|
  @output.string.should == result
end

# End of file

# Een paar stappen definities.

require 'stringio'

Als(/^ik "(.*?)" op het scherm afdruk$/) do |some_text|
  $stderr.puts some_text
end


Als(/^ik bewaar "(.*?)" in geheugen$/) do |some_text|
  @output ||= StringIO.new('')
  @output.puts some_text
end

Dan(/^verwacht ik te zien:$/) do |result|
  @output.string.should == result
end

# End of file

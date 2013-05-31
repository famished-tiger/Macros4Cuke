# encoding: utf-8
# File: spec_helper.rb
# Purpose: utility file that is loaded by all our RSpec files

require 'simplecov'


require 'rspec'	# Use the RSpec framework
require 'pp'	# Use pretty-print for debugging purposes

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # Disable the `should` syntax...
    c.syntax = :expect
  end
end


# End of file
# encoding: utf-8
require 'rubygems'
require_relative './lib/macros4cuke/constants'

namespace :gem do

desc 'Push the gem to rubygems.org'
task :push do
  system("gem push macros4cuke-#{Macros4Cuke::Version}.gem")
end

end

# Testing-specific tasks

# Cucumber as testing tool
require 'cucumber/rake/task'
Cucumber::Rake::Task.new do |t|
end

# RSpec as testing tool
require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

# Combine RSpec and Cucumber tests
desc "Run tests, with RSpec and Cucumber"
task :test => [:spec, :cucumber]

# Default rake task
task :default => :test

# End of file
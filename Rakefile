require 'rubygems'
require_relative './lib/macros4cuke/constants'

namespace :gem do

desc 'Push the gem to rubygems.org'
task :push do
  system("gem push macros4cuke-#{Macros4Cuke::Version}.gem")
end

end # namespace

# Testing-specific tasks

# Cucumber as testing tool
require 'cucumber/rake/task'
# UGLY workaround for bug in Cucumber's rake task
if Gem::VERSION[0].to_i >= 2 && Cucumber::VERSION <= '1.3.2'
  # Monkey-patch a buggy method
  class Cucumber::Rake::Task::ForkedCucumberRunner
    def gem_available?(gemname)
      if Gem::VERSION[0].to_i >= 2 
        gem_available_new_rubygems?(gemname)
      else
        gem_available_old_rubygems?(gemname)
      end
    end  
  end # class
end

Cucumber::Rake::Task.new do |t|
end

# RSpec as testing tool
require 'rspec/core/rake_task'
desc 'Run RSpec'
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

# Combine RSpec and Cucumber tests
desc 'Run tests, with RSpec and Cucumber'
task :test => [:spec, :cucumber]

# Default rake task
task :default => :test

# End of file
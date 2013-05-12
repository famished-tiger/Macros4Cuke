# encoding: utf-8
require 'rubygems'


require 'cucumber/rake/task'  # 
Cucumber::Rake::Task.new do |t|
end

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

desc "Run tests, with RSpec and Cucumber"
task :test => [:spec, :cucumber]

task :default => :test
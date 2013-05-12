# encoding: utf-8 
# File: macros4cuke.gemspec
# Gem specification file for the Macros4Cuke project.

require 'rubygems'

# The next line generates an error with Bundler
require_relative './lib/macros4cuke/constants'


MACROS4CUKE_GEMSPEC = Gem::Specification.new do |pkg|
	pkg.name = "macros4cuke"
	pkg.version = Macros4Cuke::Version
	pkg.author = "Dimitri Geshef"
	pkg.homepage = "https://github.com/famished-tiger/Macros4Cuke"
	pkg.platform = Gem::Platform::RUBY
	pkg.summary = Macros4Cuke::Description
	pkg.description = "Create your own macros in your Cucumber scenarios."
	pkg.post_install_message =<<EOSTRING
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Thank you for installing Macros4Cuke...
Enjoy using Cucumber with macros...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOSTRING
    
	file_list = Dir['.simplecov', '.travis.yml', '.yardopts', 'cucumber.yml', 'Gemfile', 'Rakefile',  'CHANGELOG.md', 'LICENSE.txt', 'README.md', 
    'lib/*.*', 'lib/**/*.rb', 'examples/**/*.*', 'features/*.*', 'features/**/*.rb', 'spec/**/*.rb'
  ]
	pkg.files = file_list
	pkg.require_path = "lib"
	
	pkg.has_rdoc = false
  pkg.add_runtime_dependency('cucumber',[">= 0"])
  pkg.add_development_dependency('rake',[">= 0.9.2"])
  pkg.add_development_dependency('rspec',[">= 2.00"])
  pkg.add_development_dependency('simplecov',[">= 0.5.0"])
	
	pkg.bindir = 'bin'
	pkg.executables = []
  pkg.license = 'MIT'
  pkg.required_ruby_version = '>= 1.9.1'
end

if $0 == __FILE__
	Gem::Builder.new(MACROS4CUKE_GEMSPEC).build
end

# End of file
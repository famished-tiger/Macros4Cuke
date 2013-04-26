# encoding: utf-8 
# File: macros4cuke.gemspec
# Gem specification file for the Macros4Cuke project.


require 'rubygems'
require 'rake'	# We'll use the FileList class


require_relative './lib/macros4cuke/constants'

MACROS4CUKE_GEMSPEC = Gem::Specification.new do |pkg|
	pkg.name = "macros4cuke"
	pkg.version = Macros4Cuke::Version
	pkg.author = "Dimitri Geshef"
	pkg.email = "famished.tiger@yahoo.com"
	pkg.homepage = "https://github.com/famished-tiger/Macros4Cuke"
	pkg.platform = Gem::Platform::RUBY
	pkg.summary = Macros4Cuke::Description
	pkg.description = <<EOSTRING
	Macros4Cuke is a lightweight library that adds a macro facility your Cucumber scenarios.
  In short, you can create any new step that replaces a sequence of lower-level steps.
  All this can be done directly in your feature files without programming step definitions.
EOSTRING

	pkg.post_install_message =<<EOSTRING
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Thank you for installing Macros4Cuke...
Enjoy using Cucumber with macros...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOSTRING
	
	file_list = Rake::FileList['cucumber.yml', 'HISTORY.md', 'LICENSE.txt', 'README.md', 
    'lib/*.*', 'lib/*/*.rb', 'features/*.*', 'features/*/*.rb', 'spec/*.*', 'spec/*/*_spec.rb']
	pkg.files = file_list
	pkg.require_path = "lib"
	
	pkg.has_rdoc = false
	pkg.add_runtime_dependency('rake',[">= 0"])
  pkg.add_runtime_dependency('cucumber',[">= 0"])
  pkg.add_development_dependency('rspec',[">= 2.00"])
	
	pkg.bindir = 'bin'
	pkg.executables = []
end

if $0 == __FILE__
	Gem::Builder.new(MACROS4CUKE_GEMSPEC).build
end

# End of file
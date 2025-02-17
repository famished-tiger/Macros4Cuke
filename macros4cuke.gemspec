# File: macros4cuke.gemspec
# Gem specification file for the Macros4Cuke project.

require 'rubygems'

# The next line generates an error with Bundler
require_relative './lib/macros4cuke/constants'


MACROS4CUKE_GEMSPEC = Gem::Specification.new do |pkg|
  pkg.name = 'macros4cuke'
  pkg.version = Macros4Cuke::Version
  pkg.author = 'Dimitri Geshef'
  pkg.email = 'famished.tiger@yahoo.com'
  pkg.homepage = 'https://github.com/famished-tiger/Macros4Cuke'
  pkg.platform = Gem::Platform::RUBY
  pkg.summary = Macros4Cuke::Description
  pkg.description = 'Expand Cucumber with macro-steps.'
  pkg.post_install_message = <<EOSTRING
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Thank you for installing Macros4Cuke...
Enjoy using Cucumber with macros...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOSTRING
  pkg.rdoc_options << '--charset=UTF-8 --exclude="examples|features|spec"'
  file_list = Dir[
    '.rubocop.yml', '.rspec', '.ruby-gemset', '.ruby-version',
    '.yardopts', 'appveyor.yml', 'cucumber.yml', 'Gemfile',
    'Rakefile',
    'CHANGELOG.md',
    'LICENSE.txt', 'README.md',
    'bin/*.*',
    'examples/**/*.*',
    'lib/*.*', 'lib/**/*.rb',
    'features/**/*.feature', 'features/**/*.md', 'features/**/*.rb',
    'features/**/*.nav',
    'spec/**/*.rb',
    'templates/*.erb'
  ]
  pkg.files = file_list
  pkg.test_files = Dir['spec/**/*_spec.rb']

  pkg.require_path = 'lib'

  pkg.extra_rdoc_files = ['README.md']
  pkg.add_runtime_dependency('cucumber', ['~> 9.0'])

  pkg.add_development_dependency 'rake', '~> 13.1.0'
  pkg.add_development_dependency 'rspec', '~> 3.12'
  pkg.add_development_dependency 'yard', '~> 0.9.34'

  pkg.bindir = 'bin'
  pkg.executables = %w[macros4cuke]
  pkg.license = 'MIT'
  pkg.required_ruby_version = '>= 3.2.0'
end

if $PROGRAM_NAME == __FILE__
  require 'rubygems/package'
  Gem::Package.build(MACROS4CUKE_GEMSPEC)
end

# End of file

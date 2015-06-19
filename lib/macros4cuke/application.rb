# File: application.rb

require 'erb'

require_relative 'cli/cmd-line'

module Macros4Cuke # Module used as a namespace
# Runner for the Macros4Cuke application.
class Application
  attr_reader(:options)

  public

  def initialize()
    @options = {}
  end

  # Entry point for the application object.
  def run!(theCmdLineArgs)
    @options = options_from(theCmdLineArgs)
    return unless options[:setup]
    
    options[:setup].each do |a_path|
      setup_project(a_path)
    end
  end

  protected

  # Retrieve the user-entered command-line options
  def options_from(theCmdLineArgs)
    cli = CLI::CmdLine.new
    cli.parse!(theCmdLineArgs.dup)
  end

  # Make the Cucumber project at the designated path
  # ready for macros.
  # In practice, this is obtained by adding a file
  # in the /features/support dir.
  def setup_project(aPath)
    file_name = 'use_macros4cuke'
    prefix = aPath.relative? ? './' : ''
    destination = prefix + aPath.to_s + '/' + file_name + '.rb'

    begin
      fail SupportFileExists.new(destination) if File.exist?(destination)

      template_pathname =
        Macros4Cuke::RootDir + 'templates/use_macros4cuke.erb'
      template = File.read(template_pathname)


      # Create a context for variables used in our templates
      prog_version = Macros4Cuke::Version

      # Create one template engine instance
      engine = ERB.new(template)

      # Generate the text representation with given context
      file_text = engine.result(binding)

      # Write file contents to file in binary mode in order to avoid eol
      # consisting of CRLF
      File.open(destination, 'wb') { |theFile| theFile.write(file_text) }

    rescue Macros4Cuke::CmdLineError => exc
      $stderr.puts exc.message
      exit
    end
  end
end # class
end # module

# End of file

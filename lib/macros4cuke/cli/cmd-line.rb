# File: cli.rb

# Access the OptionParser library from the standard Ruby library
require 'optparse'
require 'pathname'
require 'pp'  # TODO: remove this line

require 'cucumber/platform'
require_relative '../constants'

module Macros4Cuke # Module used as a namespace

# Module dedicated to the command-line interface
module CLI


# Manages the application command-line interface (CLI).
# It is merely a thin wrapper around the OptionParser library.
# Responsibilities:
#- Specify the command-line syntax,
#- Return the result of the command-line parsing
# Examples of command lines:
# --setup PROJ_PATH
# --suggest
class CmdLine
  ShortHelpMsg = <<-END_MSG
For help about the command-line syntax, do:
macros4cuke --help
END_MSG

  # A Hash with the result of the command-line parse.
  attr_reader(:options)

  # OptionParser object
  attr_reader(:parser)

  # Constructor.
  def initialize()
    @options = {}

    @parser = OptionParser.new do |opts|
      opts.banner = <<-EOS
Usage: macros4cuke [options]
The command-line options are:
EOS
      # Mandatory argument
      msg_p1 = 'Make the Cucumber project at given path '
      msg_p2 = 'ready for macro-steps.'
      opts.on('--setup PROJECT_PATH', msg_p1 + msg_p2) do |project_path|
        valid_path = validated_feature_path(project_path)
        options[:setup] ||= []
        options[:setup] << valid_path 
      end

      # No argument, shows at tail.  This will print an options summary.
      opts.on_tail('-h', '--help', 'Show this message') do
        # puts opts
        options[:help] = true
      end

      opts.on_tail('-v', '--version', 'Display version number.') do
        puts Macros4Cuke::Version
        options[:version] = true
      end
      
      version_verbose_msg = 'Display gem and platform version numbers.'
      opts.on_tail('-V', '--version-verbose', version_verbose_msg) do
        cuke = "Cucumber #{Cucumber::VERSION}" 
        ruby = "Ruby #{RUBY_VERSION} #{RUBY_PLATFORM}"
        msg = "#{Macros4Cuke::Version} (using #{cuke}, running on #{ruby})"
        puts msg
        options[:version] = true
      end 

    end
  end

  public

  # Perform the command-line parsing
  def parse!(theCmdLineArgs)
    begin
      parser.parse!(theCmdLineArgs.dup) 
    rescue Macros4Cuke::CmdLineError => exc
      $stderr.puts exc.message
      exit
      
    rescue OptionParser::InvalidOption => exc
      $stderr.puts exc.message
      exit

    rescue OptionParser::MissingArgument => exc
      err_msg = ''
      exc.args.each do |arg|
        err_msg << "No argument provided with command line option: #{arg}\n"
      end
      $stderr.puts err_msg
      exit
    end
    
    # When no option provided then display minimalistic help info
    short_help if options.empty?
    
    show_help if options[:help]

    # Some options stop the application
    exit if options[:version] || options[:help]
    
    return options
  end

  private
  
  # Given the project path, retrieve its /features dir.
  def validated_feature_path(theProjectPath)
    dirs = [theProjectPath, 'features', 'support']
    feature_path = dirs.reduce(Pathname.getwd) do |path, dir_name|
      path = path + dir_name
      unless path.exist?
        fail DirectoryNotFound.new(path.relative_path_from(Pathname.getwd))
      end
      path
    end

    return feature_path
  end
  
  def show_help()
    puts parser.help
  end
  
  def short_help()
    puts ShortHelpMsg
    exit
  end

end # class

end # module

end # module

# End of file

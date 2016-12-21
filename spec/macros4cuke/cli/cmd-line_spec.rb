# File: cmd-line_spec.rb

require 'stringio'
require_relative '../../spec_helper'

require_relative '../../../lib/macros4cuke/exceptions'

# Load the class under test
require_relative '../../../lib/macros4cuke/cli/cmd-line'

module Macros4Cuke
module CLI
describe CmdLine do
  before(:each) do
    @current_wkdir = Dir.getwd
    Dir.chdir(File.dirname(__FILE__))
  end

  after(:each) do
    Dir.chdir(@current_wkdir)
  end

  def hijack_stdout()
    @orig_stdout = $stdout
    $stdout = StringIO.new('', 'w')
  end

  def restore_stdout()
    $stdout = @orig_stdout
  end

  def hijack_stderr()
    @orig_stderr = $stderr
    $stderr = StringIO.new('', 'w')
  end

  def restore_stderr()
    $stderr = @orig_stderr
  end

  def mk_subdir(relativePath)
    subdir = File.dirname(__FILE__) + '/' + relativePath
    Dir.mkdir(subdir)
  end

  context 'Creation and initialization:' do
    it 'should be created without argument' do
      expect { CmdLine.new }.not_to raise_error
    end

    it 'should have an command-line parser' do
      expect(subject.parser).to be_kind_of(OptionParser)
    end
  end # context


  context 'Informative options:' do
    it 'should provide short help when command-line is empty' do
      hijack_stdout
      short_help = <<-END_MESSAGE
For help about the command-line syntax, do:
macros4cuke --help
END_MESSAGE

      # Application is stopped
      expect { subject.parse!([]) }.to raise_error(SystemExit)

      # Help text is displayed
      expect($stdout.string).to eq(short_help)
      restore_stdout
    end

    it 'should provide complete help when help requested' do
      help_options = [ ['-h'], ['--help'] ]
      help_text = subject.parser.help

      help_options.each do |cmd_line|
        hijack_stdout
        # Application is stopped
        expect { subject.parse!(cmd_line) }.to raise_error(SystemExit)

        # Help text is displayed
        expect($stdout.string).to eq(help_text)
        restore_stdout
      end
    end

    it 'should provide version when it is requested' do
      version_options = [ ['-v'], ['--version'] ]

      version_options.each do |cmd_line|
        hijack_stdout
        # Application is stopped
        expect { subject.parse!(cmd_line) }.to raise_error(SystemExit)

        # platform versions are displayed

        expect($stdout.string).to eq(Macros4Cuke::Version + "\n")
        restore_stdout
      end
    end

    it 'should provide platform data when requested' do
      verbose_version_options = [ ['-V'], ['--version-verbose'] ]

      cuke = "Cucumber #{Cucumber::VERSION}"
      ruby = "Ruby #{RUBY_VERSION} #{RUBY_PLATFORM}"
      full_msg = "#{Macros4Cuke::Version} (using #{cuke}, running on #{ruby})"

      verbose_version_options.each do |cmd_line|
        hijack_stdout
        # Application is stopped
        expect { subject.parse!(cmd_line) }.to raise_error(SystemExit)

        # Version number is displayed
        expect($stdout.string).to eq(full_msg + "\n")
        restore_stdout
      end
    end
  end # context

  context 'Error in command-line:' do
    it 'should complain when detecting an unknown option' do
      hijack_stderr
      err_msg = "invalid option: --unknown\n"

      # Application is stopped
      expect { subject.parse!(['--unknown']) }.to raise_error(SystemExit)

      # Error message text is displayed
      expect($stderr.string).to eq(err_msg)
      restore_stderr
    end

    it 'should complain when an option misses an argument' do
      hijack_stderr
      err_msg = <<-END_MESSAGE
No argument provided with command line option: --setup
END_MESSAGE

      # Application is stopped
      expect { subject.parse!(['--setup']) }.to raise_error(SystemExit)

      # Error message text is displayed
      expect($stderr.string).to eq(err_msg)
      restore_stderr
    end

    it "should complain when project to setup doesn't exist" do
      hijack_stderr
      err_msg = <<-END_MESSAGE
Error in command-line:
Cannot find the directory 'not_a_dir'.
END_MESSAGE

      # Application is stopped
      args = %w(--setup not_a_dir)
      expect { subject.parse!(args) }.to raise_error(SystemExit)

      # Error message text is displayed
      expect($stderr.string).to eq(err_msg)
      restore_stderr
    end

    it "should complain when features dir does'nt exist" do
      mk_subdir('test_dir')

      hijack_stderr
      err_msg = <<-END_MESSAGE
Error in command-line:
Cannot find the directory 'test_dir/features'.
END_MESSAGE
      args = %w(--setup ./test_dir)

      # Application is stopped
      expect { subject.parse!(args) }.to raise_error(SystemExit)

      # Error message text is displayed
      expect($stderr.string).to eq(err_msg)
      restore_stderr

      mk_subdir('test_dir/features')
      hijack_stderr
      err_msg = <<-END_MESSAGE
Error in command-line:
Cannot find the directory 'test_dir/features/support'.
END_MESSAGE

      # Application is stopped
      expect { subject.parse!(args) }.to raise_error(SystemExit)

      # Error message text is displayed
      expect($stderr.string).to eq(err_msg)
      restore_stderr
    end

    it 'should not complain when all dirs are present' do
      mk_subdir('test_dir/features/support')

      expected = { setup: [Pathname.getwd + 'test_dir/features/support'] }
      expect(subject.parse!(%w(--setup ./test_dir))).to eq(expected)

      file_path = expected[:setup].first
      Dir.rmdir(file_path)
      Dir.rmdir(file_path.parent)
      Dir.rmdir(file_path.parent.parent)
    end
  end # context
end # describe
end # module
end # module

# End of file

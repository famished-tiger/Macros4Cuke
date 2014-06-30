# File: macro-collection_spec.rb

require_relative '../spec_helper'

require_relative '../../lib/macros4cuke/exceptions'

# Load the class under test
require_relative '../../lib/macros4cuke/application'

module Macros4Cuke # Open this namespace to avoid module qualifier prefixes

describe Application do

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


  context 'Creation & initialization:' do
    it 'should be created without argument' do
      expect { Application.new }.not_to raise_error
    end
    
    it 'should not have any option at creation' do
      expect(subject.options).to be_empty
    end
  end # context

  context 'Provided services:' do
    def make_dirs()
      mk_subdir('test_dir')
      mk_subdir('test_dir/features')
      mk_subdir('test_dir/features/support')
    end
    
    def delete_dirs(aFilepath)
      a_path = Pathname.new(aFilepath)
      Dir.rmdir(a_path)
      Dir.rmdir(a_path.parent)
      Dir.rmdir(a_path.parent.parent)
    end
  
    it 'should create a support file when requested' do
      make_dirs
      
      file_path = './test_dir/features/support'
      file_name = 'use_macros4cuke.rb'
      
      subject.run!(%w(--setup ./test_dir))
      expect(File.exist?(file_path + '/' + file_name)).to be_true
      
      File.delete(file_path + '/' + file_name)
      delete_dirs(file_path)
    end
    
    it 'should complain when the support file already exists' do
      make_dirs
      
      file_path = '/test_dir/features/support'
      file_name = 'use_macros4cuke.rb'
      args = %w(--setup ./test_dir)
      mydir = File.dirname(__FILE__)
      
      expect { subject.run!(args) }.not_to raise_error
      
      hijack_stderr
      err_msg = <<-MSG_END
Error in command-line:
The file '#{mydir}/test_dir/features/support/use_macros4cuke.rb' already exists.
MSG_END

      expect { subject.run!(args) }.to raise_error(SystemExit)
      
      # Error message text is displayed
      expect($stderr.string).to eq(err_msg)
      restore_stderr
      
      File.delete(".#{file_path}/#{file_name}")
      delete_dirs('.' + file_path)
    end    
  
  end # context

end # describe

end # module


# End of file

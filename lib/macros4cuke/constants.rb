# File: constants.rb
# Purpose: definition of Macros4Cuke constants.

module Macros4Cuke # Module used as a namespace
  # The version number of the gem.
  Version = '0.5.05'

  # Brief description of the gem.
  Description = 'Add your own macro-steps to Cucumber scenarios'

  # Constant Macros4Cuke::RootDir contains the absolute path of Macro4Cuke's
  # root directory. Note: it also ends with a slash character.
  unless defined?(RootDir)
    # The initialisation of constant RootDir is guarded in order
    # to avoid multiple initialisation (not allowed for constants)

    # The root folder of Macros4Cuke.
    RootDir = begin
      require 'pathname' # Load Pathname class from standard library
      rootdir = Pathname(__FILE__).dirname.parent.parent.expand_path
      rootdir.to_s + '/' # Append trailing slash character to it
    end
  end
end # module

# End of file

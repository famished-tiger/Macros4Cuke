# File: constants.rb
# Purpose: definition of Macros4Cuke constants.

module Macros4Cuke # Module used as a namespace
	# This constant keeps the current version of the gem.
	Version = '0.1.01'
  
  Description = "Macros for Cucumber"
	
	# Constant Macros4Cuke::RootDir contains the absolute path of Rodent's root directory. Note: it also ends with a slash character.
	unless defined?(RootDir)
    # The initialisation of constant RootDir is guarded in order to avoid multiple initialisation (not allowed for constants)  
		RootDir = begin
      require 'pathname'	# Load Pathname class from standard library
      rootdir = Pathname(__FILE__).dirname.parent.parent.expand_path()
      rootdir.to_s() + '/'	# Append trailing slash character to it     
    end
	end
end # module

# End of file
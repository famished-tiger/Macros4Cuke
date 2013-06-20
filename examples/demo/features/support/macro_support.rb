# File: macro_support.rb
# Purpose: Add the support for macros in Cucumber.
# This file is meant to be put next to the 'env.rb' file
# of your Cucumeber project.


# Macros4Cuke step one: Load modules and classes from the gem.
require 'macros4cuke'


# Macros4Cuke step two: extend the world object with the mix-in module
# that adds the support for macros in Cucumber.
World(Macros4Cuke::MacroStepSupport)


# End of file
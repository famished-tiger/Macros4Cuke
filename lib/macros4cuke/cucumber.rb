# frozen_string_literal: true

# File: cucumber.rb
# Purpose: Load Macros4Cuke modules and classes, register its step definitions

# Load modules and classes from the gem.
require_relative 'constants'
require_relative 'macro-step-support'


# Extend the world object with the mix-in module
# that adds the support for macros in Cucumber.
World(Macros4Cuke::MacroStepSupport)

# Register the step definitions from Macros4Cuke
require_relative '../macro_steps'

# End of file

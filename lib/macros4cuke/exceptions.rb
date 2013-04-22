# encoding: utf-8 -- You should see a paragraph character: § 
# File: exceptions.rb

module Macros4Cuke # Module used as a namespace

# Base class for any exception explicitly raised in the Macros4Cuke methods.
class Macros4CukeError < StandardError
end # class

# Raised when one attempts to define a new macro 
# that has the same phrase as an existing macro.
class DuplicateMacroError < Macros4CukeError
  def initialize(aPhrase)
    super("A macro-step with phrase '[#{aPhrase}' already exist.")
  end
end # class



# Raised when one invokes a macro-step with an unknown phrase. 
class UnknownMacroError < Macros4CukeError
  def initialize(aPhrase)
    super("Unknown macro-step with phrase: '[#{aPhrase}'.")
  end
end # class



# Raised when one invokes a macro-step with an argument
# that has an unknown name. 
class UnknownArgumentError < Macros4CukeError
  def initialize(argName)
    super("Unknown macro argument #{argName}.")
  end
end # class


# Raised when Macros4Cuke encountered an issue
# that it can't handle properly.
class InternalError < Macros4CukeError
end # class


end # module

# End of file
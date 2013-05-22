# encoding: utf-8 -- You should see a paragraph character: §
# File: exceptions.rb

module Macros4Cuke # Module used as a namespace

# @abstract
# Base class for any exception explicitly raised in the Macros4Cuke methods.
class Macros4CukeError < StandardError
end # class

# Raised when one attempts to define a new macro
# that has the same phrase as an existing macro.
class DuplicateMacroError < Macros4CukeError
  def initialize(aPhrase)
    super("A macro-step with phrase '#{aPhrase}' already exist.")
  end
end # class

# Raised when one defines an argument name in a macro-step's phrase
# and that argument name does not appear in any sub-step.
class UselessPhraseArgument < Macros4CukeError
  def initialize(anArgName)
    super("The phrase argument '#{anArgName}' does not appear in a sub-step.")
  end
end # class



# Raised when one defines an argument name in a macro-step's phrase
# and that argument name does not appear in any sub-step.
class UnreachableSubstepArgument < Macros4CukeError
  def initialize(anArgName)
    msg = "The sub-step argument '#{anArgName}' does not appear in the phrase."
    super(msg)
  end
end # class



# Raised when a sub-step has an empty or blank argument name.
class EmptyArgumentError < Macros4CukeError
  def initialize(aText)
    super("An empty or blank argument occurred in '#{aText}'.")
  end
end # class


# Raised when an argument name contains invalid characters.
class InvalidCharError < Macros4CukeError
  def initialize(aTag, aWrongChar)
    msg = "The invalid sign '#{aWrongChar}' occurs in the argument '#{aTag}'."
    super(msg)
  end
end # class


# Raised when one invokes a macro-step with an unknown phrase.
class UnknownMacroError < Macros4CukeError
  def initialize(aPhrase)
    super("Unknown macro-step with phrase: '#{aPhrase}'.")
  end
end # class



# Raised when one invokes a macro-step with an argument
# that has an unknown name.
class UnknownArgumentError < Macros4CukeError
  def initialize(argName)
    super("Unknown macro-step argument '#{argName}'.")
  end
end # class



# Raised when one invokes a macro-step without a required data table argument
class DataTableNotFound < Macros4CukeError
  def initialize(phrase)
    msg = "The step with phrase [#{phrase}]: requires a data table."
    super(msg)
  end
end # class


# Raised when Macros4Cuke encountered an issue
# that it can't handle properly.
class InternalError < Macros4CukeError
end # class


end # module

# End of file
# File: exceptions.rb

module Macros4Cuke # Module used as a namespace
# @abstract
# Base class for any exception explicitly raised in the Macros4Cuke methods.
class Macros4CukeError < StandardError
end # class

# @abstract
# Specialized command-line errors.
class CmdLineError < Macros4CukeError
  def initialize(aMessage)
    msg = "Error in command-line:\n"
    super(msg + aMessage)
  end  
end # class

class DirectoryNotFound < CmdLineError
  def initialize(aDirPath)
    msg = "Cannot find the directory '#{aDirPath}'."
    super(msg)
  end
end # class


class SupportFileExists < CmdLineError
  def initialize(aDirPath)
    msg = "The file '#{aDirPath}' already exists."
    super(msg)
  end
end # class

# Raised when one attempts to define a new macro
# that has the same phrase as an existing macro.
class DuplicateMacroError < Macros4CukeError
  def initialize(aPhrase)
    super("A macro-step with phrase '#{aPhrase}' already exists.")
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


# Raised when one passes one value for an argument via the macro-step's phrase
# and a value for that same argument via the the data table.
# and that argument name does not appear in any sub-step.
class AmbiguousArgumentValue < Macros4CukeError
  def initialize(anArgName, valuePhrase, valueTable)
    msg1 = "The macro argument '#{anArgName}' has value "
    msg2 = "'#{valuePhrase}' and '#{valueTable}'."
    super(msg1 + msg2)
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



# Raised when one invokes a macro-step without a required data table argument.
# The exception is raised only only via Cucumber (steps)
class DataTableNotFound < Macros4CukeError
  def initialize(phrase)
    msg = "The step with phrase [#{phrase}]: requires a data table."
    super(msg)
  end
end # class


# Raised when the list of formatting events provided by a macro-step formatter
# is nil or empty.
class NoFormattingEventForFormatter < Macros4CukeError
  def initialize(aFormatter)
    msg = "Formatter #{aFormatter.class}"
    msg << ' does not support any formatting event.'
    super(msg)
  end
end # class


# Raised when a macro-step formatter uses an unknown formatting event.
class UnknownFormattingEvent < Macros4CukeError
  def initialize(aFormatter, anEvent)
    msg = "Formatter #{aFormatter.class}"
    msg << " uses the unknown formatting event '#{anEvent}'."
    super(msg)
  end
end # class


# Raised when Macros4Cuke encountered an issue
# that it can't handle properly.
class InternalError < Macros4CukeError
end # class
end # module

# End of file

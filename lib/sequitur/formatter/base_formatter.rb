# frozen_string_literal: true

module Sequitur
  # Namespace dedicated to grammar formatters.
  module Formatter
    # Superclass for grammar formatters.
    class BaseFormatter
      # The IO output stream in which the formatter's result will be sent.
      attr_accessor(:output)

      # Constructor.
      # @param anIO [IO] an output IO where the formatter's result will
      # be placed.
      def initialize(anIO)
        @output = anIO
      end

      # Given a grammar or a grammar visitor, perform the visit
      # and render the visit events in the output stream.
      # @param aGrmOrVisitor [DynamicGrammar or GrammarVisitor]
      def render(aGrmOrVisitor)
        a_visitor = if aGrmOrVisitor.kind_of?(GrammarVisitor)
                      aGrmOrVisitor
                    else
                      aGrmOrVisitor.visitor
                    end

        a_visitor.subscribe(self)
        a_visitor.start
        a_visitor.unsubscribe(self)
      end
    end # class
  end # module
end # module

# End of file

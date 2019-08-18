# frozen_string_literal: true

require_relative 'base_formatter'


module Sequitur
  module Formatter
    # A formatter class that can render the notification events
    # from a grammar visitor
    # @example
    #   some_grammar = ... # Points to a DynamicGrammar-like object
    #   # Output the result to the standard console output
    #   formatter = Sequitur::Formatter::Debug.new(STDOUT)
    #   # Render the visit notifications
    #   formatter.run(some_grammar.visitor)
    class Debug < BaseFormatter
      # Current indentation level
      attr_accessor(:indentation)

      # Constructor.
      # @param anIO [IO] The output stream to which the rendered grammar
      # is written.
      def initialize(anIO)
        super(anIO)
        @indentation = 0
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor is about to visit a grammar
      # @param _ [DynamicGrammar-like object]
      def before_grammar(_)
        output_event(__method__, indentation)
        indent
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor is about to visit
      # a production
      # @param _ [aProduction]
      def before_production(_)
        output_event(__method__, indentation)
        indent
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor is about to visit
      # the rhs of a production
      # @param _ [Array]
      def before_rhs(_)
        output_event(__method__, indentation)
        indent
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor is about to visit
      # a terminal symbol from the rhs of a production
      # @param _ [Object]
      def before_terminal(_)
        output_event(__method__, indentation)
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor completed the visit of
      # a terminal symbol from the rhs of a production
      # @param _ [Object]
      def after_terminal(_)
        output_event(__method__, indentation)
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor is about to visit
      # a non-terminal (= an allusion to a production) in the rhs of a
      # production
      # @param _ [Production] a production occurring in the rhs
      def before_non_terminal(_)
        output_event(__method__, indentation)
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor completed the visit of
      # a non-terminal symbol from the rhs of a production.
      # @param _ [Object]
      def after_non_terminal(_)
        output_event(__method__, indentation)
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor completed the visit of
      # the rhs of a production
      # @param _ [Array]
      def after_rhs(_)
        dedent
        output_event(__method__, indentation)
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor completed the visit
      # of a production
      def after_production(_)
        dedent
        output_event(__method__, indentation)
      end

      # Method called by a GrammarVisitor to which the formatter subscribed.
      # Notification of a visit event: the visitor completed the visit
      # of a grammar
      def after_grammar(_)
        dedent
        output_event(__method__, indentation)
      end

      private

      def indent
        @indentation += 1
      end

      def dedent
        @indentation -= 1
      end

      def output_event(anEvent, indentationLevel)
        output.puts "#{' ' * 2 * indentationLevel}#{anEvent}"
      end
    end # class
  end # module
end # module
# End of file

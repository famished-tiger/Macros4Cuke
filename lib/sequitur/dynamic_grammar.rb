# frozen_string_literal: true

require_relative 'production'
require_relative 'grammar_visitor'

module Sequitur # Module for classes implementing the Sequitur algorithm
  # A dynamic grammar is a context-free grammar that can be built incrementally.
  #   Formally, a grammar has:
  #   One start production
  #   Zero or more other productions
  #   Each production has a rhs that is a sequence of grammar symbols.
  #   Grammar symbols are categorized into
  #   -terminal symbols (i.e. String, Ruby Symbol,...)
  #   -non-terminal symbols (i.e. ProductionRef)
  class DynamicGrammar
    # Link to the start production.
    attr_reader(:start)

    # The set of production rules of the grammar
    attr_reader(:productions)

    # nodoc Trace the execution of the algorithm.
    attr_accessor(:trace)

    # Constructor.
    # Build a grammar with one empty rule as start/start rule.
    def initialize
      @start = Production.new
      @productions = [start]
      @trace = false
    end

    # Emit a text representation of the grammar.
    # Each production rule is emitted per line.
    # @return [String]
    def to_string
      rule_text = productions.map(&:to_string).join("\n")
      return rule_text
    end

    # Add a given production to the grammar.
    # @param aProduction [Production]
    def add_production(aProduction)
      # TODO: remove output
      puts "Adding #{aProduction.object_id}" if trace
      puts aProduction.to_string if trace
      productions << aProduction
    end

    # Remove a production with given index from the grammar
    # @param anIndex [Fixnum]
    # @return [Production] the production removed from the grammar.
    def remove_production(anIndex)
      puts "Before production removal #{productions[anIndex].object_id}" if trace
      puts to_string if trace
      prod = productions.delete_at(anIndex)
      # TODO: remove output
      puts('Removed: ' + prod.to_string) if trace
      prod.clear_rhs

      return prod
    end

    # Add the given token to the grammar.
    #   Append the token to the rhs of the start/start rule.
    # @param aToken [Object] input token to add
    def add_token(aToken)
      append_symbol_to(start, aToken)
    end

    # Part of the 'visitee' role in the Visitor design pattern.
    #   A visitee is expected to accept the visit from a visitor object
    # @param aVisitor [GrammarVisitor] the visitor object
    def accept(aVisitor)
      aVisitor.start_visit_grammar(self)

      # Let's proceed with the visit of productions
      productions.each { |prod| prod.accept(aVisitor) }

      aVisitor.end_visit_grammar(self)
    end

    # Factory method. Returns a visitor for this grammar.
    # @return [GrammarVisitor]
    def visitor
      return GrammarVisitor.new(self)
    end

    protected

    # Append a given symbol to the rhs of passed production.
    # @param aProduction [Production]
    # @param aSymbol [Object]
    def append_symbol_to(aProduction, aSymbol)
      aProduction.append_symbol(aSymbol)
    end
  end # class
end # module
# End of file

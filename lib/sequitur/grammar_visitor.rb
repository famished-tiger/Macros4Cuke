# frozen_string_literal: true

module Sequitur # Module for classes implementing the Sequitur algorithm
# A visitor class dedicated in the visit of Grammar.
  class GrammarVisitor
    # Link to the grammar to visit
    attr_reader(:grammar)

    # List of objects that subscribed to the visit event notification.
    attr_reader(:subscribers)

    # Build a visitor for the given grammar.
    # @param aGrammar [DynamicGrammar-like] the grammar to visit.
    def initialize(aGrammar)
      @grammar = aGrammar
      @subscribers = []
    end

    # Add a subscriber for the visit event notification.
    # @param aSubscriber [Object]
    def subscribe(aSubscriber)
      subscribers << aSubscriber
    end

    # Remove the given object from the subscription list.
    # The object won't be notified of visit events.
    # @param aSubscriber [Object]
    def unsubscribe(aSubscriber)
      subscribers.delete_if { |entry| entry == aSubscriber }
    end

    # The signal to start the visit.
    def start
      grammar.accept(self)
    end

    # Visit event. The visitor is about to visit the grammar.
    # @param aGrammar [DynamicGrammar-like] the grammar to visit.
    def start_visit_grammar(aGrammar)
      broadcast(:before_grammar, aGrammar)
    end

    # Visit event. The visitor is about to visit the given production.
    # @param aProduction [Production] the production to visit.
    def start_visit_production(aProduction)
      broadcast(:before_production, aProduction)
    end

    # Visit event. The visitor is about to visit the given rhs of production.
    # @param rhs [SymbolSequence] the rhs of a production to visit.
    def start_visit_rhs(rhs)
      broadcast(:before_rhs, rhs)
    end

    # Visit event. The visitor is visiting the
    # given reference production (= non-terminal symbol).
    # @param aProdRef [ProductionRef] the production reference to visit.
    def visit_prod_ref(aProdRef)
      production = aProdRef.production
      broadcast(:before_non_terminal, production)
      broadcast(:after_non_terminal, production)
    end

    # Visit event. The visitor is visiting the
    # given terminal symbol.
    # @param aTerminal [Object] the terminal to visit.
    def visit_terminal(aTerminal)
      broadcast(:before_terminal, aTerminal)
      broadcast(:after_terminal, aTerminal)
    end

    # Visit event. The visitor has completed its visit of the given rhs.
    # @param rhs [SymbolSequence] the rhs of a production to visit.
    def end_visit_rhs(rhs)
      broadcast(:after_rhs, rhs)
    end

    # Visit event. The visitor has completed its visit of the given production.
    # @param aProduction [Production] the production to visit.
    def end_visit_production(aProduction)
      broadcast(:after_production, aProduction)
    end

    # Visit event. The visitor has completed the visit of the grammar.
    # @param aGrammar [DynamicGrammar-like] the grammar to visit.
    def end_visit_grammar(aGrammar)
      broadcast(:after_grammar, aGrammar)
    end

    private

    # Send a notification to all subscribers.
    # @param msg [Symbol] event to notify
    # @param args [Array] arguments of the notification.
    def broadcast(msg, *args)
      subscribers.each do |a_subscriber|
        next unless a_subscriber.respond_to?(msg)

        a_subscriber.send(msg, *args)
      end
    end
  end # class
end # module

# End of file

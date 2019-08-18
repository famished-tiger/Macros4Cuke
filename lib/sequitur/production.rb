# frozen_string_literal: true

require_relative 'digram'
require_relative 'symbol_sequence'
require_relative 'production_ref'

module Sequitur # Module for classes implementing the Sequitur algorithm
# In a context-free grammar, a production is a rule in which
# its left-hand side (LHS) consists solely of a non-terminal symbol
# and the right-hand side (RHS) consists of a sequence of symbols.
# The symbols in RHS can be either terminal or non-terminal symbols.
# The rule stipulates that the LHS is equivalent to the RHS,
# in other words every occurrence of the LHS can be substituted to
# corresponding RHS.
# Implementation note: the object id of the production is taken as its LHS.
class Production
  # The right-hand side (rhs) consists of a sequence of grammar symbols
  attr_reader(:rhs)

  # The reference count (= how times other productions reference this one)
  attr_reader(:refcount)

  # The sequence of digrams appearing in the RHS
  attr_reader(:digrams)

  # Constructor.
  # Build a production with an empty RHS.
  def initialize
    @rhs = SymbolSequence.new
    @refcount = 0
    @digrams = []
  end

  # Identity testing.
  # @param other [] another production or production reference.
  # @return true when the receiver and other are the same.
  def ==(other)
    return true if object_id == other.object_id

    result = if other.is_a?(ProductionRef)
               (other == self)
             else
               false
             end

    return result
  end

  # Is the rhs empty?
  # @ return true if the rhs has no members.
  def empty?
    return rhs.empty?
  end

  # Increment the reference count by one.
  def incr_refcount
    @refcount += 1
  end

  # Decrement the reference count by one.
  def decr_refcount
    raise StandardError, 'Internal error' if @refcount.zero?

    @refcount -= 1
  end

  # Select the references to production appearing in the rhs.
  # @return [Array of ProductionRef]
  def references
    return rhs.references
  end

  # Look in the rhs all the references to a production passed a argument.
  # aProduction [aProduction or ProductionRef] The production to search for.
  # @return [Array] the array of ProductionRef to the passed production
  def references_of(a_prod)
    real_prod = a_prod.is_a?(ProductionRef) ? a_prod.production : a_prod
    return rhs.references_of(real_prod)
  end

  # Enumerate the digrams appearing in the right-hand side (rhs)
  # @return [Array] the list of digrams found in rhs of this production.
  def recalc_digrams
    return [] if rhs.size < 2

    result = []
    rhs.symbols.each_cons(2) { |couple| result << Digram.new(*couple, self) }
    @digrams = result
  end

  # Does the rhs have exactly one digram only (= 2 symbols)?
  # @return [true/false] true when the rhs contains exactly two symbols.
  def single_digram?
    return rhs.size == 2
  end

  # Detect whether the last digram occurs twice
  # Assumption: when a digram occurs twice in a production then it must occur
  # at the end of the rhs
  # @return [true/false] true when the digram occurs twice in rhs.
  def repeated_digram?
    return false if rhs.size < 3

    my_digrams = digrams
    all_keys = my_digrams.map(&:key)
    last_key = all_keys.pop
    same_key_found = all_keys.index(last_key)
    return !same_key_found.nil?
  end

  # Retrieve the last digram appearing in the RHS (if any).
  # @return [Digram] last digram in the rhs otherwise nil.
  def last_digram
    result = digrams.empty? ? nil : digrams.last
    return result
  end

  # Emit a text representation of the production rule.
  # Text is of the form:
  # object id of production : rhs as space-separated sequence of symbols.
  # @return [String]
  def to_string
    return "#{object_id} : #{rhs.to_string}."
  end

  # Add a (grammar) symbol at the end of the RHS.
  # @param aSymbol [Object] A (grammar) symbol to add.
  def append_symbol(aSymbol)
    case aSymbol
      when Production
        new_symb = ProductionRef.new(aSymbol)
      when ProductionRef
        if aSymbol.unbound?
          msg = 'Fail to append reference to nil production in '
          msg << to_string
          raise StandardError, msg
        end
        new_symb = aSymbol.dup
      else
        new_symb = aSymbol
    end

    rhs << new_symb
    digrams << Digram.new(rhs[-2], rhs[-1], self) if rhs.size >= 2
  end

  # Clear the right-hand side.
  # Any referenced production has its reference counter decremented.
  def clear_rhs
    rhs.clear
  end

  # Find all the positions where the digram occurs in the rhs
  # @param symb1 [Object] first symbol of the digram
  # @param symb2 [Object] second symbol of the digram
  # @return [Array] the list of indices where the digram occurs in rhs.
  # @example
  #   # Given the production p : a b c a b a b d
  #   #Then ...
  #   p.positions_of(a, b) # => [0, 3, 5]
  #   # Caution: "overlapping" digrams shouldn't be counted
  #   # Given the production p : a a b a a a c d
  #   # Then ...
  #   p.positions_of(a, a) # => [0, 3]
  def positions_of(symb1, symb2)
    # Find the positions where the digram occur in rhs
    indices = [-2] # Dummy index!
    (0...rhs.size).each do |i|
      next if i == indices.last + 1

      indices << i if (rhs[i] == symb1) && (rhs[i + 1] == symb2)
    end

    indices.shift

    return indices
  end

  # Given that the production P passed as argument has exactly 2 symbols
  #   in its rhs s1 s2, substitute in the rhs of self all occurrences of
  #   s1 s2 by a reference to P.
  # @param another [Production or ProductionRef] a production that
  #   consists exactly of one digram (= 2 symbols).
  def reduce_step(another)
    (symb1, symb2) = another.rhs.symbols
    pos = positions_of(symb1, symb2).reverse

    # Replace the two symbol sequence by the production
    pos.each { |index| rhs.reduce_step(index, another) }

    recalc_digrams
  end

  # Replace every occurrence of 'another' production in self.rhs by
  #   the symbols in the rhs of 'another'.
  # @param another [Production or ProductionRef] a production that
  #   consists exactly of one digram (= 2 symbols).
  # @example Synopsis
  # # Given the production p_A : a p_B b p_B c
  # # And the production p_B : x y
  # # Then...
  # p_A.derive_step(p_B)
  # #Modifies p_A as into: p_A -> a x y b x y c
  def derive_step(another)
    (0...rhs.size).to_a.reverse_each do |index|
      next unless rhs[index] == another

      rhs.insert_at(index + 1, another.rhs)
      another.decr_refcount
      rhs.delete_at(index)
    end

    recalc_digrams
  end

  # Part of the 'visitee' role in Visitor design pattern.
  # @param aVisitor[GrammarVisitor]
  def accept(aVisitor)
    aVisitor.start_visit_production(self)

    rhs.accept(aVisitor)

    aVisitor.end_visit_production(self)
  end
end # class
end # module

# End of file

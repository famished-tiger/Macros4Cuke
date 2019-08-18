# frozen_string_literal: true

module Sequitur # Module for classes implementing the Sequitur algorithm
  # Represents a sequence (concatenation) of grammar symbols
  # as they appear in rhs of productions
  class SymbolSequence
    # The sequence of symbols itself
    attr_reader(:symbols)

    # Create an empty sequence
    def initialize
      @symbols = []
    end

    # Copy constructor invoked by dup or clone methods.
    # @param orig [SymbolSequence]
    def initialize_copy(orig)
      # Deep copy to avoid the aliasing of production reference
      @symbols = orig.symbols.map do |sym|
        sym.is_a?(ProductionRef) ? sym.dup : sym
      end
      invalidate_refs
    end

    # Clear the symbol sequence.
    def clear
      refs = references
      refs.each(&:unbind)
      @symbols = []
      invalidate_refs
    end

    # Tell whether the sequence is empty.
    # @return [true / false] true only if the sequence has no symbol in it.
    def empty?
      return symbols.empty?
    end

    # Count the number of elements in the sequence.
    #  @return [Fixnum] the number of elements
    def size
      return symbols.size
    end

    # Append a grammar symbol at the end of the sequence.
    # @param aSymbol [Object] The symbol to append.
    def <<(aSymbol)
      symbols << aSymbol
      return unless aSymbol.is_a?(ProductionRef)

      @memo_references ||= []
      @memo_references << aSymbol
    end

    # Retrieve the element from the sequence at given position.
    # @param anIndex [Fixnum] A zero-based index of the element to access.
    def [](anIndex)
      return symbols[anIndex]
    end

    # Equality testing.
    # @param other [SymbolSequence or Array] the other other sequence
    #   to compare to.
    # @return true when an item from self equals the corresponding
    #   item from 'other'
    def ==(other)
      return true if object_id == other.object_id

      same = case other
               when SymbolSequence
                 symbols == other.symbols
               when Array
                 symbols == other
               else
                 false
             end

      return same
    end

    # Select the references to production appearing in the rhs.
    # @return [Array of ProductionRef]
    def references
      @memo_references ||= symbols.select { |symb| symb.is_a?(ProductionRef) }
      return @memo_references
    end

    # Select the references of the given production appearing in the rhs.
    # @param aProduction [Production]
    # @return [Array of ProductionRef]
    def references_of(aProduction)
      return [] if references.empty?

      result = references.select { |a_ref| a_ref == aProduction }
      return result
    end

    # Emit a text representation of the symbol sequence.
    # Text is of the form: space-separated sequence of symbols.
    # @return [String]
    def to_string
      rhs_text = symbols.map do |elem|
        case elem
          when String then "'#{elem}'"
          else elem.to_s
        end
      end

      return rhs_text.join(' ')
    end

    # Insert at position the elements from another sequence.
    # @param position [Fixnum] A zero-based index of the symbols to replace.
    # @param another [SymbolSequence] A production with a two-elements rhs
    #   (a single digram).
    def insert_at(position, another)
      klone = another.dup
      symbols.insert(position, *klone.symbols)
      invalidate_refs
    end

    # Given that the production P passed as argument has exactly 2 symbols
    #   in its rhs s1 s2, substitute in the rhs of self all occurrences of
    #   s1 s2 by a reference to P.
    # @param index [Fixnum] the position of a two symbol sequence to be replaced
    #   by the production
    # @param aProduction [Production or ProductionRef] a production that
    #   consists exactly of one digram (= 2 symbols).
    def reduce_step(index, aProduction)
      if symbols[index].is_a?(ProductionRef)
        symbols[index].bind_to(aProduction)
      else
        new_ref = ProductionRef.new(aProduction)
        symbols[index] = new_ref
        @memo_references ||= []
        @memo_references << new_ref
      end
      index1 = index + 1
      if symbols[index1].is_a?(ProductionRef)
        symbols[index1].unbind
        invalidate_refs
      end
      delete_at(index1)
    end

    # Remove the element at given position
    # @param position [Fixnum] a zero-based index.
    def delete_at(position)
      invalidate_refs if symbols[position].is_a?(ProductionRef)
      symbols.delete_at(position)
    end

    # Part of the 'visitee' role in Visitor design pattern.
    # @param aVisitor[GrammarVisitor]
    def accept(aVisitor)
      aVisitor.start_visit_rhs(self)

      # Let's proceed with the visit of productions
      symbols.each do |a_symb|
        if a_symb.is_a?(ProductionRef)
          a_symb.accept(aVisitor)
        else
          aVisitor.visit_terminal(a_symb)
        end
      end

      aVisitor.end_visit_rhs(self)
    end

    private

    def invalidate_refs
      @memo_references = nil
      @lookup_references = nil
    end
  end # class
end # module

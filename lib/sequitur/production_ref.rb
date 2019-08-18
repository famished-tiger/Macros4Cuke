# frozen_string_literal: true

module Sequitur # Module for classes implementing the Sequitur algorithm
  # A production reference is a grammar symbol that may appear in the right-hand
  # side of a production P1 and that refers to a production P2.
  # Every time a production P2 appears in the left-hand side of
  # production P1, this is implemented by inserting a production reference to P2
  # in the appropriate position in the RHS of P1.
  # In the literature, production references are also called non terminal
  # symbols
  # @example
  #   # Given a production rule...
  #   prod = Sequitur::Production.new
  #   puts prod.refcount # outputs 0
  #   # ... Build a reference to it
  #   ref = Sequitur::ProductionRef.new(prod)
  #   # ... Production reference count is updated...
  #   puts prod.refcount # outputs 1
  class ProductionRef
    # Link to the production to reference.
    attr_reader(:production)

    # Constructor
    # @param target [Production or ProductionRef]
    #   The production that is being referenced.
    def initialize(target)
      bind_to(target)
    end

    # Copy constructor invoked by dup or clone methods.
    # @param orig [ProductionRef]
    # @example
    #   prod = Sequitur::Production.new
    #   ref = Sequitur::ProductionRef.new(prod)
    #   copy_ref = ref.dup
    #   puts prod.refcount # outputs 2
    def initialize_copy(orig)
      @production = nil
      bind_to(orig.production)
    end

    # Emit the text representation of a production reference.
    # @return [String]
    def to_s
      return production.object_id.to_s
    end

    alias to_string to_s


    # Equality testing.
    #   A production ref is equal to another one when its
    #   refers to the same production or when it is compared to
    #   the production it refers to.
    # @param other [ProductionRef]
    # @return [true / false]
    def ==(other)
      return true if object_id == other.object_id

      result = if other.is_a?(ProductionRef)
                 (production == other.production)
               else
                 (production == other)
               end

      return result
    end

    # Produce a hash value.
    #   A reference has no identity on its own,
    #   the method returns the hash value of the
    #   referenced production
    # @return [Fixnum] the hash value
    def hash
      raise StandardError, 'Nil production' if production.nil?

      return production.hash
    end

    # Make this reference point to the given production.
    # @param aProduction [Production or ProductionRef] the production
    #   to refer to
    def bind_to(aProduction)
      return if aProduction == @production

      production&.decr_refcount
      unless aProduction.kind_of?(Production)
        raise StandardError, "Illegal production type #{aProduction.class}"
      end

      @production = aProduction
      production.incr_refcount
    end

    # Clear the reference to the target production.
    def unbind
      production.decr_refcount
      @production = nil
    end

    # Check that the this object doesn't refer to any production.
    # @return [true / false] true when this object doesn't
    #   point to a production.
    def unbound?
      return production.nil?
    end

    # Part of the 'visitee' role in the Visitor design pattern.
    # @param aVisitor [GrammarVisitor] the visitor
    def accept(aVisitor)
      aVisitor.visit_prod_ref(self)
    end
  end # class
end # module

# End of file

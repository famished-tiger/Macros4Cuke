# frozen_string_literal: true

require_relative 'dynamic_grammar'


module Sequitur # Module for classes implementing the Sequitur algorithm
# Specialization of the DynamicGrammar class.
# A Sequitur grammar is a context-free grammar that is entirely built
# from a sequence of input tokens through the Sequitur algorithm.
class SequiturGrammar < DynamicGrammar
  # Build the grammar from an enumerator of tokens.
  # @param anEnum [Enumerator] an enumerator that will iterate
  #   over the input tokens.
  def initialize(anEnum)
    super()
    # Make start production compliant with utility rule
    2.times { start.incr_refcount }

    # Read the input sequence and apply the Sequitur algorithm
    anEnum.each do |a_token|
      add_token(a_token)
      enforce_rules
    end
  end

  private

  # Struct used for internal purposes
  CollisionDiagnosis = Struct.new(
    :collision_found, # true if collision detected
    :digram, # The digram involved in a collision
    :productions # The productions where the digram occurs
  )


  # Assuming that a new input token was added to the start production,
  # enforce the digram unicity and rule utility rules
  # begin
  #   if a digram D occurs twice in the grammar then
  #     add a production P : D (if not already there)
  #     replace both Ds with R (reduction step).
  #   end
  #   if a production P : RHS in referenced only once then
  #     replace P by its RHS (derivation step)
  #     remove P from grammar
  #   end
  #  end until digram unicity and rule utility are met
  def enforce_rules
    loop do
      unicity_diagnosis = detect_collision if unicity_diagnosis.nil?
      restore_unicity(unicity_diagnosis) if unicity_diagnosis.collision_found

      prod_index = detect_useless_production
      restore_utility(prod_index) unless prod_index.nil?

      unicity_diagnosis = detect_collision
      prod_index = detect_useless_production
      break unless unicity_diagnosis.collision_found || !prod_index.nil?
    end
  end

  # Check whether a digram is used twice in the grammar.
  # Return an empty Hash if each digram appears once.
  # Otherwise return a Hash with a pair of the form: digram => [Pi, Pk]
  # Where Pi, Pk are two productions where the digram occurs.
  def detect_collision
    diagnosis = CollisionDiagnosis.new(false)
    found_so_far = {}
    productions.each do |a_prod|
      prod_digrams = a_prod.digrams
      prod_digrams.each do |a_digr|
        its_key = a_digr.key
        if found_so_far.include? its_key
          orig_digr = found_so_far[its_key]
          # Disregard sequence like a a a
          if (orig_digr.production == a_prod) && a_digr.repeating? &&
             (orig_digr == a_digr)
            next
          end

          diagnosis.digram = orig_digr
          diagnosis.productions = [orig_digr.production, a_prod]
          diagnosis.collision_found = true
          break
        else
          found_so_far[its_key] = a_digr
        end
      end
      break if diagnosis.collision_found
    end

    return diagnosis
  end

  # When a collision diagnosis indicates that a given
  # digram d occurs twice in the grammar
  # Then create a new production that will have
  # the symbols of d as its rhs members.
  def restore_unicity(aDiagnosis)
    prods = aDiagnosis.productions
    if prods.any?(&:single_digram?)
      (simple, compound) = prods.partition(&:single_digram?)
      compound[0].reduce_step(simple[0])
    else
      # Create a new production with the digram's symbols as its
      # sole rhs members.
      new_prod = build_production_for(aDiagnosis.digram)
      prods[0].reduce_step(new_prod)
      prods[1].reduce_step(new_prod) unless prods[1] == prods[0]
    end
  end

  # Return a production that is used less than twice in the grammar.
  def detect_useless_production
    useless = productions.index { |prod| prod.refcount < 2 }
    useless = nil if useless&.zero?

    return useless
  end

  # Given the passed production P is referenced only once.
  # Then replace P by its RHS where it is referenced.
  # And delete P
  def restore_utility(prod_index)
    # Retrieve useless prod from its index
    useless_prod = productions[prod_index]

    # Retrieve production referencing useless one
    referencing = nil
    productions.reverse_each do |a_prod|
      # Next line assumes non-recursive productions
      next if a_prod == useless_prod

      refs = a_prod.references_of(useless_prod)
      next if refs.empty?

      referencing = a_prod
      break
    end

    referencing.derive_step(useless_prod)
    remove_production(prod_index)
  end

  # Create a new production that will have the symbols from digram
  # as its rhs members.
  def build_production_for(aDigram)
    new_prod = Production.new
    aDigram.symbols.each { |sym| new_prod.append_symbol(sym) }
    add_production(new_prod)

    return new_prod
  end
end # class
end # module
# End of file

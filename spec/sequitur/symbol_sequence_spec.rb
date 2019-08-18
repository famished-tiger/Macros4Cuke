# frozen_string_literal: true

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/sequitur/symbol_sequence'
require_relative '../../lib/sequitur/production_ref'
require_relative '../../lib/sequitur/production'

module Sequitur # Re-open the module to get rid of qualified names
describe SymbolSequence do
  let(:instance) { SymbolSequence.new }

  context 'Creation and initialization:' do
    it 'should be created without argument' do
      expect { SymbolSequence.new }.not_to raise_error
    end

    it 'should be empty at creation' do
      expect(subject).to be_empty
    end
  end # context

  context 'Provided services:' do
    let(:a_prod) { Production.new }

    subject do
      an_instance = SymbolSequence.new
      %i[a b c].each { |a_sym| an_instance << a_sym }
      an_instance
    end

    it 'should deep-copy clone itself' do
      ref = ProductionRef.new(a_prod)

      a = 'a'
      c = 'c'
      [a, ref, c].each { |ch| instance << ch }
      clone_a = instance.clone

      # Check that cloning works
      expect(clone_a).to eq(instance)

      # Reference objects are distinct but points to same production
      expect(clone_a.symbols[1].object_id).not_to eq(instance.symbols[1])

      # Modifying the clone...
      clone_a.symbols[1] = 'diff'
      expect(clone_a).not_to eq(instance)

      # ... should leave original unchanged
      expect(instance.symbols[1]).to eq(ref)
    end


    it 'should tell that it is equal to itself' do
      # Case: Non-empty sequence
      expect(subject).to eq(subject)

      # Case: empty sequence
      expect(instance).to eq(instance)
    end

    it 'should know whether it is equal to another instance' do
      expect(instance).to eq(instance)

      expect(subject).not_to eq(instance)
      %i[a b c].each { |a_sym| instance << a_sym }
      expect(subject).to eq(instance)

      # Check that element order is relevant
      instance.symbols.rotate!
      expect(subject).not_to eq(instance)
    end

    it 'should know whether it is equal to an array' do
      expect(subject).to eq(%i[a b c])

      # Check that element order is relevant
      expect(subject).not_to eq(%i[c b a])
    end

    it 'should know that is not equal to something else' do
      expect(subject).not_to eq(:abc)
    end


    it 'should know its references' do
      ref = ProductionRef.new(a_prod)
      2.times { subject << ref }

      refs = subject.references
      expect(refs.size).to eq(2)
      expect(refs).to eq([ref, ref])

      refs = subject.references
      expect(refs.size).to eq(2)
      expect(refs).to eq([ref, ref])
      specific_refs = subject.references_of(a_prod)
      expect(specific_refs).to eq(refs)


      another = Production.new
      another_ref = ProductionRef.new(another)
      subject << another_ref
      refs = subject.references
      expect(refs.size).to eq(3)
      expect(refs).to eq([ref, ref, another])
      specific_refs = subject.references_of(a_prod)
      expect(specific_refs).to eq([ref, ref])
      specific_refs = subject.references_of(another)
      expect(specific_refs).to eq([another])
    end
  end # context
end # describe
end # module

# End of file

# frozen_string_literal: true

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/sequitur/digram'

module Sequitur # Re-open the module to get rid of qualified names
describe Digram do
  let(:two_symbols) { %i[b c] }
  let(:production) { double('sample-production') }

  context 'Standard creation & initialization:' do
    it 'should be created with 3 arguments' do
      instance = Digram.new(:b, :c, production)

      expect(instance.symbols).to eq(two_symbols)
      expect(instance.production).to eq(production)
    end

    it 'should return the production that it refers to' do
      instance = Digram.new(:b, :c, production)
      expect(instance.production).to eq(production)
    end

    it 'should whether its symbols are the same' do
       instance1 = Digram.new(:a, :a, production)
       expect(instance1).to be_repeating

       instance1 = Digram.new(:a, :b, production)
       expect(instance1).not_to be_repeating
    end
  end # context

  context 'Provided services:' do
    it 'should compare itself to another digram' do
      instance1 = Digram.new(:a, :b, production)
      same = Digram.new(:a, :b, production)
      different = Digram.new(:b, :c, production)

      expect(instance1).to eq(instance1)
      expect(instance1).to eq(same)
      expect(instance1).not_to eq(different)
      expect(same).not_to eq(different)
    end
  end # context
end # describe
end # module

# End of file

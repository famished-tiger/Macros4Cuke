# frozen_string_literal: true

require_relative '../../spec_helper'
require 'stringio'

require_relative '../../../lib/sequitur/dynamic_grammar'

# Load the class under test
require_relative '../../../lib/sequitur/formatter/debug'

module Sequitur # Re-open the module to get rid of qualified names
module Formatter
describe Debug do
  # Factory method. Build a production with the given sequence
  # of symbols as its rhs.
  def build_production(*symbols)
    prod = Production.new
    symbols.each { |symb| prod.append_symbol(symb) }
    return prod
  end

  let(:p_a) { build_production(:a) }
  let(:p_b) { build_production(:b) }
  let(:p_c) { build_production(:c) }
  let(:p_bc) { build_production(p_b, p_c) }

  let(:empty_grammar) { DynamicGrammar.new }
  let(:sample_grammar) do
    grm = DynamicGrammar.new
    grm.add_production(p_a)
    grm.add_production(p_b)
    grm.add_production(p_c)
    grm.add_production(p_bc)
    grm
  end

  let(:destination) { StringIO.new(+'', 'w') }

  context 'Standard creation & initialization:' do
    it 'should be initialized with an IO argument' do
      expect { Debug.new(StringIO.new(+'', 'w')) }.not_to raise_error
    end

    it 'should know its output destination' do
      instance = Debug.new(destination)
      expect(instance.output).to eq(destination)
    end
  end # context



  context 'Formatting events:' do
    it 'should support events of an empty grammar' do
      instance = Debug.new(destination)
      a_visitor = empty_grammar.visitor
      instance.render(a_visitor)
      expectations = <<-SNIPPET
before_grammar
  before_production
    before_rhs
    after_rhs
  after_production
after_grammar
SNIPPET
      expect(destination.string).to eq(expectations)
    end

    it 'should support events of a non-empty grammar' do
      instance = Debug.new(destination)
      a_visitor = sample_grammar.visitor
      instance.render(a_visitor)
      expectations = <<-SNIPPET
before_grammar
  before_production
    before_rhs
    after_rhs
  after_production
  before_production
    before_rhs
      before_terminal
      after_terminal
    after_rhs
  after_production
  before_production
    before_rhs
      before_terminal
      after_terminal
    after_rhs
  after_production
  before_production
    before_rhs
      before_terminal
      after_terminal
    after_rhs
  after_production
  before_production
    before_rhs
      before_non_terminal
      after_non_terminal
      before_non_terminal
      after_non_terminal
    after_rhs
  after_production
after_grammar
SNIPPET
      expect(destination.string).to eq(expectations)
    end
  end # context
end # describe
end # module
end # module

# End of file

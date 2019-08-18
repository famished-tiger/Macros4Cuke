# frozen_string_literal: true

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/sequitur/dynamic_grammar'

module Sequitur # Re-open the module to get rid of qualified names
describe DynamicGrammar do
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


  context 'Creation & initialization:' do
    it 'should be created without parameter' do
      expect { DynamicGrammar.new }.not_to raise_error
    end

    it 'should have an empty start/start production' do
      expect(subject.start).to be_empty
      expect(subject.productions.size).to eq(1)
      expect(subject.productions.first).to be_empty
    end
  end # context


  context 'Adding productions to the grammar:' do
    it 'should add a simple production' do
      subject.add_production(p_a)
      expect(subject.productions.size).to eq(2)
      expect(subject.productions.last).to eq(p_a)

      # Error: p_b, p_c not in grammar
      expect { add_production(p_bc) }.to raise_error(StandardError)

      subject.add_production(p_b)
      expect(subject.productions.size).to eq(3)
      expect(subject.productions.last).to eq(p_b)

      # Error: p_c not in grammar
      expect { add_production(p_bc) }.to raise_error(StandardError)

      subject.add_production(p_c)
      expect(subject.productions.size).to eq(4)
      expect(subject.productions.last).to eq(p_c)

      subject.add_production(p_bc)
      expect(subject.productions.size).to eq(5)
      expect(subject.productions.last).to eq(p_bc)
    end
  end # context


  context 'Removing a production from the grammar:' do
    it 'should remove an existing production' do
      subject.add_production(p_a) # index = 1
      subject.add_production(p_b) # index = 2
      subject.add_production(p_c) # index = 3
      subject.add_production(p_bc) # index = 4
      expect(subject.productions.size).to eq(5)

      expect(p_a.refcount).to eq(0)
      expect(p_b.refcount).to eq(1)
      expect(p_c.refcount).to eq(1)

      subject.remove_production(1) # 1 => p_a
      expect(subject.productions.size).to eq(4)
      expect(p_b.refcount).to eq(1)
      expect(p_c.refcount).to eq(1)
      expect(subject.productions).not_to include(p_a)

      subject.remove_production(3) # 3 => p_bc

      expect(subject.productions.size).to eq(3)
      expect(p_b.refcount).to eq(0)
      expect(p_c.refcount).to eq(0)
      expect(subject.productions).not_to include(p_bc)
    end
  end # context

  context 'Visiting:' do
    it 'should return a visitor' do
      expect { subject.visitor }.not_to raise_error
      expect(subject.visitor).to be_kind_of(GrammarVisitor)
    end

    it 'should accept a visitor' do
      subject.add_production(p_a) # index = 1
      subject.add_production(p_b) # index = 2
      subject.add_production(p_c) # index = 3
      subject.add_production(p_bc) # index = 4

      a_visitor = subject.visitor
      fake_formatter = double('fake-formatter')
      a_visitor.subscribe(fake_formatter)

      expect(fake_formatter).to receive(:before_grammar).with(subject).ordered
      expect(fake_formatter).to receive(:before_production)
        .with(subject.start).ordered
      expect(fake_formatter).to receive(:before_rhs)
        .with(subject.start.rhs).ordered
      expect(fake_formatter).to receive(:after_rhs)
        .with(subject.start.rhs).ordered
      expect(fake_formatter).to receive(:after_production).with(subject.start)
      expect(fake_formatter).to receive(:before_production).with(p_a)
      expect(fake_formatter).to receive(:before_rhs).with(p_a.rhs)
      expect(fake_formatter).to receive(:after_rhs).with(p_a.rhs)
      expect(fake_formatter).to receive(:after_production).with(p_a)
      expect(fake_formatter).to receive(:before_production).with(p_b)
      expect(fake_formatter).to receive(:before_rhs).with(p_b.rhs)
      expect(fake_formatter).to receive(:after_rhs).with(p_b.rhs)
      expect(fake_formatter).to receive(:after_production).with(p_b)
      expect(fake_formatter).to receive(:before_production).with(p_c)
      expect(fake_formatter).to receive(:before_rhs).with(p_c.rhs)
      expect(fake_formatter).to receive(:after_rhs).with(p_c.rhs)
      expect(fake_formatter).to receive(:after_production).with(p_c)
      expect(fake_formatter).to receive(:before_production).with(p_bc)
      expect(fake_formatter).to receive(:before_rhs).with(p_bc.rhs)
      expect(fake_formatter).to receive(:after_rhs).with(p_bc.rhs)
      expect(fake_formatter).to receive(:after_production).with(p_bc)
      expect(fake_formatter).to receive(:after_grammar).with(subject)
      subject.send(:accept, a_visitor)
    end
  end # context


  context 'Generating a text representation of itself:' do
    it 'should generate a text representation when empty' do
      expectation = "#{subject.start.object_id} : ."
      expect(subject.to_string).to eq(expectation)
    end
  end # context
end # describe
end # module

# End of file

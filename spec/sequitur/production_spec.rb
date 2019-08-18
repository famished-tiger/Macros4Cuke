# frozen_string_literal: true

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/sequitur/production'

module Sequitur # Re-open the module to get rid of qualified names
describe Production do
  # Helper method: convert list of digrams into an array
  # of symbol couples.
  def to_symbols(theDigrams)
    return theDigrams.map(&:symbols)
  end

  let(:p_a) do
      instance = Production.new
      instance.append_symbol(:a)
      instance
  end

  let(:p_bc) do
    instance = Production.new
    instance.append_symbol('b')
    instance.append_symbol('c')
    instance
  end

  context 'Creation & initialization:' do
    it 'should be created without argument' do
      expect { Production.new }.not_to raise_error
    end

    it 'should not referenced yet' do
      expect(subject.refcount).to eq(0)
    end

    it 'should be empty at creation' do
      expect(subject).to be_empty
    end

    it 'should not have digram' do
      expect(subject.digrams).to be_empty
      expect(subject.last_digram).to be_nil
    end
  end # context

  context 'Provided services:' do
    it 'should compare to another production' do
      expect(p_a).to eq(p_a)
      expect(p_a).not_to eq(p_bc)
    end

    it 'should compare to a production reference' do
      ref_a = ProductionRef.new(p_a)
      expect(p_a).to eq(ref_a)
      expect(p_bc).not_to eq(ref_a)

      ref_bc = ProductionRef.new(p_bc)
      expect(p_a).not_to eq(ref_bc)
      expect(p_bc).to eq(ref_bc)
    end
  end # context

  context 'Knowing its rhs:' do
    it 'should know the productions in its rhs' do
      # Case 1: empty production
      expect(subject.references).to be_empty

      # Case 2: production without references
      symbols = %i[a b c]
      symbols.each { |symb| subject.append_symbol(symb) }
      expect(subject.references).to be_empty
      expect(subject.references_of(p_a)).to be_empty

      # Case 2: production with one reference
      subject.append_symbol(p_a)
      expect(subject.references).to eq([p_a])
      expect(subject.references_of(p_a).map(&:production)).to eq([p_a])


      # Case 3: production with repeated references
      subject.append_symbol(p_a) # second time
      expect(subject.references).to eq([p_a, p_a])
      expect(subject.references_of(p_a).map(&:production)).to eq([p_a, p_a])


      # Case 4: production with multiple distinct references
      subject.append_symbol(p_bc)
      expect(subject.references).to eq([p_a, p_a, p_bc])
      expect(subject.references_of(p_bc).map(&:production)).to eq([p_bc])
    end

    it 'should know the position(s) of a given digram' do
      sequence1 = %i[a b c a b a b d]
      sequence1.each { |symb| subject.append_symbol(symb) }
      positions = [0, 3, 5]
      expect(subject.positions_of(:a, :b)).to eq(positions)

      subject.clear_rhs
      # Case of overlapping digrams
      sequence2 = %i[a a b a a a c d]
      sequence2.each { |symb| subject.append_symbol(symb) }
      positions = [0, 3]
      expect(subject.positions_of(:a, :a)).to eq(positions)
    end
  end # context

  context 'Appending a symbol:' do
    it 'should append a symbol when empty' do
      expect { subject.append_symbol(:a) }.not_to raise_error
      expect(subject.rhs).to eq([:a])
      expect(subject.last_digram).to be_nil
    end

    it 'should append a symbol when has one symbol' do
      subject.append_symbol(:a)
      subject.append_symbol(:b)
      expect(subject.rhs).to eq(%i[a b])
      expect(subject.last_digram.symbols).to eq(%i[a b])
    end

    it 'should append a symbol when rhs has several symbols' do
      symbols = %i[a b c d e f]
      symbols.each { |symb| subject.append_symbol(symb) }
      expect(subject.rhs).to eq(symbols)
      expect(subject.last_digram.symbols).to eq(%i[e f])
    end

    it 'should append a production in its rhs' do
      # Side-effect: refcount of production to append is incremented
      expect(p_a.refcount).to be(0)

      input = [p_a, :b, :c, :d, p_a, :e, :f] # p_a appears twice
      input.each { |symb| subject.append_symbol(symb) }
      expect(p_a.refcount).to be(2)
    end

    it 'should append a production ref in its rhs' do
      # Side-effect: refcount of production to append is incremented
      ref_a = ProductionRef.new(p_a)
      expect(p_a.refcount).to be(1)

      input = [ref_a, :b, :c, :d, ref_a] # ref_a appears twice
      input.each { |symb| subject.append_symbol(symb) }

      # References in rhs should point to p_a...
      # ...but should be distinct reference objects
      expect(subject.rhs[0]).to eq(p_a)
      expect(subject.rhs[0].object_id).not_to eq(ref_a.object_id)
      expect(subject.rhs[-1]).to eq(p_a)
      expect(subject.rhs[-1].object_id).not_to eq(ref_a.object_id)

      # Reference count should be updated
      expect(p_a.refcount).to be(3)
    end

    it 'should complain when appending ref to nil production' do
      # Side-effect: refcount of production to append is incremented
      ref_a = ProductionRef.new(p_a)
      expect(p_a.refcount).to be(1)

      # Unbind the reference
      ref_a.unbind

      expect { subject.append_symbol(ref_a) }.to raise_error(StandardError)
    end
  end # context


  context 'Text representation of a production rule:' do
    it 'should emit minimal text when empty' do
      expectation = "#{subject.object_id} : ."
      expect(subject.to_string).to eq(expectation)
    end

    it 'should emit its text representation' do
      instance = Production.new
      symbols = [:a, :b, 'c', :d, :e, 1000, instance]
      symbols.each { |symb| subject.append_symbol(symb) }
      expectation = +"#{subject.object_id} : "
      expectation << "a b 'c' d e 1000 #{instance.object_id}."
      expect(subject.to_string).to eq(expectation)
    end
  end # context

  context 'Detecting digram repetition:' do
    it 'should report no repetition when empty' do
      expect(subject.repeated_digram?).to be_falsey
    end

    it 'should report no repetition when rhs has less than 3 symbols' do
      subject.append_symbol(:a)
      expect(subject.repeated_digram?).to be_falsey

      subject.append_symbol(:a)
      expect(subject.repeated_digram?).to be_falsey
    end

    it 'should detect shortest repetition' do
      'aaa'.each_char { |symb| subject.append_symbol(symb) }
      expect(subject.repeated_digram?).to be_truthy
    end

    it 'should detect any repetition pattern' do
      # Positive cases
      cases = %w(abab abcdab abcdcd abcdefcd)
      cases.each do |word|
        instance = Production.new
        word.each_char { |symb| instance.append_symbol(symb) }
        expect(instance.repeated_digram?).to be_truthy
      end

      # Negative cases
      cases = %w(abc abb abba abcdef)
      cases.each do |word|
        instance = Production.new
        word.each_char { |symb| instance.append_symbol(symb) }
        expect(instance.repeated_digram?).to be_falsey
      end
    end
  end # context

  context 'Replacing a digram by a production:' do
    it 'should have not effect on empty production' do
      subject.reduce_step(p_bc)
      expect(subject.rhs).to be_empty
      expect(p_bc.refcount).to eq(0)
    end


    it 'should replace two-symbol sequence' do
      %w(a b c d e b c e).each { |symb| subject.append_symbol(symb) }
      p_bc_before = p_bc.to_string
      subject.reduce_step(p_bc)

      expect(subject.rhs.size).to eq(6)
      expect(subject.rhs).to eq(['a', p_bc, 'd', 'e', p_bc, 'e'])
      expect(p_bc.refcount).to eq(2)
      expect(p_bc.to_string).to eq(p_bc_before)
    end


    it 'should replace a starting two-symbol sequence' do
      %w(b c d e b c e).each { |symb| subject.append_symbol(symb) }
      subject.reduce_step(p_bc)

      expect(subject.rhs.size).to eq(5)
      expect(subject.rhs).to eq([p_bc, 'd', 'e', p_bc, 'e'])
      expect(p_bc.refcount).to eq(2)
    end


    it 'should replace an ending two-symbol sequence' do
      %w(a b c d e b c).each { |symb| subject.append_symbol(symb) }
      subject.reduce_step(p_bc)

      expect(subject.rhs.size).to eq(5)
      expect(subject.rhs).to eq(['a', p_bc, 'd', 'e', p_bc])
      expect(p_bc.refcount).to eq(2)
    end

    it 'should replace two consecutive two-symbol sequences' do
      %w(a b c b c d).each { |symb| subject.append_symbol(symb) }
      subject.reduce_step(p_bc)

      expect(subject.rhs.size).to eq(4)
      expect(subject.rhs).to eq(['a', p_bc, p_bc, 'd'])
      expect(p_bc.refcount).to eq(2)
    end
  end # context

  context 'Replacing a production occurrence by its rhs:' do
    it 'should have not effect on empty production' do
      subject.derive_step(p_bc)
      expect(subject.rhs).to be_empty
    end

    it 'should replace a production at the start' do
      [p_bc, 'd'].each { |symb| subject.append_symbol(symb) }
      expect(p_bc.refcount).to eq(1)

      subject.derive_step(p_bc)
      expect(subject.rhs.size).to eq(3)
      expect(subject.rhs).to eq(%w(b c d))
      expect(p_bc.refcount).to eq(0)
    end


    it 'should replace a production at the end' do
      ['d', p_bc].each { |symb| subject.append_symbol(symb) }
      expect(p_bc.refcount).to eq(1)
      subject.derive_step(p_bc)

      expect(subject.rhs.size).to eq(3)
      expect(subject.rhs).to eq(%w(d b c))
      expect(p_bc.refcount).to eq(0)
    end

    it 'should replace a production as sole symbol' do
      subject.append_symbol(p_bc)
      subject.derive_step(p_bc)

      expect(subject.rhs.size).to eq(2)
      expect(subject.rhs).to eq(%w(b c))
    end

    it 'should replace a production in the middle' do
      ['a', p_bc, 'd'].each { |symb| subject.append_symbol(symb) }
      subject.derive_step(p_bc)

      expect(subject.rhs.size).to eq(4)
      expect(subject.rhs).to eq(%w(a b c d))
    end
  end # context

  context 'Visiting:' do
    it 'should accept a visitor when its rhs is empty' do
      # Use a mock visitor
      fake = double('fake_visitor')

      # Empty production: visitor will receive a start and end visit messages
      expect(fake).to receive(:start_visit_production).once.ordered
      expect(fake).to receive(:start_visit_rhs).once.ordered
      expect(fake).to receive(:end_visit_rhs).once.ordered
      expect(fake).to receive(:end_visit_production).once.ordered

      expect { subject.accept(fake) }.not_to raise_error
    end

    it 'should accept a visitor when rhs consists of terminals only' do
      # Use a mock visitor
      fake = double('fake_visitor')
      expect(fake).to receive(:start_visit_production).once.ordered
      expect(fake).to receive(:start_visit_rhs).once.ordered
      expect(fake).to receive(:visit_terminal).with('b').ordered
      expect(fake).to receive(:visit_terminal).with('c').ordered
      expect(fake).to receive(:end_visit_rhs).once.ordered
      expect(fake).to receive(:end_visit_production).once.ordered

      expect { p_bc.accept(fake) }.not_to raise_error
    end

    it 'should accept a visitor when rhs consists of non-terminals' do
      # Add two production references (=non-terminals) to RHS of subject
      subject.append_symbol(p_a)
      subject.append_symbol(p_bc)

      fake = double('fake_visitor')
      expect(fake).to receive(:start_visit_production).once.ordered
      expect(fake).to receive(:start_visit_rhs).once.ordered
      expect(fake).to receive(:visit_prod_ref).with(p_a).ordered
      expect(fake).to receive(:visit_prod_ref).with(p_bc).ordered
      expect(fake).to receive(:end_visit_rhs).once.ordered
      expect(fake).to receive(:end_visit_production).once.ordered

      expect { subject.accept(fake) }.not_to raise_error
    end
  end # context
end # describe
end # module

# End of file

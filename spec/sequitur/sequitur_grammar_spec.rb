# frozen_string_literal: true

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/sequitur/sequitur_grammar'

module Sequitur # Re-open the module to get rid of qualified names
describe SequiturGrammar do
  # Factory method. Returns an empty enumerator (
  # i.e. without elements to iterate)
  def empty_enum
    return [].to_enum
  end

  context 'Creation from an enumeration of tokens:' do
    it 'could be created with an empty enumerator' do
      expect { SequiturGrammar.new(empty_enum) }.not_to raise_error

      # Creation
      instance = SequiturGrammar.new(empty_enum)

      # Initialization
      expect(instance.productions.size).to eq(1)
      expect(instance.start).to eq(instance.productions.first)
      expect(instance.start).to be_empty
    end

    it 'could be created with single token' do
      # Creation
      instance = SequiturGrammar.new([:a].to_enum)

      # Initialization
      expect(instance.productions.size).to eq(1)
      expect(instance.start).to eq(instance.productions.first)
      expect(instance.start.rhs).to eq([:a])
    end

    it 'could be created with multiple unique tokens' do
      # Creation
      instance = SequiturGrammar.new(%i[a b c d].to_enum)

      # Initialization
      expect(instance.productions.size).to eq(1)
      expect(instance.start).to eq(instance.productions.first)
      expect(instance.start.rhs).to eq(%i[a b c d])
    end

    it 'could be created with a repeating digram' do
      instance = SequiturGrammar.new(%i[a b a b].to_enum)

      # Expectations:
      # S : A A.
      # A : a b.
      expect(instance.productions.size).to eq(2)
      p_a = instance.productions[1]
      expect(p_a.rhs).to eq(%i[a b])
      expect(instance.start.rhs).to eq([p_a, p_a])
    end

    it 'should enforce the utility rule' do
      instance = SequiturGrammar.new(%i[a b c a b c].to_enum)

      # Expectations without utility rule:
      # S : B B.
      # A : a b.
      # B : A c.

      # Expectations with utility rule:
      # S : A A.
      # A : a b c.
      expect(instance.productions.size).to eq(2)
      p_a = instance.productions.last
      expect(p_a.rhs).to eq(%i[a b c])
      expect(instance.start.rhs).to eq([p_a, p_a])
    end

    it 'should cope with a pattern that caused an exception' do
      input = 'aaac' # This sequence raised an exception

      # Creation
      expect { SequiturGrammar.new(input.chars) }.not_to raise_error
    end


    it 'should cope with the example from presentation' do
      input = 'bbebeebebebbebee'

      # Creation
      instance = SequiturGrammar.new(input.chars)

      # Expectations:
      # S: P3 P2 P3
      # P1: b e
      # P2: P1 P1
      # P3: b P2 e
      expect(instance.productions.size).to eq(4)
      (p1, p2, p3) = instance.productions[1..3]
      expect(instance.start.rhs).to eq([p3, p2, p3])
      expect(p1.rhs).to eq(%w(b e))
      expect(p2.rhs).to eq([p1, p1])
      expect(p3.rhs).to eq(['b', p2, 'e'])
    end

    it 'should work with strings instead of single char input tokens' do
      # Raw input is sequence of chars
      raw_input = 'bbebeebebebbebee'

      # Convert them into multichar strings
      input = raw_input.chars.map do |ch|
        'letter_' + ch
      end

      # Creation
      instance = SequiturGrammar.new(input.to_enum)

      # Expectations:
      # S: P3 P2 P3
      # P1: b e
      # P2: P1 P1
      # P3: b P2 e
      expect(instance.productions.size).to eq(4)
      (p1, p2, p3) = instance.productions[1..3]
      expect(instance.start.rhs).to eq([p3, p2, p3])
      expect(p1.rhs).to eq(%w(letter_b letter_e))
      expect(p2.rhs).to eq([p1, p1])
      expect(p3.rhs).to eq(['letter_b', p2, 'letter_e'])
    end

    it 'should work with Symbol instead of single char input tokens' do
      # Raw input is sequence of single characters
      raw_input = 'bbebeebebebbebee'

      # Convert them into symbols
      input = raw_input.chars.map(&:to_sym)

      # Creation
      instance = SequiturGrammar.new(input.to_enum)

      # Expectations:
      # S: P3 P2 P3
      # P1: b e
      # P2: P1 P1
      # P3: b P2 e
      expect(instance.productions.size).to eq(4)
      (p1, p2, p3) = instance.productions[1..3]
      expect(instance.start.rhs).to eq([p3, p2, p3])
      expect(p1.rhs).to eq(%i[b e])
      expect(p2.rhs).to eq([p1, p1])
      expect(p3.rhs).to eq([:b, p2, :e])
    end


    it 'should work with integer values as input tokens' do
      # Raw input is sequence of hex digits
      raw_input = 'bbebeebebebbebee'

      # Convert them into Fixnums
      input = raw_input.chars.map { |ch| ch.to_i(16) }

      # Creation
      instance = SequiturGrammar.new(input.to_enum)

      # Expectations:
      # S: P3 P2 P3
      # P1: b e
      # P2: P1 P1
      # P3: b P2 e
      expect(instance.productions.size).to eq(4)
      (p1, p2, p3) = instance.productions[1..3]
      expect(instance.start.rhs).to eq([p3, p2, p3])
      expect(p1.rhs).to eq([0xb, 0xe])
      expect(p2.rhs).to eq([p1, p1])
      expect(p3.rhs).to eq([0xb, p2, 0xe])
    end

    it 'should cope with the example from sequitur.info website' do
      input = 'abcabdabcabd'
      instance = SequiturGrammar.new(input.chars)

      # Expectations:
      # 0 → 2 2
      # 1 → a b
      # 2 → 1 c 1 d

      expect(instance.productions.size).to eq(3)
      (p1, p2) = instance.productions[1..2]
      expect(instance.start.rhs).to eq([p2, p2])
      expect(p1.rhs).to eq(%w(a b))
      expect(p2.rhs).to eq([p1, 'c', p1, 'd'])
    end

    it "should cope with the example from Salomon's book" do
      input = 'abcdbcabcdbc'
      instance = SequiturGrammar.new(input.chars)

      # Expectations:
      # S → CC
      # A → bc
      # C → aAdA

      expect(instance.productions.size).to eq(3)
      (p_a, p_c) = instance.productions[1..2]
      expect(instance.start.rhs).to eq([p_c, p_c])
      expect(p_a.rhs).to eq(%w(b c))
      expect(p_c.rhs).to eq(['a', p_a, 'd', p_a])
    end

    it 'should cope with the "porridge" example from sequitur.info' do
      # Another example from sequitur.info website
      input = <<-SNIPPET
pease porridge hot,
pease porridge cold,
pease porridge in the pot,
nine days old.

some like it hot,
some like it cold,
some like it in the pot,
nine days old.
SNIPPET
      # Expectations (sequitur.org)
      # 0 → 1 2 3 4 3 5 ↵ 6 2 7 4 7 5
      # 1 → p e a s 8 r r i d g 9                         pease_porridge_
      # 2 → h o t                                         hot
      # 3 → 10 1                                          ,↵pease_porridge_
      # 4 → c 11                                          cold
      # 5 → 12 _ t h 8 t 10 n 12 9 d a y s _ 11 . ↵
      #   in_the_pot,↵nine_days_old.↵
      # 6 → s o m 9 l i k 9 i t _                         some_like_it_
      # 7 → 10 6                                          ,↵some_like_it_
      # 8 → 9 p o                                         e_po
      # 9 → e _                                           e_
      # 10 → , ↵                                          ,↵
      # 11 → o l d                                        old
      # 12 → i n                                          in

      instance = SequiturGrammar.new(input.chars)
      expect(instance.productions.size).to eq(13)
      p0 = instance.start
      expect(p0.rhs.size).to eq(13)

      (p1, p2, p3, p4, p5, p6, p7, p8, p9) = instance.productions[1..9]
      (p10, p11, p12) = instance.productions[10..12]

      # Note: the productions aren't sorted the same way as
      # the sequitur.info implementation.
      p0_expectation = [
        p2, p8, p3, p10, p3, p12, "\n",
        p9, p8, p11, p10, p11, p12
      ]
      expect(p0.rhs).to eq(p0_expectation) # Rule 0 above
      expect(p1.rhs).to eq(['e', ' ']) # Rule 9 above
      expect(p2.rhs).to eq([%w(p e a s), p4, %w(r r i d g), p1].flatten) # R1
      expect(p3.rhs).to eq([p5, p2]) # Rule 3 above
      expect(p4.rhs).to eq([p1, 'p', 'o']) # Rule 8 above
      expect(p5.rhs).to eq([',', "\n"]) # Rule 10 above
      expect(p6.rhs).to eq(%w(i n)) # Rule 12 above
      expect(p7.rhs).to eq(%w(o l d)) # Rule 11 above
      expect(p8.rhs).to eq(%w(h o t)) # Rule 2 above
      p9_expectation = [%w(s o m), p1, %w(l i k), p1, 'i', 't', ' '].flatten
      expect(p9.rhs).to eq(p9_expectation) # Rule 6 above
      expect(p10.rhs).to eq(['c', p7]) # Rule 4 above
      expect(p11.rhs).to eq([p5, p9]) # Rule 7 above
      p12_expectation = [
        p6, ' ', 't', 'h', p4, 't', p5, 'n', p6, p1,
        %w(d a y s), ' ', p7, '.', "\n"
      ].flatten
      expect(p12.rhs).to eq(p12_expectation) # Rule 5 above
    end

    it 'should work with a sequence of Ruby Symbols' do
      input = 'abcabdabcabd'.chars.map(&:to_sym)
      instance = SequiturGrammar.new(input.to_enum)

      # Expectations:
      # start : P2 P2.
      # P1 : :a :b
      # P2 : P1 :c P1 :d.

      expect(instance.productions.size).to eq(3)
      (p1, p2) = instance.productions[1..2]
      expect(instance.start.rhs).to eq([p2, p2])
      expect(p1.rhs).to eq(%i[a b])
      expect(p2.rhs).to eq([p1, :c, p1, :d])
    end
  end # context

  context 'Generating a text representation of itself:' do
    it 'should generate a text representation when empty' do
      instance = SequiturGrammar.new(empty_enum)
      expectation = "#{instance.start.object_id} : ."

      expect(instance.to_string).to eq(expectation)
    end

    it 'should generate a text representation of a simple production' do
      instance = SequiturGrammar.new([:a].to_enum)
      expectation = "#{instance.start.object_id} : a."
      expect(instance.to_string).to eq(expectation)
    end
  end # context
end # describe
end # module

# End of file

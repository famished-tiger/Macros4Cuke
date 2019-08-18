# frozen_string_literal: true

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/sequitur/grammar_visitor'

module Sequitur # Re-open the module to get rid of qualified names
describe GrammarVisitor do
  # Use a double(mock) as a grammar
  let(:fake) { double('fake-grammar') }

  context 'Standard creation & initialization:' do
    # Default instantiation rule
    subject { GrammarVisitor.new(fake) }

    it 'should be initialized with a grammar argument' do
      expect { GrammarVisitor.new(fake) }.not_to raise_error
    end

    it 'should know the grammar to visit' do
      expect(subject.grammar).to eq(fake)
    end

    it "shouldn't have subscribers at start" do
      expect(subject.subscribers).to be_empty
    end
  end # context


  context 'Subscribing:' do
    # Default instantiation rule
    subject { GrammarVisitor.new(fake) }

    let(:listener1) { double('fake-formatter1') }
    let(:listener2) { double('fake-formatter2') }

    it 'should allow subscriptions' do
      subject.subscribe(listener1)
      expect(subject.subscribers.size).to eq(1)
      expect(subject.subscribers).to eq([listener1])

      subject.subscribe(listener2)
      expect(subject.subscribers.size).to eq(2)
      expect(subject.subscribers).to eq([listener1, listener2])
    end

    it 'should allow un-subcriptions' do
      subject.subscribe(listener1)
      subject.subscribe(listener2)
      subject.unsubscribe(listener2)
      expect(subject.subscribers.size).to eq(1)
      expect(subject.subscribers).to eq([listener1])
      subject.unsubscribe(listener1)
      expect(subject.subscribers).to be_empty
    end
  end # context

  context 'Notifying visit events:' do
    # Default instantiation rule
    subject do
      instance = GrammarVisitor.new(fake)
      instance.subscribe(listener1)
      instance
    end

    # Use doubles/mocks to simulate formatters
    let(:listener1) { double('fake-formatter1') }
    let(:listener2) { double('fake-formatter2') }
    let(:mock_production) { double('fake-production') }

    it 'should react to the start_visit_grammar message' do
      # Notify subscribers when start the visit of the grammar
      expect(listener1).to receive(:before_grammar).with(fake)

      subject.start_visit_grammar(fake)
    end
  end # context
end # describe
end # module

# End of file

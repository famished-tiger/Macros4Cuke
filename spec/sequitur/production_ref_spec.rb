# frozen_string_literal: true

require_relative '../spec_helper'

# Load the class under test
require_relative '../../lib/sequitur/production'
require_relative '../../lib/sequitur/production_ref'

module Sequitur # Re-open the module to get rid of qualified names
describe ProductionRef do
  let(:target) { Production.new }
  let(:another_target) { Production.new }

  subject { ProductionRef.new(target) }

  context 'Creation & initialization:' do
    it 'should be created with a production argument' do
      expect { ProductionRef.new(target) }.not_to raise_error
      expect(target.refcount).to eq(1)
    end

    it 'should clone with reference count incrementing' do
      expect(target.refcount).to eq(0)
      expect(subject.production.refcount).to eq(1)
      klone = subject.clone
      expect(klone.production.refcount).to eq(2)
      duplicate = subject.dup
      expect(duplicate.production.refcount).to eq(3)
    end

    it 'should know its referenced production' do
      instance = ProductionRef.new(target)
      expect(instance.production).to eq(target)
    end
  end # context

  context 'Provided services:' do
    it 'should render its referenced production' do
      expect(subject.to_s).to eq(target.object_id.to_s)
    end

    it 'should unbind itself from its production' do
      expect(target.refcount).to eq(0)
      expect(subject).not_to be_unbound
      expect(target.refcount).to eq(1)
      subject.unbind
      expect(target.refcount).to eq(0)
      expect(subject.production).to be_nil
      expect(subject).to be_unbound
    end

    it 'should bind to a production' do
      expect(target.refcount).to eq(0)

      expect(subject).not_to be_unbound
      expect(target.refcount).to eq(1)

      # Case: bind again to same production
      expect { subject.bind_to(target) }.not_to raise_error
      expect(target.refcount).to eq(1)

      # Case: bind to another production
      expect(another_target.refcount).to eq(0)
      subject.bind_to(another_target)
      expect(target.refcount).to eq(0)
      expect(another_target.refcount).to eq(1)
    end

    it 'should complain when binding to something else than production' do
      subject.bind_to(target)
      msg = 'Illegal production type String'
      expect { subject.bind_to('WRONG') }.to raise_error(StandardError, msg)
    end

    it 'should compare to other production (reference)' do
      same = ProductionRef.new(target)
      expect(subject).to eq(subject) # Strict identity
      expect(subject).to eq(same) # 2 references pointing to same production
      expect(subject).to eq(target)
    end

    it 'should return the hash value of its production' do
      expectation = target.hash
      expect(subject.hash).to eq(expectation)
    end

    it 'should complain when requested for a hash and unbound' do
      subject.unbind
      expect { subject.hash }.to raise_error(StandardError)
    end

    it 'should accept a visitor' do
      # Use a mock visitor
      fake = double('fake_visitor')

      # Visitor should receive a visit message
      expect(fake).to receive(:visit_prod_ref).once
      expect { subject.accept(fake) }.not_to raise_error
    end
  end # context
end # describe
end # module

# End of file

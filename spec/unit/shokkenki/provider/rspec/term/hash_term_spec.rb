require_relative '../../../../spec_helper'
require 'shokkenki/provider/rspec/term/hash_term'

describe Shokkenki::Provider::RSpec::Term::HashTerm do
  class HashTermStub
    include Shokkenki::Provider::RSpec::Term::HashTerm
  end

  subject { HashTermStub.new }

  context 'verifying within a context' do
    let(:example_context) { double('example context').as_null_object }

    let(:term) { double('term').as_null_object }

    before do
      allow(example_context).to receive(:describe) do |&block|
        example_context.instance_eval &block
      end
      allow(subject).to receive(:value).and_return(:value_name => term)
      allow(example_context).to receive(:before) do |&block|
        example_context.instance_eval &block
      end
    end

    context 'when there are actual values' do
      before do
        example_context.instance_eval { @actual_values = [{'value_name' => 'value1'}] }
        subject.verify_within example_context
      end

      it 'describes each key' do
        expect(example_context).to have_received(:describe).with(:value_name)
      end

      it 'verifies each term within the current context' do
        expect(term).to have_received(:verify_within).with(example_context)
      end

      it 'translates actual values by selecting values that match the current key indifferently' do
        expect(example_context.instance_variable_get(:@actual_values)).to eq(['value1'])
      end
    end

    context 'when a value could not be extracted' do
      before do
        example_context.instance_eval { @actual_values = [{:something_else => 'value1'}, {:x => 'y'}] }
      end

      it "fails with a message" do
        expect{subject.verify_within example_context}.to raise_error(%Q{No value for "value_name" found in {:something_else=>"value1"}, {:x=>"y"}})
      end
    end

  end
end
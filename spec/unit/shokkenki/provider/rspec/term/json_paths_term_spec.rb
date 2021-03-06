require_relative '../../../../spec_helper'
require 'json'
require 'shokkenki/provider/rspec/term/json_paths_term'

describe Shokkenki::Provider::RSpec::Term::JsonPathsTerm do
  class JsonPathsTermStub
    include Shokkenki::Provider::RSpec::Term::JsonPathsTerm
  end

  subject { JsonPathsTermStub.new }

  context 'verifying within a context' do
    let(:example_context) { double('example context').as_null_object }
    let(:inner_context) { double('inner context').as_null_object }

    let(:term) { double('term').as_null_object }

    before do
      allow(example_context).to receive(:describe) do |&block|
        inner_context.instance_eval &block
      end
      allow(inner_context).to receive(:describe) do |&block|
        inner_context.instance_eval &block
      end
      allow(subject).to receive(:value).and_return(:'$.first.second.third' => term)
      allow(inner_context).to receive(:before).with(:each) do |&block|
        inner_context.instance_eval &block
      end
    end

    context 'when matching values are found' do

      let(:actual_values) do

      end

      before do
        inner_context.instance_eval do
          @actual_values = [{:first => {:second => {:third => 'value1'} } }.to_json]
        end

        subject.verify_within example_context
      end

      it "creates a context of 'json'" do
        expect(example_context).to have_received(:describe).with('json')
      end

      it "creates an inner context for each JSON path'" do
        expect(inner_context).to have_received(:describe).with(:'$.first.second.third')
      end

      it 'verifies each term within the inner context' do
        expect(term).to have_received(:verify_within).with(inner_context)
      end

      it 'translates actual value to the collection of values found at the given JSON path before each example runs' do
        expect(inner_context.instance_variable_get(:@actual_values)).to eq(['value1'])
      end
    end

    context 'when no actual values were found' do

      before do
        inner_context.instance_eval do
          @actual_values = [%Q{{"x":"y"}}, %Q{{"a":"b"}}]
        end
      end

      it 'fails with a message mentioning the path and actual values' do
        expect{subject.verify_within example_context}.to raise_error(%Q{Path "$.first.second.third" not found in JSON {"x":"y"}, {"a":"b"}})
      end
    end

    context 'when parsing of the actual JSON fails' do
      before do
        inner_context.instance_eval do
          @actual_values = [%Q{{"x":"y"}}, %Q{{"a":"b"}}]
        end

        allow(JsonPath).to receive(:on).and_raise("Original error")
      end

      it 'fails with a message detailing the failure and all of the JSON content' do
        expect{subject.verify_within example_context}.to raise_error('Original error in JSON {"x":"y"}, {"a":"b"}')
      end
    end
  end
end
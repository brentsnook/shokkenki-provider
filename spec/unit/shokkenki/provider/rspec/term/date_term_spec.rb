require_relative '../../../../spec_helper'
require 'shokkenki/provider/rspec/term/date_term'

describe Shokkenki::Provider::RSpec::Term::DateTerm do
  class DateTermStub
    include Shokkenki::Provider::RSpec::Term::DateTerm
  end

  subject { DateTermStub.new }

  context 'verifying within a context' do
    let(:example_context) do
      double('example context',
        :expect => expectation,
        :match => matcher
      ).as_null_object
    end

    let(:matcher) { double 'matcher' }
    let(:expectation) { double('expectation', :to => '') }

    before do
      example_context.instance_eval { @actual_values = ['2014-03-02'] }
      allow(subject).to receive(:value).and_return(Date.parse('2014-03-02'))
      allow(example_context).to receive(:it) do |&block|
        example_context.instance_eval &block
      end

      subject.verify_within example_context
    end

    it 'names the assertion using the value of the term in ISO 8601 format' do
      expect(example_context).to have_received(:it).with('is on 2014-03-02')
    end

    it 'asserts that each of the actual values as a Date is the same as the term value' do
      expect(example_context).to have_received(:expect).with(Date.parse('2014-03-02'))
      expect(expectation).to have_received(:to)
      expect(example_context).to have_received(:eq).with(Date.parse('2014-03-02'))
    end

  end
end
require_relative '../../../../spec_helper'
require 'shokkenki/provider/rspec/term/date_time_term'

describe Shokkenki::Provider::RSpec::Term::DateTimeTerm do
  class DateTimeTermStub
    include Shokkenki::Provider::RSpec::Term::DateTimeTerm
  end

  subject { DateTimeTermStub.new }

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
      example_context.instance_eval { @actual_values = ['2001-02-03T04:05:06+07:00'] }
      allow(subject).to receive(:value).and_return(DateTime.parse('2001-02-03T04:05:06+07:00'))
      allow(example_context).to receive(:it) do |&block|
        example_context.instance_eval &block
      end

      subject.verify_within example_context
    end

    it 'names the assertion using the value of the term in ISO 8601 format' do
      expect(example_context).to have_received(:it).with('is at 2001-02-03T04:05:06+07:00')
    end

    it 'asserts that each of the actual values as a Date Time is the same as the term value' do
      expect(example_context).to have_received(:expect).with(DateTime.parse('2001-02-03T04:05:06+07:00'))
      expect(expectation).to have_received(:to)
      expect(example_context).to have_received(:eq).with(DateTime.parse('2001-02-03T04:05:06+07:00'))
    end

  end
end
require_relative '../../../spec_helper'

describe 'RSpec configuration' do

  let(:config) { double('RSpec configuration') }
  let(:load_config) { load 'shokkenki/provider/rspec/rspec_configuration.rb' }

  before do
    allow(::RSpec).to receive(:configure).and_yield(config)
  end

  context 'when the RSpec version supports backtrace inclusion patterns' do
    let(:patterns) { double('patterns').as_null_object }

    before do
      allow(config).to receive(:backtrace_inclusion_patterns).and_return patterns
      load_config
    end

    it 'includes shokkenki-provider lines in the backtrace' do
      expect(patterns).to have_received(:<<).with(/shokkenki\-provider/)
    end
  end

  context "when the RSpec version doesn't support backtrace inclusion patterns" do
    let(:patterns) { double('patterns').as_null_object }

    before do
      load_config
    end

    it "doesn't attempt to add any patterns for exclusion" do
      expect(patterns).to_not have_received(anything)
    end
  end
end
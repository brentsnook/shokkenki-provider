require_relative '../../../spec_helper'
require 'shokkenki/provider/configuration/session'
require 'shokkenki/provider/model/provider'

describe Shokkenki::Provider::Configuration::Session do

  class StubProviderSession
    include Shokkenki::Provider::Configuration::Session
    attr_accessor :ticket_location
    attr_reader :providers

    def initialize
      @providers = {}
    end
  end

  subject { StubProviderSession.new }

  context 'being configured' do
    before do
      allow(subject).to receive(:config_directive)
      subject.configure { config_directive }
    end

    it 'applies configuration' do
      expect(subject).to have_received(:config_directive)
    end
  end

  it 'allows ticket location to be specified' do
    subject.tickets 'location'
    expect(subject.ticket_location).to eq('location')
  end

  context 'defining a provider' do
    let(:provider) { double('provider configuration').as_null_object }

    before do
      allow(Shokkenki::Provider::Model::Provider).to receive(:new).and_return(provider)
      allow(subject).to receive(:add_provider)
    end

    context 'when a provider that already exists with that name' do
      let(:existing_provider) do
        double('existing provider configuration').as_null_object
      end

      before do
        subject.providers[:provider_name] = existing_provider
        subject.provider(:provider_name) { directive }
      end

      it 'configures the existing provider' do
        expect(existing_provider).to have_received(:directive)
      end
    end

    context 'with configuration directives' do
      before { subject.provider(:provider_name) { directive } }
      it 'creates a new provider with the given name' do
        expect(Shokkenki::Provider::Model::Provider).to have_received(:new).with(:provider_name)
      end

      it 'allows the provider to be configured' do
        expect(provider).to have_received(:directive)
      end

      it 'registers the provider' do
        expect(subject).to have_received(:add_provider).with(provider)
      end
    end

    context 'without any configuration directives' do
      before { subject.provider(:provider_name) }
      it "doesn't configure the provider" do
        expect(provider).to_not have_received(anything)
      end
    end
  end
end
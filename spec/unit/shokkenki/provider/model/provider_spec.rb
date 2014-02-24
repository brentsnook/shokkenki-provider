require_relative '../../../spec_helper'
require 'shokkenki/provider/model/provider'
require 'shokkenki/provider/model/fixture'

describe Shokkenki::Provider::Model::Provider do

  subject { Shokkenki::Provider::Model::Provider.new :name }

  context 'when created' do
    it 'has the given name' do
      expect(subject.name).to eq(:name)
    end
  end

  it 'is configurable' do
    expect(subject).to respond_to(:run)
  end

  context 'adding a fixture' do
    let(:block) { lambda {} }
    let(:fixture) { double 'fixture' }

    before do
      allow(Shokkenki::Provider::Model::Fixture).to(
        receive(:new).with(/pattern/, block).and_return fixture
      )
      subject.add_fixture /pattern/, block
    end

    it 'adds a fixture that will run for a matching name pattern' do
      expect(subject.fixtures).to eq([fixture])
    end
  end

  context 'establishing fixtures' do

    let(:first_fixture) { double(:first_fixture, :name => 'first fixture name').as_null_object }

    let(:second_fixture) { double(:second_fixture, :name => 'second fixture name').as_null_object }
    let(:required_fixture) { double(:required_fixture, :name => 'fixy') }

    before do
      subject.fixtures << first_fixture
      subject.fixtures << second_fixture
    end

    context 'when no fixtures match the required fixture' do

      before do
        allow(first_fixture).to receive(:matches?).with(required_fixture).and_return(false)
        allow(second_fixture).to receive(:matches?).with(required_fixture).and_return(false)
      end

      it 'fails with an error message' do
        expect{subject.establish [required_fixture]}.to raise_exception("No fixture found to match 'fixy': Did you define one in the provider configuration?")
      end
    end

    context 'when multiple fixtures match the required fixture' do
      before do
        allow(first_fixture).to receive(:matches?).with(required_fixture).and_return(true)
        allow(second_fixture).to receive(:matches?).with(required_fixture).and_return(true)
      end

      it 'fails with an error message mentioning the matched fixtures' do
        expect{subject.establish [required_fixture]}.to raise_exception("Multiple fixtures found to match 'fixy' (first fixture name, second fixture name): Do you need to make your fixture matchers stricter?")
      end
    end

    context 'when a single fixture matches the required fixture' do

      before do
        allow(first_fixture).to receive(:matches?).with(required_fixture).and_return(true)
        allow(second_fixture).to receive(:matches?).with(required_fixture).and_return(false)

        subject.establish [required_fixture]
      end

      it 'establishes the matching fixture' do
        expect(first_fixture).to have_received(:establish).with(required_fixture)
        expect(second_fixture).to_not have_received(:establish)
      end

    end
  end
end
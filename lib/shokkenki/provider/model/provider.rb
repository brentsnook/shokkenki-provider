require_relative '../configuration/provider'
require_relative 'fixture'

module Shokkenki
  module Provider
    module Model
      class Provider
        include Shokkenki::Provider::Configuration::Provider
        attr_reader :name, :fixtures
        attr_accessor :http_client

        def initialize name
          @name = name
          @fixtures = []
        end

        def add_fixture name_pattern, fixture
          @fixtures << Fixture.new(name_pattern, fixture)
        end

        def establish required_fixtures
          required_fixtures.each do |required_fixture|
            fixtures = @fixtures.select {|f| f.matches?(required_fixture) }
            assert_single_match! required_fixture, fixtures
            fixtures.first.establish required_fixture
          end
        end

        private

        def assert_single_match! required_fixture, fixtures
          if fixtures.length > 1
            fixture_names = fixtures.map(&:name).join(', ')
            raise "Multiple fixtures found to match '#{required_fixture.name}' (#{fixture_names}): Do you need to make your fixture matchers stricter?"
          end

          if fixtures.length == 0
            raise "No fixture found to match '#{required_fixture.name}': Did you define one in the provider configuration?"
          end
        end
      end
    end
  end
end
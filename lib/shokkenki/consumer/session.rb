require_relative '../shokkenki'
require_relative 'model/role'
require_relative 'model/provider'
require_relative 'model/patronage'
require_relative 'model/simplification'
require_relative 'dsl/session'
require_relative 'configuration/session'

module Shokkenki
  module Consumer
    class Session
      include Shokkenki::Consumer::Model::Simplification
      include Shokkenki::Consumer::DSL::Session
      include Shokkenki::Consumer::Configuration::Session

      attr_reader :current_consumer, :patronages, :configuration
      attr_accessor :ticket_location

      def initialize
        @consumers = {}
        @providers = {}
        @patronages = {}
      end

      def current_patronage_for provider_name
        consumer = @current_consumer
        provider = provider provider_name
        key = { consumer => provider }
        @patronages[key] ||= Shokkenki::Consumer::Model::Patronage.new :consumer => consumer, :provider => provider
      end

      def add_provider provider
        @providers[simplify(provider.name)] = provider
      end

      def provider name
        @providers[simplify(name)]
      end

      def consumer attributes
        name = simplify(attributes[:name])
        @consumers[name] ||= Shokkenki::Consumer::Model::Role.new attributes
      end

      def current_consumer= attributes
        @current_consumer = consumer attributes
      end

      def clear_interaction_stubs
        @providers.values.each { |p| p.clear_interaction_stubs }
      end

      def start
        @providers.values.each { |p| p.session_started }
      end

      def close
        @providers.values.each { |p| p.session_closed }
      end

      def print_tickets
        @patronages.values.collect(&:ticket).each do |ticket|
          ticket_path = File.expand_path(File.join(ticket_location, ticket.filename))
          File.open(ticket_path, 'w') { |file| file.write(ticket.to_json) }
        end
      end

    end
  end
end
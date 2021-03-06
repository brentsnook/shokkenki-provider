require_relative 'model/ticket'
require 'uri'
require 'open-uri'
require 'json'

module Shokkenki
  module Provider
    class TicketReader

      def read_from location
        location.respond_to?(:call) ? parse_tickets_json(location.call) : parse_from(location)
      end

      private

      def parse_from resource
        resource.match(URI::regexp) ? parse_from_remote(resource) : parse_from_local(resource)
      end

      def parse_from_remote resource
        open(resource) do |f|
          parse_tickets_json f.read
        end
      end

      def parse_tickets_json json
        JSON.parse(json, :symbolize_names => true).map { |h| Shokkenki::Provider::Model::Ticket.from_hash h }
      end

      def parse_from_local resource
        Dir.exists?(resource) ? parse_from_directory(resource) : parse_from_file(resource)
      end

      def parse_from_directory directory
        Dir.glob("#{directory}/**/*.json").map do |json_file|
          Shokkenki::Provider::Model::Ticket.from_json File.read(json_file)
        end
      end

      def parse_from_file file
        [Shokkenki::Provider::Model::Ticket.from_json(File.read(file))]
      end

    end
  end
end
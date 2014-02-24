module Shokkenki
  module Provider
    module Model
      class FixtureRequirement

        attr_reader :name, :arguments

        def initialize name, arguments
          @name = name
          @arguments = arguments
        end

        def self.from_hash hash
          new hash[:name], hash[:arguments]
        end
      end
    end
  end
end

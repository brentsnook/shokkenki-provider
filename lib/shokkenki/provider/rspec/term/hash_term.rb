require 'active_support/core_ext/hash/indifferent_access'

module Shokkenki
  module Provider
    module RSpec
      module Term
        module HashTerm
          def verify_within context
            value.each do |name, term|
              context.describe name do
                before { @actual_values = @actual_values.map{ |value| value.with_indifferent_access[name] } }

                term.verify_within self
              end
            end
          end
        end
      end
    end
  end
end
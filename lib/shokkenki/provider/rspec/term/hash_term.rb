require 'active_support/core_ext/hash/indifferent_access'

module Shokkenki
  module Provider
    module RSpec
      module Term
        module HashTerm
          def verify_within context
            value.each do |name, term|
              context.describe name do
                before do
                  @actual_values = @actual_values.map do |value|
                    extracted_value = value.with_indifferent_access[name]
                    self.send(:fail, %Q{No value for "#{name}" found in #{@actual_values.join(', ')}}) unless extracted_value
                    extracted_value
                  end
                end

                term.verify_within self
              end
            end
          end
        end
      end
    end
  end
end
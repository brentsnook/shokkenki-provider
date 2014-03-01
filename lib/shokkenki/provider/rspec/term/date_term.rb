module Shokkenki
  module Provider
    module RSpec
      module Term
        module DateTerm
          def verify_within context
            term_value = value
            context.it %Q{is on #{term_value.iso8601}} do
              @actual_values.each{ |value| expect(Date.parse(value.to_s)).to(eq(term_value)) }
            end
          end
        end
      end
    end
  end
end
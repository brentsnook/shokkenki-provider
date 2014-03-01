module Shokkenki
  module Provider
    module RSpec
      module Term
        module DateTimeTerm
          def verify_within context
            term_value = value
            context.it %Q{is at #{term_value.iso8601}} do
              @actual_values.each{ |value| expect(DateTime.parse(value.to_s)).to(eq(term_value)) }
            end
          end
        end
      end
    end
  end
end
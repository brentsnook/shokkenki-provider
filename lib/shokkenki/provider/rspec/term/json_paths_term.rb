require 'jsonpath'

module Shokkenki
  module Provider
    module RSpec
      module Term
        module JsonPathsTerm
          def verify_within context
            term = self
            context.describe 'json' do
              term.value.each do |json_path, term|
                describe json_path do

                  before(:each) do
                    @actual_values = @actual_values.map do |value|
                      JsonPath.on(value, json_path.to_s)
                    end.flatten

                    fail 'No matching values found' if @actual_values.empty?
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
end
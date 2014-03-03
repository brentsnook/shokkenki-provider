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
                    original_values = @actual_values
                    @actual_values = @actual_values.map do |value|
                      begin
                        JsonPath.on(value, json_path.to_s)
                      rescue Exception => e
                        self.send(:fail, "#{e} in JSON #{original_values.join(', ')}")
                      end
                    end.flatten

                    self.send(:fail, "Path \"#{json_path.to_s}\" not found in JSON #{original_values.join(', ')}") if @actual_values.empty?
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
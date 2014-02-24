require 'rspec'

RSpec.configure do |config|
  if config.respond_to?(:backtrace_inclusion_patterns)
    config.backtrace_inclusion_patterns << /shokkenki\-provider/
  end
end
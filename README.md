# Shokkenki Provider [![Build Status](https://secure.travis-ci.org/brentsnook/shokkenki-provider.png?branch=master)](http://travis-ci.org/brentsnook/shokkenki-provider) [![Code Climate](https://codeclimate.com/github/brentsnook/shokkenki-provider.png)](https://codeclimate.com/github/brentsnook/shokkenki-provider)

Allows providers to redeem (verify) [Shokkenki consumer-driven contracts](https://github.com/brentsnook/shokkenki).

Providers can redeem a ticket generated by [Shokkenki Consumer](https://github.com/brentsnook/shokkenki-consumer) to verify that they adhere to the contract specified by a consumer.

Redeeming a ticket involves generating and running a series of [RSpec](http://rspec.info) examples that test each interaction specified against an instance of the provider.

## Install

    gem install shokkenki-provider

## Provider Rspec

```ruby
require 'shokkenki/provider/rspec'

class Restaurant
  def call env
    env['PATH_INFO'] == '/order/ramen' ? [200, {}, ['a tasty morsel']] : raise('Unsupported path')
  end
end

Shokkenki.provider.configure do
  provider(:restaurant) { run Restaurant.new }
end

Shokkenki.provider.redeem_tickets
```

When run, this example will define and run an RSpec specification:

```
Hungry Man
  order for ramen
    body
      json value
        $.flavour
          matches /tasty/
```

## License

See [LICENSE.txt](LICENSE.txt).




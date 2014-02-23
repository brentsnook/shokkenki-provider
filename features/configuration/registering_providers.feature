Feature: Registering providers

  Providers must first be registered so that Shokkenki knows how to run them.

  Providers must be a [Rack application](http://rack.rubyforge.org/doc/SPEC.html).

  Scenario: Rack application
    Given a ticket named "tickets/consumer-provider.json" including the following interaction:
      """
      {
        "label": "greeting",
        "request": {
          "type": "hash",
          "value": {
            "path": {
              "type": "string",
              "value": "/greeting"
            },
            "method": {
              "type": "string",
              "value": "get"
            }
          }
        },
        "response": {
          "type": "hash",
          "value": {
            "status": {
              "type": "number",
              "value": 200
            }
          }
        }
      }
      """
    And a file named "spec/provider.spec" with:
      """
      provider = lambda do |env|
        [200, {}, ['']]
      end

      Shokkenki.provider.configure do
        provider :provider { run provider }
      end

      Shokkenki.provider.redeem_tickets
      """
    When I run `rspec --format documentation`
    Then all examples should pass
    And the output should contain:
      """
      Consumer
        greeting
          status
            is 200
      """
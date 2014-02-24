Feature: Redeeming a ticket

  Shokkenki redeems a ticket by generating RSpec examples to verify each of the response criteria found in each interaction. The examples are then excercised as part of a normal RSpec run.

  Each interaction is converted into a new RSpec context and each term into an example. This allows for a descriptive spec outlining each part of the response.

  Scenario: Generate an example for an interaction
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
            },
            "body": {
              "type": "json_paths",
              "value": {
                "$.message" : {
                  "type": "regexp",
                  "value": "hi"
                }
              }
            }
          }
        }
      }
      """
    And a file named "spec/provider.spec" with:
      """
      provider = lambda do |env|
        [200, {}, ['{"message":"hi there"}']]
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
          body
            json
              $.message
                matches /hi/
      """


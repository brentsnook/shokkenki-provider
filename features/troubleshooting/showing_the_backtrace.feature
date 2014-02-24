Feature: Showing the backtrace

  RSpec [cleans the backtrace](https://www.relishapp.com/rspec/rspec-core/docs/configuration/excluding-lines-from-the-backtrace) when an example fails. You can configure RSpec to [include all backtrace information](https://www.relishapp.com/rspec/rspec-core/docs/configuration/excluding-lines-from-the-backtrace#running-rspec-with-the---backtrace-option) if you need to do some troubleshooting.

  Scenario: Show entire backtrace
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
                  "value": "(?-mix:hi)"
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
        [200, {}, ['']]
      end

      Shokkenki.provider.configure do
        provider :provider { run provider }
      end

      Shokkenki.provider.redeem_tickets
      """
    When I run `rspec --backtrace spec/provider_spec.rb`
    Then the output should contain "rspec-core"
Feature: Filtering Shokkenki Provider Examples

  Shokkenki specs are just RSpec specs. All of the tools available for selectively running RSpec examples can be used.

  Provider examples can be filtered using standard RSpec [tag](https://www.relishapp.com/rspec/rspec-core/docs/command-line/tag-option) or [example](https://www.relishapp.com/rspec/rspec-core/docs/command-line/example-option) filtering. You can run just shokkenki provider examples or even run only examples to do with parts of the request like the status.

  You can use the [example option](https://www.relishapp.com/rspec/rspec-core/docs/command-line/example-option) to filter by Consumer, interaction label or status - see the documentation for details.  Shokkenki provider examples are generated on the fly so you can't [run individual examples using line number](https://www.relishapp.com/rspec/rspec-core/docs/command-line/line-number-option).

  Scenario: Run only Shokkenki provider examples using the --tag option
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

      describe 'Some other thing' do
        it 'does unrelated stuff' {}
      end
      """
    When I run `rspec --format documentation --tag shokkenki_provider`
    Then all examples should pass
    And the output should contain:
      """
      Consumer
        greeting
          status
            is 200
      """
    But the output should not contain:
      """
      does unrelated stuff
      """
  Scenario: Run only Shokkenki provider examples related to status
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
        [200, {}, ['{"message":"hi there"}']]
      end

      Shokkenki.provider.configure do
        provider :provider { run provider }
      end

      Shokkenki.provider.redeem_tickets

      describe 'Some other thing' do
        it 'does unrelated stuff' {}
      end
      """
    When I run `rspec --format documentation --tag shokkenki_provider --example status`
    Then all examples should pass
    And the output should contain:
      """
      Consumer
        greeting
          status
            is 200
      """
    But the output should not contain:
      """
          body
            json
      """
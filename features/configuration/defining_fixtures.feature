Feature: Defining fixtures

  A consumer specifies a fixture and supplies parameters but it is up to the provider to implement the fulfilment of each fixture.

  Each fixture required within a consumer ticket will need to be fulfilled. Fixtures are defined using a regex, allowing them to match non-exact specified fixture names. The [MatchData](http://www.ruby-doc.org/core-2.1.0/MatchData.html) instance is also made available to the fixture definition.

  Fixture definitions can be paired with blueprint tools like [Machinist](https://github.com/notahat/machinist) or [Factory Girl](https://github.com/thoughtbot/factory_girl) to establish data easily.

  You may also often need to refer to entity IDs in your paths. You can pass entity IDs through as part of the fixture arguments and ensure that the database is clean using [Database Cleaner](http://github.com/bmabey/database_cleaner) or some other method.

  Scenario: Define a provider fixture with standard arguments
    Given a ticket named "tickets/consumer-provider.json" including the following interaction:
      """
      {
        "label": "greeting",
        "request": {
          "type": "hash",
          "value": {
            "path": {
              "type": "string",
              "value": "/weather"
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
        },
        "fixtures": [
          {
            "name": "greeter exists",
            "arguments": {
              "mood": "happy"
            }
          }
        ]
      }
      """
    And a file named "spec/provider.spec" with:
      """
      provider = lambda do |env|
        [200, {}, ['']]
      end

      Shokkenki.provider.configure do
        provider :provider do
          run provider

          given /greeter exists/ do |args|
            puts "Mood is #{args[:arguments][:mood]}"
          end
        end
      end

      Shokkenki.provider.redeem_tickets
      """
    When I run `rspec --format documentation`
    Then all examples should pass
    And the output should contain:
      """
      Mood is happy
      """

  Scenario: Define a provider fixture and use regex matchdata
    Given a ticket named "tickets/consumer-provider.json" including the following interaction:
      """
      {
        "label": "greeting",
        "request": {
          "type": "hash",
          "value": {
            "path": {
              "type": "string",
              "value": "/weather"
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
        },
        "fixtures": [
          {
            "name": "greeter exists that is happy"
          }
        ]
      }
      """
    And a file named "spec/provider.spec" with:
      """
      provider = lambda do |env|
        [200, {}, ['']]
      end

      Shokkenki.provider.configure do
        provider :provider do
          run provider

          given /greeter exists that is (.*)/ do |args|
            puts "Mood is #{args[:match][1]}"
          end
        end
      end

      Shokkenki.provider.redeem_tickets
      """
    When I run `rspec --format documentation`
    Then all examples should pass
    And the output should contain:
      """
      Mood is happy
      """
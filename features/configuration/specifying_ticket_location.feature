Feature: Specifying ticket location

  Tickets will be read from the specified location. If no ticket location is supplied, the default location is the **tickets** directory.

  The specified location can be a number of different sources:

  - a single file
  - a directory - all JSON files under the directory will be read
  - a URI - a JSON representation of an array of tickets
  - a callable object (such as a [Proc](http://www.ruby-doc.org/core-2.1.0/Proc.html)) - the object will be called to return an array of `Shokkenki::Provider::Model::Ticket` objects

  Scenario: Tickets read from tickets directory by default
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

  Scenario: Single ticket location specified as a file path
    Given a ticket named "other_tickets/consumer-provider.json" including the following interaction:
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
        tickets 'other_tickets/consumer-provider.json'
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

  Scenario: Multiple ticket location specified as a directory path
    Given a ticket named "other_tickets/consumer-provider.json" including the following interaction:
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
        tickets 'other_tickets'
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

  Scenario: Multiple ticket JSON returned from a callable object
    Given a file named "spec/provider.spec" with:
      """
      require 'shokkenki/provider/model/ticket'

      provider = lambda do |env|
        [200, {}, ['']]
      end

      tickets_proc = lambda do
        %Q{
        [
          {
            "consumer": {
              "name": "consumer",
              "label": "Consumer"
            },
            "provider": {
              "name": "provider",
              "label": "Provider"
            },
            "interactions": [
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
                },
                "time": "2013-11-05T08:22:34Z"
              }
            ],
            "version": "0.0.0"
          }
        ]
        }
      end

      Shokkenki.provider.configure do
        tickets tickets_proc
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

  Scenario: Multiple ticket location specified as a URI
    Given a server is running at "http://localhost:8346" that will return the following ticket JSON:
      """
      [
        {
          "consumer": {
            "name": "consumer",
            "label": "Consumer"
          },
          "provider": {
            "name": "provider",
            "label": "Provider"
          },
          "interactions": [
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
              },
              "time": "2013-11-05T08:22:34Z"
            }
          ],
          "version": "0.0.0"
        }
      ]
      """
    And a file named "spec/provider.spec" with:
      """
      require 'shokkenki/provider/model/ticket'

      provider = lambda do |env|
        [200, {}, ['']]
      end

      Shokkenki.provider.configure do
        tickets "http://localhost:8346"
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
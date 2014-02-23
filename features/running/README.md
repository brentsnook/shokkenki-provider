Shokkenki provider specs are just [RSpec](http://www.relishapp.com/rspec/) specs.

Shokkenki works by generating RSpec contexts and examples from the interactions in each ticket. This means that all of the tools available for running RSpec specs can be easily used to run Shokkenki provider specs.

Just set up RSpec as normal and create a spec file that configures providers and redeems tickets. When the spec is evaluated, Shokkenki will define all of the necessary contexts and examples.
# encoding: utf-8

# Use configuration values that are automatically loaded from the config
#   hash found in: config/hello_config.rb
#
# boot: ruby hello_config.rb -sv
# test: curl -v -H 'Accept: application/json' 0.0.0.0:9000

require 'goliath'
require 'yajl'

class HelloConfig < Goliath::API
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Validation::RequestMethod, %w(GET)

  def response(env)
    [200, {}, { message: "Hello, #{hello}!" }]
  end
end

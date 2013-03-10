# encoding: utf-8

# Use configuration values that are automatically loaded from the config
#   hash found in: config/hello_config.rb
#   
# Imports additional config vars from: config/shared.rb
#   Useful for sharing config data between endpoints.
#
# boot: ruby hello_config_shared.rb -sv
# test: curl -v -H 'Accept: application/json' 0.0.0.0:9000

require 'goliath'
require 'yajl'

class HelloConfigShared < Goliath::API
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Validation::RequestMethod, %w(GET)

  def response(env)
    [200, {}, { message: "Hello, #{hello} #{year}!" }]
  end
end

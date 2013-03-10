# encoding: utf-8

# Automatically render your response as json, but only if the client
#   asks for json.
#
# boot: ruby hello_json.rb -sv
# test: curl -v -H 'Accept: application/json' 0.0.0.0:9000
#       curl -v 0.0.0.0:9000

require 'goliath'
require 'yajl'

class HelloJson < Goliath::API
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Formatters::JSON

  def response(env)
    [200, {}, { message: "Hello SXSW" }]
  end
end

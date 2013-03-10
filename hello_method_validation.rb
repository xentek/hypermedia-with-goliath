# encoding: utf-8

# Control which methods your endpoint responds to. If anything but a GET
#   request is made, the API will respond with HTTP 406 NOT ACCEPTABLE
#   error.
#
# boot: ruby hello_method_validation.rb -sv
# test: curl -v -H 'Accept: application/json' -X HEAD 0.0.0.0:9000
#       curl -v -H 'Accept: application/xml' -X HEAD 0.0.0.0:9000
#       curl -v -H 'Accept: text/html' -X HEAD 0.0.0.0:9000

require 'goliath'
require 'yajl'

class HelloMethodValidation < Goliath::API
  use Goliath::Rack::Render, ['json','xml','html']
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Formatters::XML
  use Goliath::Rack::Formatters::HTML
  use Goliath::Rack::Validation::RequestMethod, %w(GET)

  def response(env)
    [200, {}, { message: "Hello SXSW" }]
  end
end

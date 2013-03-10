# Gzip your responses to save bandwidth
#
# boot: ruby hello_gzip.rb -sv
# test: curl -v -H 'Accept: application/json' -H 'Accept-Encoding: gzip,deflate' --compressed 0.0.0.0:9000

require 'rack/deflater'
require 'goliath'
require 'yajl'

class HelloGzip < Goliath::API
  use ::Rack::Deflater
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Validation::RequestMethod, %w(GET)

  def response(env)
    [200, {}, { message: "Hello, #{hello} #{year}!" }]
  end
end

# encoding: utf-8

# Let's take some input from our users via a query string or body
#  paramater.
#
# boot: ruby hello_post.rb -sv
# test: curl -v -H 'Accept: application/json' -X GET "0.0.0.0:9000?name=xentek"
#       curl -v -H 'Accept: application/json' -X POST -d name=xentek 0.0.0.0:9000

require 'goliath'
require 'yajl'

class HelloPost < Goliath::API
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Validation::RequestMethod, %w(GET POST)
  use Goliath::Rack::Params

  def response(env)
    [200, {}, { message: "Hello, #{env.params['name']}!" }]
  end
end

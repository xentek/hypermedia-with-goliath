# encoding: utf-8

# Basic example of 404 error response. Raising the exception means we
#  don't return the other response we've crafted. 
#
# boot: ruby hello_not_found.rb -sv
# test: curl -v -H 'Accept: application/json' -d found=false 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' 0.0.0.0:9000

require 'goliath'

class HelloNotFound < Goliath::API
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Params

  def response(env)

    if params['found'] == 'false'
      logger.error "four oh four™"
      raise Goliath::Validation::NotFoundError
    else
      [200, {}, { message: "Hello SXSW" }]
    end

  end
end

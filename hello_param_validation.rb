# encoding: utf-8

# Validate various kinds of incoming paramaters.
#
# boot: ruby hello_param_validation.rb -sv
# test: curl -v -H 'Accept: application/json' -X POST -d "active=true&id=42&price=0.00&name=Goliath" 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' -X POST 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' -X POST -d active=false 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' -X POST -d "active=false&price=0.00" 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' -X POST -d "active=false&price=8.00&name=David" 0.0.0.0:9000

require 'goliath'
require 'yajl'

class HelloParamValidaiton < Goliath::API
  include Goliath::Rack::Types
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Validation::RequestMethod, %w(POST)
  use Goliath::Rack::Params
  use Goliath::Rack::Validation::Param, key: 'active', as: Boolean, message: "must be a boolean."
  use Goliath::Rack::Validation::Param, key: 'id',     as: Integer, optional: true, default: 0
  use Goliath::Rack::Validation::Param, key: 'price',  as: Float
  use Goliath::Rack::Validation::Param, key: 'name',   type: 'Name', message: "wasn't supplied, but is a required parameter."

  def response(env)
    results = { 
                id:     params['id'],
                name:   params['name'],
                price:  params['price'],
                active: params['active']
              }

    [200, {}, results]
  end
end

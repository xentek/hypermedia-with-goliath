# encoding: utf-8

#  Example of using Async funcationality to enforce Authentication.
#     Authentication isn't super secure, and should be replaced with
#     appropriate logic.
#
# boot: ruby hello_auth.rb -sv
# test: curl -v -H 'Accept: application/json' -X GET -d "name=xentek&token=a4d8ae68f4bcc793e490e8d8a47db609" 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' -X POST -d "name=xentek&token=a4d8ae68f4bcc793e490e8d8a47db609" 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' -X POST -d "name=xentek&token=D3ADBEEF" 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' -X POST -d "token=D3ADBEEF" 0.0.0.0:9000
#       curl -v -H 'Accept: application/json' -X POST -d "name=xentek" 0.0.0.0:9000       

require 'goliath'
require 'yajl'

class AuthMiddleware
  include Goliath::Rack::BarrierAroundware
  include Goliath::Validation
  
  class MissingTokenError < BadRequestError   ; end
  class InvalidTokenError < UnauthorizedError ; end

  def pre_process
    env.trace('pre_process_start')
    validate_token!

    unless authenticate_later?
      perform # yield execution
      do_some_work
      authorize_request!
    end

    env.trace('pre_process_finish')
    return Goliath::Connection::AsyncResponse
  end

  def post_process
    env.trace('post_process_start')
    
    if authenticate_now?
      authorize_request!
      do_some_work
    end

    env.trace('post_process_end')
    [status, headers, body]
  end

  def accept_response(handle, *args)
    env.trace("received_#{handle}")
    super(handle, *args)
  end
  
  protected 

  def do_some_work
    safely(env) { sleep 1 }
  end

  def token
    env.params['token']
  end

  def authenticate_later?
    (env['REQUEST_METHOD'] == 'GET') || (env['REQUEST_METHOD'] == 'HEAD')
  end

  def authenticate_now?
    !authenticate_later?
  end

  def validate_token!
    if token.to_s.empty?
      raise MissingTokenError
    end
  end

  def authorize_request!
    unless token == 'a4d8ae68f4bcc793e490e8d8a47db609'
      raise InvalidTokenError
    end
  end
end

class HelloAuth < Goliath::API
  use Goliath::Rack::Tracer, 'X-Tracer'
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Validation::RequestMethod, %w(GET HEAD POST)
  use Goliath::Rack::Params
  use Goliath::Rack::Validation::Param, key: 'name',   type: 'Name', message: "wasn't supplied, but is a required parameter."  
  use Goliath::Rack::BarrierAroundwareFactory, AuthMiddleware

  def response(env)
    [200, {}, { message: "Good News, Everybody! #{params['name']} is authenticated." }]
  end
end

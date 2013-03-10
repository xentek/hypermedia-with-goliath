# encoding: utf-8

require 'goliath'
require 'yajl'
require 'ostruct'
require 'em-synchrony'
require 'redis'
require 'redis/connection/synchrony'


class HelloRedis < Goliath::API
  use Goliath::Rack::Tracer, 'X-Tracer'
  use Goliath::Rack::Render, 'json'
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Validation::RequestMethod, %w(GET HEAD POST PUT DELETE OPTIONS)
  use Goliath::Rack::Params
  use Goliath::Rack::Validation::Param, key: 'id', type: 'ID', message: "is a required parameter."

  def response(env)
    status = 200
    headers = {}
    body = nil

    case env['REQUEST_METHOD']
    when 'GET'
      body = get_item(params['id'])
      raise Goliath::Validation::NotFoundError if body.nil?
    when 'HEAD'
      nil
    when 'POST'
      status = 201
      headers = {'Location' => "/item:#{params['id']}"}
      body = set_item(params['id'], value)
    when 'PUT'
      body = set_item(params['id'], Marshal.load(get_item(params['id'])).merge(params['value']))
    when 'DELETE'
      del_item(params['id'])
      status = 201
    when 'OPTIONS'
      headers = {
                  'Access-Control-Allow-Origin' => '*', 
                  'Access-Control-Allow-Methods' => 'GET,HEAD,POST,PUT,DELETE,OPTIONS'
                }
    end

    [status, headers, body]
  end

  private

  def get_item(key)
    redis.get(key)
  end
end

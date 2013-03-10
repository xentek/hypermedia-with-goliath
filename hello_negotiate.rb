# encoding: utf-8

# Use Content Negotation by specifiying, via the Accept header, which
#   media type you want to recieve back. The endpoint can happily return
#   json, xml, or html.
#
# boot: ruby hello_negotiate.rb -sv
# test: curl -v -H 'Accept: application/json' 0.0.0.0:9000
#       curl -v -H 'Accept: application/xml' 0.0.0.0:9000
#       curl -v -H 'Accept: text/html' 0.0.0.0:9000

require 'goliath'
require 'yajl'

class HelloNegotiate < Goliath::API
  use Goliath::Rack::Render, ['json','xml','html']
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Formatters::XML
  use Goliath::Rack::Formatters::HTML

  def response(env)
    [200, {}, { message: "Hello SXSW" }]
  end
end

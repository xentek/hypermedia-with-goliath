# encoding: utf-8

# The most simple example possible. Returns plain text resopnses.
#
# boot: ruby hello.rb -sv
# test: curl -v -H 'Accept: application/json' 0.0.0.0:9000

require 'goliath'

class Hello < Goliath::API
  def response(env)
    [200, {}, "Hello SXSW"]
  end
end

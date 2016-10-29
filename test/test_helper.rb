$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'ofx'
require 'dotenv'
require 'excon'
require 'byebug'
require 'minitest/autorun'

Dotenv.load

def fake_ofx_response
  File.read('test/fixtures/fake_ofx_response.xml').gsub(/\s/,'')
end
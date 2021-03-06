$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'

SimpleCov.start do
  add_filter '/test/' 
end

require 'ofx'
require 'dotenv'
require 'excon'
require 'byebug'
require 'minitest/autorun'
require "codeclimate-test-reporter"

CodeClimate::TestReporter.start

Dotenv.load

def fake_ofx_response
  File.read('test/fixtures/fake_ofx_response.xml').gsub(/\s/,'')
end
# frozen_string_literal: true
require 'test_helper'

module OFX::HTTPTest
  describe OFX::HTTP do
    before do
      @uri = "http://ofx.mybank.com"
      @http = OFX::HTTP.new(uri: @uri)
    end

    after do
      Dotenv.load
    end

    it 'has a uri' do
      assert_equal @uri, @http.uri
    end

    it 'raises an error if a uri is not supplied' do
      e = assert_raises OFX::Errors::URIMissing do
        ENV['OFX_URI'] = nil
        @http = OFX::HTTP.new
        @http.uri
      end
      assert_match(/You must specify the uri/, e.message)
    end

    it 'it has a default http header' do
      assert_equal "Content-Type: application/x-ofx\n" \
                   "Accept: */*, application/x-ofx",
                   @http.raw_headers
    end

    it 'it has a default http header' do
      assert_equal @http.headers, {
        'Content-Type' => 'application/x-ofx',
        'Accept' => '*/*, application/x-ofx'
      }
    end
  end
end

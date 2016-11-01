# frozen_string_literal: true
require 'test_helper'

module OFX::ParserTest
  describe OFX::Parser do
    before do
      @user = 'ofxuser'
      @password = 'password'
      @routing = 930291303
      @account = 48320949
      @inst = { org: 'fiorg', id: '32' }
      @app = { id: 'QBW', ver: '32' }

      @doc = OFX::Document.new(
        uri: "http://ofx.ofx",
        user: @user,
        password: @password,
        fi_org: @inst[:org],
        fi_fid: @inst[:id],
        routing: @routing,
        account: @account,
        app_id: @app[:id],
        app_ver: @app[:ver],
        start: Date.new(2015, 12, 28),
        end: Date.new(2016, 1, 28)
      )
      Excon.stub({}, body: fake_ofx_response)
      @request = Excon.new(
        @doc.send(:uri), 
        headers: @doc.send(:http).headers,
        body: @doc.send(:body),
        mock: true
      )
      @body = @request.post.body
      @parser = OFX::Parser.new(@body)
    end
    
    after do
      Excon.stubs.clear 
    end

    it "gets the document version" do
      assert_equal 103, @parser.ofx_version
    end

    it 'finds given elements and their contents' do
      assert_equal 19, @parser.transactions.length
    end

    it 'gets the balance and pending amounts' do
      assert_equal 17446.65, @parser.balance
      assert_equal (-92.09), @parser.pending
    end
  end
end
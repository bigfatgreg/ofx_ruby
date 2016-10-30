# frozen_string_literal: true
require 'test_helper'

module OFX::ParserTest
  describe OFX::Parser do
    before do
      @doc = OFX::Document.new
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
      assert_equal -92.09, @parser.pending
    end
  end
end
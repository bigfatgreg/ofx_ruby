# frozen_string_literal: true
require 'test_helper'

module OFX::Parser::TagTest
  describe OFX::Tag do
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
      @banktranlist = @parser.tag(:banktranlist) 
      @stmttrn = @parser.tag(:stmttrn)
      @trnamt = @parser.tag(:trnamt) 
      @sonrs = @parser.tag(:sonrs)
      @code = @parser.tag(:code)
      @ofx = @parser.tag(:ofx)
    end
    
    after do
      Excon.stubs.clear 
    end

    it 'inherits the parser body' do
      assert_equal @parser.body, @stmttrn.instance_variable_get(:@document)
    end

    it 'gets a count' do
      assert_equal 19, @stmttrn.list.count
      assert_equal 2, @code.list.count
      assert_equal 1, @ofx.list.count
    end

    it 'knows if a tag has a closing tag' do
      assert @stmttrn.has_closing?
      refute @code.has_closing?
      assert @ofx.has_closing?
    end

    it 'can print the tag name with brackets' do
      assert_equal "<STMTTRN>", @stmttrn.tag
      assert_equal "</STMTTRN>", @stmttrn.closing
      assert_equal "</OFX>", @ofx.closing
      refute @code.closing
    end

    it 'finds preceeding tags' do
      assert_equal 35, @stmttrn.preceeding_tags.count
    end

    it 'can determine parenthood' do
      refute @ofx.parent
      assert_equal YAML.dump(@banktranlist), YAML.dump(@stmttrn.parent)
    end

    it 'can find children' do
      refute @code.children
      assert_equal 2, @ofx.children.length
      assert_equal 21, @banktranlist.children.length
    end

    it 'determines the tag position' do
      assert_equal 732, @stmttrn.list[1].position
    end

    it 'gets tag contents' do
      assert_equal "<STATUS><CODE>0<SEVERITY>INFO<MESSAGE>SUCCESS</STATUS>" \
                   "<DTSERVER>20161017212050<LANGUAGE>ENG" \
                   "<DTPROFUP>20131012020000<FI><ORG>BNK" \
                   "<FID>2222</FI><SESSCOOKIE>HfX_v6PimqxaMVpu7NELNTOq",
                   @sonrs.contents

      assert_equal "<TRNTYPE>DEBIT<DTPOSTED>20161012190000<TRNAMT>-40.00" \
                   "<FITID>33333571011-40.00016101217552.21" \
                   "<NAME>CHECKCARD1011CODECLIMATE", 
                   @stmttrn.list[1].contents
      assert_equal "-6476.07", @trnamt.list[2].contents
   end
  end
end

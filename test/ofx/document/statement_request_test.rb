# frozen_string_literal: true
require 'test_helper'

class OFX::StatementRequestTest
  describe OFX::Document::StatementRequest do
    before do
      @routing = '4738924738'
      @account = '4832940392'
      @stmrq = OFX::Document::StatementRequest.new(
        name: :stmtrq,
        routing: @routing,
        account: @account,
        start: Date.new(2016, 9, 5),
        end: Date.new(2016, 10, 5)
      )
    end

    it 'produces a stmtrq aggregate' do
      assert_equal '<STMTRQ>' \
                     '<BANKACCTFROM>' \
                       '<BANKID>' + @routing + '</BANKID>' \
                       '<ACCTID>' + @account + '</ACCTID>' \
                       '<ACCTTYPE>CHECKING</ACCTTYPE>' \
                     '</BANKACCTFROM>' \
                     '<INCTRAN>' \
                       '<DTSTART>20160905000000</DTSTART>' \
                       '<DTEND>20161005000000</DTEND>' \
                       '<INCLUDE>Y</INCLUDE>' \
                     '</INCTRAN>' \
                   '</STMTRQ>',
                   @stmrq.send(:element_group)
    end
  end
end

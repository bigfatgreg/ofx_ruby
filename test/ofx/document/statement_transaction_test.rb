# frozen_string_literal: true
require 'test_helper'

class OFX::Document::StatementTransactionTest
  describe OFX::Document::StatementTransaction do
    before do
      @routing = '32131244'
      @account = '32134455'
      @trnuid = Time.now.to_i.to_s
      @stmttrnrq = OFX::Document::StatementTransaction.new(
        name: :stmttrnrq,
        routing: @routing,
        account: @account,
        start: Date.new(2016, 9, 5),
        end: Date.new(2016, 10, 5),
        id: @trnuid
      )
    end

    it 'produces a stmtrq aggregate' do
      assert_equal '<STMTTRNRQ>' \
                    '<TRNUID>' + @trnuid + '</TRNUID>' \
                    '<STMTRQ>' \
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
                     '</STMTRQ>' \
                   '</STMTTRNRQ>',
                   @stmttrnrq.send(:element_group)
    end
  end
end

# frozen_string_literal: true
require 'test_helper'

class OFX::BankMessageSetTest
  describe OFX::Document::BankMessageSet do
    before do
      @routing = '748329478'
      @account = '453115315'
      @trnuid = Time.now.to_i.to_s
      @bankmsgsrqv1 = OFX::Document::BankMessageSet.new(
        name: :bankmsgsrqv1,
        routing: @routing,
        account: @account,
        start: Date.new(2016, 9, 5),
        end: Date.new(2016, 10, 5),
        id: @trnuid
      )
    end

    it 'produces a stmtrq aggregate' do
      assert_equal '<BANKMSGSRQV1>' \
                     '<STMTTRNRQ>' \
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
                     '</STMTTRNRQ>' \
                   '</BANKMSGSRQV1>',
                   @bankmsgsrqv1.send(:element_group)
    end
  end
end

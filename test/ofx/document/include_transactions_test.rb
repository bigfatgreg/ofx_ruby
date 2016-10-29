# frozen_string_literal: true
require 'test_helper'

class OFX::IncludeTransactionsTest
  describe OFX::Document::IncludeTransactions do
    before do
      @inc_trans = OFX::Document::IncludeTransactions.new(name: :inctran)
    end

    it 'defaults to include? = true' do
      assert_equal 'Y', @inc_trans.include
      assert_equal true, @inc_trans.send(:include?)
    end

    it 'can initialize with include? = false' do
      @inc_trans = OFX::Document::IncludeTransactions.new(include: false)
      assert_equal 'N', @inc_trans.include
      assert_equal false, @inc_trans.send(:include?)
    end

    it 'accepts start and end dates' do
      @inc_trans = OFX::Document::IncludeTransactions.new(
        start: Date.new(2016, 9, 5),
        end: Date.new(2016, 10, 5)
      )
      assert_equal "20160905000000", @inc_trans.dtstart
      assert_equal "20161005000000", @inc_trans.dtend
    end

    it 'produces an inctrans aggregate' do
      assert_equal '<INCTRAN>' \
                     '<DTSTART>' + @inc_trans.dtstart + '</DTSTART>' \
                     '<DTEND>' + @inc_trans.dtend + '</DTEND>' \
                     '<INCLUDE>Y</INCLUDE>' \
                   '</INCTRAN>',
                   @inc_trans.send(:element_group)
    end
  end
end

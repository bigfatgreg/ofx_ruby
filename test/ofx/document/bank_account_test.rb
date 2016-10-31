# frozen_string_literal: true
require 'test_helper'

class OFX::BankAccountTest
  describe OFX::Document::BankAccount do
    before do
      @routing = '342145325'
      @account = '532154543'
      @bank_account = OFX::Document::BankAccount.new(
        name: :bankacctfrom,
        routing: @routing,
        account: @account
      )
    end

    after do
      @bank_account = nil
    end

    it 'has routing and account numbers' do
      assert_equal @routing, @bank_account.bankid
      assert_equal @routing, @bank_account.instance_variable_get('@routing')
      assert_equal @account, @bank_account.acctid
      assert_equal @account, @bank_account.instance_variable_get('@account')
    end

    it 'raises an error if the routing number is not supplied' do
      assert_raises OFX::Errors::RoutingMissing do
        @bank_account = OFX::Document::BankAccount.new
      end
    end

    it 'raises an error if the account number is not supplied' do
      assert_raises OFX::Errors::AccountMissing do
        @bank_account = OFX::Document::BankAccount.new(routing: @routing)
      end
    end

    it 'has a tag name' do
      assert_equal :bankacctfrom, @bank_account.send(:tag)
    end

    it 'has a default account type' do
      assert_equal 'CHECKING', @bank_account.send(:account_type)
      assert_equal 'CHECKING', @bank_account.accttype
    end

    it 'can initialize with an account type' do
      @bank_account = OFX::Document::BankAccount.new(
        routing: @routing,
        account: @account,
        type: :money_market
      )
      assert_equal 'MONEYMRKT', @bank_account.accttype
    end

    it 'raises an error if the account type is not available' do
      e = assert_raises OFX::Errors::AccountTypeNotAvailable do
        @bank_account = OFX::Document::BankAccount.new(
          routing: @routing,
          account: @account,
          type: :sherbet
        )
      end
      assert_match /choose :savings, :money_market, :credit_line/, e.message
    end

    it 'produces a bank account aggregate' do
      assert_equal @bank_account.send(:element_group),
                   '<BANKACCTFROM>' \
                     '<BANKID>' + @routing + '</BANKID>' \
                     '<ACCTID>' + @account + '</ACCTID>' \
                     '<ACCTTYPE>CHECKING</ACCTTYPE>' \
                   '</BANKACCTFROM>'
    end
  end
end

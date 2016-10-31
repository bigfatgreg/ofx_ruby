# frozen_string_literal: true
module OFX
  class Document
    class BankAccount < StatementRequest
      def initialize(options = {})
        @routing = options[:routing] || (raise Errors::RoutingMissing)
        @account = options[:account] || (raise Errors::AccountMissing)
        @type = account_type(options[:type] || :checking)
        super
      end
    
      def bankid
        @routing
      end

      def acctid
        @account
      end

      def accttype
        @type
      end

      private

      def account_type(type = :checking)
        case type
        when :savings then 'SAVINGS'
        when :money_market then 'MONEYMRKT'
        when :credit_line then 'CREDITLINE'
        when :checking then 'CHECKING'
        else raise Errors::AccountTypeNotAvailable.new(account_type: type)
        end
      end
    end
  end
end
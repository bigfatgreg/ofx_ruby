# frozen_string_literal: true
module OFX
  class Document
    class StatementRequest < StatementTransaction
      def initialize(options = {})
        super
      end

      def bank_account
        BankAccount.new(name: :bankacctfrom, routing: @routing,
                        account: @account)
      end
    
      def include_transactions
        IncludeTransactions.new(name: :inctran, start: @start, end: @end)
      end
    end
  end
end
